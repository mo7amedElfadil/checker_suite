#!/usr/bin/env python
import requests

questions = ["Can you provide a clear and concise descriptions of the programming challenge?", "Can you tell me what I'm doing wrong here with relation to the context of the task?", "How can I improve my code?"]
paths = ["../py_suite/0x08-python-more_classes/8-rectangle.md", "../py_suite/0x08-python-more_classes/8-rectangle.py", "../py_suite/0x08-python-more_classes/8-rectangle.py"]
# Define the data to send

def make_request(question, path):
    data = {'question': question,
            'doc_path': path}

    print(f"Question: {question}")
    # Make a POST request to your API
    response = requests.post('http://0.0.0.0:5000/ai_request', json=data)
    if response.text:
        data = response.json()
        print(data['response'], end='\n\n')
    else:
        print("Empty response received")
# Print the response
for question, path in zip(questions, paths):
    make_request(question, path)
