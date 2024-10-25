import os
import textwrap
import google.generativeai as genai

class StoryGenerator:
    def __init__(self, api_key, language):
        os.environ['GOOGLE_API_KEY'] = api_key
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        self.language = language

    def generate_story(self, concept, genre):
        prompt = f"Write a story for kids in {self.language} that explains the programming concept '{concept}' using a {genre} theme."
        response = self.model.generate_content(prompt)
        story = response.text
        return story

    def generate_title(self, story_text):
        title_prompt = f"Provide a suitable title in {self.language} for this story: {story_text}"
        response = self.model.generate_content(title_prompt)
        title = response.text.strip()
        return title

    def generate_mcqs(self, story_text, concept, num_questions=5):
        prompt = (
            f"Based on the following story, create {num_questions} multiple-choice questions in {self.language} "
            f"that test whether kids have understood the programming concept '{concept}'. Ensure the questions "
            f"are directly related to the concept as presented in the story. Provide 4 answer options for each "
            f"question and indicate the correct answer. Here is the story:\n\n{story_text}"
        )
        response = self.model.generate_content(prompt)
        mcqs = response.text.strip()
        return mcqs

    def generate_hints(self, story_text, mcqs):
        prompt = (
            f"Based on the following story and questions, generate a hint in {self.language} for each question to help "
            f"kids solve them. Here is the story:\n\n{story_text}\n\nHere are the questions:\n\n{mcqs}"
        )
        response = self.model.generate_content(prompt)
        hints = response.text.strip()
        return hints

    def display_content(self, title, story, mcqs, hints):
        print(f"Title: {title}")
        print("\nStory:\n")
        wrapped_story = textwrap.fill(story, width=80)
        print(wrapped_story)
        
        print("\nGenerated MCQs:\n")
        wrapped_mcqs = textwrap.fill(mcqs, width=80)
        print(wrapped_mcqs)

        print("\nHints for the Questions:\n")
        wrapped_hints = textwrap.fill(hints, width=80)
        print(wrapped_hints)

    def create_story_with_mcqs_and_hints(self, concept, genre):
        # Generate story based on inputs
        story = self.generate_story(concept, genre)

        # Generate title based on the story
        title = self.generate_title(story)

        # Generate MCQs based on the story and the programming concept
        mcqs = self.generate_mcqs(story, concept)

        # Generate hints for the MCQs
        hints = self.generate_hints(story, mcqs)

        # Display the title, story, MCQs, and hints
        self.display_content(title, story, mcqs, hints)

# Usage Example
if __name__ == "__main__":
    api_key = "AIzaSyBIiTogO5dybROEfWlvZt2KHsc06PVOeWg"
    concept = input("Enter the programming concept (e.g., loops, variables, functions): ")
    genre = input("Enter the desired story genre (e.g., fantasy, adventure): ")
    language = input("Enter the preferred language (English or Tamil): ")

    if language.lower() not in ['english', 'tamil']:
        print("Invalid language selection. Please choose either 'English' or 'Tamil'.")
    else:
        story_generator = StoryGenerator(api_key, language.capitalize())
        story_generator.create_story_with_mcqs_and_hints(concept, genre)
