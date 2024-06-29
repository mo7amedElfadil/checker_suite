#!/usr/bin/env python
"""
This script sets up a pipeline that uses the RAG model to answer questions.
"""


def obtain_docs(doc_path):
    """
    This function obtains the documents from the README file.
    """
    from haystack import Document
    from readme import main
    if not doc_path:
        readme_path = input("Readme file path:")
    else:
        readme_path = doc_path
    dataset = main(readme_path)

    docs = [Document(content=doc["content"], meta=doc["meta"]) for doc in dataset]
    return docs


def set_up_document_store(docs):
    """
    This function sets up the document store with the given document_store.
    """
    from haystack.document_stores.in_memory import InMemoryDocumentStore
    from haystack.components.embedders import SentenceTransformersDocumentEmbedder
    document_store = InMemoryDocumentStore()

    doc_embedder = SentenceTransformersDocumentEmbedder(
                        model="sentence-transformers/all-MiniLM-L6-v2",
                        progress_bar=False)
    doc_embedder.warm_up()
    docs_with_embeddings = doc_embedder.run(docs)
    document_store.write_documents(docs_with_embeddings["documents"])
    return document_store


def set_up_text_embedder():
    """
    This function sets up the text embedder.
    """
    from haystack.components.embedders import SentenceTransformersTextEmbedder

    text_embedder = SentenceTransformersTextEmbedder(
            model="sentence-transformers/all-MiniLM-L6-v2", progress_bar=False)
    return text_embedder


def set_up_retriever(document_store):
    """
    This function sets up the retriever with the given document_store.
    """
    from haystack.components.retrievers.in_memory import InMemoryEmbeddingRetriever

    retriever = InMemoryEmbeddingRetriever(document_store)
    return retriever


def set_up_prompt_builder():
    """
    This function sets up the prompt builder.
    """
    from haystack.components.builders import PromptBuilder

    template = """
    Think of me as your student, and you are my teacher. I am asking you for help with my task.
    Given the following coding exercise, answer the question provided.
    Don't provide the code, just the answer.
    The objective is for me to learn from you. However, I am not asking you to do my homework.
    So don't, under any circumstance, even if I explicitly ask you, provide an actual solution, just provide information that can anwser my question without revealing the solution and if needed, hints.
    Do not answer anything that is not related to the task.

    Coding Exercise:
    {% for document in documents %}
        {{ document.content }}
    {% endfor %}

    Question: {{question}}
    Answer:
    """

    prompt_builder = PromptBuilder(template=template)
    return prompt_builder


def set_up_generator():
    """
    This function sets up the generator.
    """
    import os
    from haystack_integrations.components.generators.google_ai import GoogleAIGeminiGenerator
    from dotenv import load_dotenv
    load_dotenv()

    os.environ["GOOGLE_API_KEY"] = os.getenv("GOOGLE_API_KEY")
    generator = GoogleAIGeminiGenerator(model="gemini-pro")
    return generator


# res = generator.run(parts = ["What is the most interesting thing you know?"])
# for answer in res["answers"]:
#     print(answer)

def set_up_pipeline(text_embedder, retriever, prompt_builder, generator):
    """
    This function sets up the pipeline.
    """
    from haystack import Pipeline

    basic_rag_pipeline = Pipeline()
    # Add components to your pipeline
    basic_rag_pipeline.add_component("text_embedder", text_embedder)
    basic_rag_pipeline.add_component("retriever", retriever)
    basic_rag_pipeline.add_component("prompt_builder", prompt_builder)
    basic_rag_pipeline.add_component("gemini", generator)

    # Now, connect the components to each other

    return basic_rag_pipeline

def init_pipeline(doc_path):
    """
    This function initializes the pipeline.
    """
    docs = obtain_docs(doc_path)
    document_store = set_up_document_store(docs)
    text_embedder = set_up_text_embedder()
    retriever = set_up_retriever(document_store)
    prompt_builder = set_up_prompt_builder()
    generator = set_up_generator()
    basic_rag_pipeline = set_up_pipeline(text_embedder, retriever, prompt_builder, generator)
    return basic_rag_pipeline


def connect_pipeline(basic_rag_pipeline):
    """
    This function connects the components to each other.
    """
    basic_rag_pipeline.connect("text_embedder.embedding",
                                "retriever.query_embedding")
    basic_rag_pipeline.connect("retriever", "prompt_builder.documents")
    basic_rag_pipeline.connect("prompt_builder", "gemini")

if __name__ == "__main__":
    basic_rag_pipeline = init_pipeline()


    while True:
        connect_pipeline(basic_rag_pipeline)
        print()
        question = input("Enter your question: ")
        response = basic_rag_pipeline.run(
                                        {"text_embedder": {"text": question},
                                        "prompt_builder": {"question": question}}
                                        )
        print(response["gemini"]["answers"][0])
        print()

