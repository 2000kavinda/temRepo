import os
import firebase_admin
from firebase_admin import credentials, firestore
from flask import Flask, request, jsonify
from pyngrok import ngrok
import google.generativeai as genai
import re

# Initialize Firestore
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

app = Flask(__name__)

class StoryGenerator:
    def __init__(self, api_key, language):
        os.environ['GOOGLE_API_KEY'] = api_key
        genai.configure(api_key=api_key)
        self.model = genai.GenerativeModel('gemini-pro')
        self.language = language

    def generate_story(self, concept, genre):
        try:
            prompt = f"Write a story for kids in {self.language} that explains the programming concept '{concept}' using a {genre} theme."
            response = self.model.generate_content(prompt)
            story = response.text
            return story
        except Exception as e:
            return f"Error generating story: {str(e)}"

    def generate_title(self, story_text):
        try:
            title_prompt = f"Provide a suitable title in {self.language} for this story: {story_text}"
            response = self.model.generate_content(title_prompt)
            title = response.text.strip()
            return title
        except Exception as e:
            return f"Error generating title: {str(e)}"

    def generate_mcqs(self, story_text, concept, num_questions=5):
        try:
            prompt = (
                f"Based on the following story, create {num_questions} multiple-choice questions that test whether kids have understood the programming concept '{concept}'. "
                f"Ensure the questions are directly related to the concept as presented in the story. Provide 4 answer options for each question and clearly indicate the correct answer. "
                f"Follow the structure below for each question:\n\n"
                f"**Question X:**\nQuestion text here\n"
                f"(A) Option A\n"
                f"(B) Option B\n"
                f"(C) Option C\n"
                f"(D) Option D\n"
                f"**Correct Answer: A**\n\n"
                f"Here is the story:\n\n{story_text}"
            )
            response = self.model.generate_content(prompt)
            mcqs = response.text.strip()
            return mcqs
        except Exception as e:
            return f"Error generating MCQs: {str(e)}"
        
    def parse_mcqs(self, mcqs_text):
        questions = []
        options_list = []
        correct_answers = []

        # Updated regex patterns to match the provided MCQ format
        question_pattern = r"\*\*Question \d+:\*\*\s*(.*?)\n"
        options_pattern = r"\(A\)\s*(.*?)\s*\n\(B\)\s*(.*?)\s*\n\(C\)\s*(.*?)\s*\n\(D\)\s*(.*?)\s*\n"
        correct_answer_pattern = r"\*\*Correct Answer:\s*(.*?)\*\*"

        # Find all questions, options, and correct answers
        questions_found = re.findall(question_pattern, mcqs_text, re.DOTALL)
        options_found = re.findall(options_pattern, mcqs_text)
        correct_answers_found = re.findall(correct_answer_pattern, mcqs_text)

        # Debugging: Print the number of matches found
        print(f"Questions found: {len(questions_found)}")
        print(f"Options found: {len(options_found)}")
        print(f"Correct answers found: {len(correct_answers_found)}")

        # Store extracted questions
        for question in questions_found:
            questions.append(question.strip())

        # Store extracted options
        for options in options_found:
            options_list.append({
                "A": options[0].strip(),
                "B": options[1].strip(),
                "C": options[2].strip(),
                "D": options[3].strip()
            })

        # Store extracted correct answers
        for answer in correct_answers_found:
            correct_answers.append(answer.strip())

        # Optional: Verify that the counts match
        if not (len(questions) == len(options_list) == len(correct_answers)):
            print("Warning: Mismatch in the number of questions, options, and correct answers.")
            # Handle the mismatch as needed

        return questions, options_list, correct_answers

    def generate_hints(self, story_text, mcqs):
        try:
            prompt = (
                f"Based on the following story and questions, generate a hint in {self.language} for each question to help "
                f"kids solve them. Here is the story:\n\n{story_text}\n\nHere are the questions:\n\n{mcqs}"
            )
            response = self.model.generate_content(prompt)
            hints = response.text.strip()
            return hints
        except Exception as e:
            return f"Error generating hints: {str(e)}"

@app.route('/generate_story', methods=['POST'])
def generate_story_endpoint():
    data = request.json    
    print(f"Received data: {data}")
    api_key = data.get("api_key")
    concept = data.get("concept")
    genre = data.get("genre")
    language = data.get("language")
    email = data.get("email")

    if not api_key or not concept or not genre or not language or not email:
        return jsonify({"error": "Missing required fields"}), 400

    story_generator = StoryGenerator(api_key, language)
    story = story_generator.generate_story(concept, genre)
    title = story_generator.generate_title(story)
    mcqs = story_generator.generate_mcqs(story, concept)
    hints = story_generator.generate_hints(story, mcqs)

    # Parse the generated MCQs to extract questions, options, and correct answers
    questions, options_list, correct_answers = story_generator.parse_mcqs(mcqs)

    # Save data to Firestore with the email and created date
    doc_ref = db.collection('stories').add({
        'title': title,
        'story': story,
        'mcqs': mcqs,
        'hints': hints,
        'concept': concept,
        'genre': genre,
        'language': language,
        'email': email,  # Store the email
        'created_at': firestore.SERVER_TIMESTAMP
    })

    # Return the extracted details in the response
    return jsonify({
        "message": "Story and MCQs generated successfully",
        "title": title,
        "story": story,
        "mcqs": mcqs,
        "hints": hints,
        "questions": questions,
        "options": options_list,
        "correct_answers": correct_answers
    }), 200

if __name__ == '__main__':
    # Setup ngrok tunnel
    ngrok.set_auth_token('2lYn6CjYZ7CcRnoiJwgx0isDi8z_6E9g3wVH7oaiZvrPVRXhe')
    url = ngrok.connect(5000)
    print(f" * Tunnel URL: {url}")
    app.run(port=5000)
