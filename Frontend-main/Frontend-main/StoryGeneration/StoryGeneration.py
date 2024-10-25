import pandas as pd
import torch
from transformers import GPT2LMHeadModel, GPT2Tokenizer, AdamW, get_linear_schedule_with_warmup
from torch.utils.data import Dataset, DataLoader
import os
import openpyxl

class StoryDataset(Dataset):
    def __init__(self, data, tokenizer, max_length):
        self.data = data
        self.tokenizer = tokenizer
        self.max_length = max_length

    def __len__(self):
        return len(self.data)

    def __getitem__(self, idx):
        row = self.data.iloc[idx]
        story = row['story']
        programming_concept = row['programming_concept']
        inputs = self.tokenizer.encode("Once upon a time, " + story, add_special_tokens=True, max_length=self.max_length, truncation=True)
        return {
            'inputs': torch.tensor(inputs, dtype=torch.long),
            'programming_concept': programming_concept
        }

def data_preprocessing(dataset_path, max_length=128):
    data = pd.read_excel(dataset_path)
    tokenizer = GPT2Tokenizer.from_pretrained("gpt2")
    return StoryDataset(data, tokenizer, max_length)

def model_training(dataset, num_epochs=3, learning_rate=5e-5, batch_size=4):
    model = GPT2LMHeadModel.from_pretrained("gpt2")
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.to(device)
    
    dataloader = DataLoader(dataset, batch_size=batch_size, shuffle=True)
    optimizer = AdamW(model.parameters(), lr=learning_rate)
    scheduler = get_linear_schedule_with_warmup(optimizer, num_warmup_steps=0, num_training_steps=len(dataloader) * num_epochs)
    
    model.train()
    for epoch in range(num_epochs):
        print(f"Epoch {epoch + 1}/{num_epochs}")
        total_loss = 0
        for batch in dataloader:
            inputs = batch['inputs'].to(device)
            labels = inputs.clone()
            outputs = model(input_ids=inputs, labels=labels)
            loss = outputs.loss
            total_loss += loss.item()
            loss.backward()
            optimizer.step()
            scheduler.step()
            optimizer.zero_grad()
        print(f"Average Loss: {total_loss / len(dataloader)}")
    
    return model

def generate_story(programming_concept, genre, model_path="fine_tuned_model", max_length=100):
    model = GPT2LMHeadModel.from_pretrained(model_path)
    tokenizer = GPT2Tokenizer.from_pretrained("gpt2")
    
    prompt = f"Here is your story"
    input_ids = tokenizer.encode(prompt, return_tensors="pt", max_length=max_length, truncation=True)
    
    # Ensure attention mask is set to 1 for input tokens and 0 for padding tokens
    attention_mask = torch.ones(input_ids.shape, dtype=torch.long, device=input_ids.device)
    
    # Ensure pad_token_id is set to eos_token_id
    model.config.pad_token_id = tokenizer.eos_token_id
    
    output = model.generate(
        input_ids=input_ids,
        max_length=max_length,
        num_return_sequences=1,
        temperature=0.7,  # You can remove this parameter if do_sample=True
        do_sample=True,   # Enable sampling to use temperature
        attention_mask=attention_mask
    )
    
    generated_story = tokenizer.decode(output[0], skip_special_tokens=True)
    return generated_story

def main():
    dataset_path = r"C:\codesafari\StoryGeneration\Programming_Stories.xlsx"
    model_path = "fine_tuned_model"
    
    # Check if fine-tuned model exists
    if os.path.exists(model_path):
        print("Fine-tuned model found. Skipping training...")
    else:
        print("Fine-tuned model not found. Training the model...")
        dataset = data_preprocessing(dataset_path)
        model = model_training(dataset)
        model.save_pretrained(model_path)
        print("Model training completed.")
    
    programming_concept = input("Enter the programming concept: ")
    genre = input("Enter the genre: ")
    
    story = generate_story(programming_concept, genre, model_path=model_path)
    print("\nGenerated Story:")
    print(story)

if __name__ == "__main__":
    main()
