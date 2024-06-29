#!/usr/bin/env python
from flask import Flask, request, jsonify
from ai_helper_pipeline import *


def run_pipeline(question=None, doc_path=None):
    """
    This function runs the pipeline.
    """


    basic_rag_pipeline = init_pipeline(doc_path)
    connect_pipeline(basic_rag_pipeline)
    response = basic_rag_pipeline.run(
                                        {"text_embedder": {"text": question},
                                        "prompt_builder": {"question": question}}
                                        )
    return jsonify({'response': response["gemini"]["answers"][0]})



app = Flask(__name__)
app.config['DEBUG'] = True

basic_rag_pipeline = None

@app.route('/ai_request', methods=['POST'])
def ai_request():
    data = request.json
    if data is None:
        return jsonify({'response': 'No data provided'}), 400
    if data["question"] is None:
        return jsonify({'response': 'No question provided'}), 400
    if data["doc_path"] is None:
        return jsonify({'response': 'No doc_path provided'}), 400

    return run_pipeline(data["question"], data["doc_path"])

if __name__ == '__main__':
    # Run the app on a specified host and port (you can change these as needed)
    app.run(host='0.0.0.0', port=5000, debug=True)
