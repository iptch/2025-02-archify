# ADR: Using RAG to provide context for the LLM grading process

## Date:
2025-02-13

## Status:
Accepted

## Context:
In this ADR, we decide how to provide context to LLMs, so they can grade examinations reliable and consistent.
Certifiable Inc. has an existing database of 120k archived and graded exams from previous examinations (A8). 
This database should be used to provide context to the LLM. The context can "teach" the LLM about:
- How exams should be graded
- What kind of answers to expect for each question
- How to provide feedback for wrong answers
- Align the scoring and feedback with the current standards from Certifiable Inc.

The following approaches exist to enhance an existing LLM models generations:
- Retrieval-Augmented Generation (RAG): Retrieves relevant information from external sources by comparing the similarity scores of the vector representations. This constructs specific context for each query.
- Fine-Tuning: Adapts/Re-trains an existing language model by training it on domain-specific data.
- Full training: Trains a new model from scratch rather than using an existing one.

## Decision:

Integrate RAG into our LLM based grading system. This enables us to 
1) Retrieve previous successfully answered exam questions reliable for grading the short-answer questionnaire. This is done by embedding question and answer tuples from previous exams into a vector, such that semantically similar questions can be retrieved and 
2) Retrieve relevant content in the 

### Why did we take this decision?

Our decision for RAG over fine-tuning was based on:

- Interpretability & Grounded Grading: Easy to trace which context was retrieved from the VectorDB for grading decisions. RAG ensures the LLM's context contains relevant, "truthful" and up-to-date content. This reduces hallucinations and makes it possible to provide fair and accurate scoring.
- Maintainability & Knowledge Updates: Simple updates to the knowledge base by upserting data in the VectorDB. Critical when test content or regulatory requirements change, as deleting context from a vector database is feasible, while removing data from neural network parameters (which is required after training) is complex and not guaranteed. Maintaining a vector database or search index for relevant grading materials is much simpler and more agile than orchestrating repeated model re-training. The re-training requires MLOps expertise.
- Cost Efficiency & Implementation Complexity: Lower operational costs and simpler management using a vector database compared to orchestrating ML DevOps pipelines for model training and fine-tuning

## Consequences:
- Low implementation complexity: RAG requires us to embedd our existing exam database in a vector database. In addition, a retrieval layer is required that translates natural language into vector representations and vice versa. The vector database and the embedding layer implementation have significantly less effort then orchestrating the re-training pipeline.
- Increased Latency: Retrieval steps can introduce some overhead, see e.g. [here](https://github.com/Tongji-KGLLM/RAG-Survey
). We accept this consequence, because we anyways process the exams in batch jobs and hence latency is not important. The latency comes from accessing the vector database and executing similarity searches to find the most relevant vectors, which depending on the chosen vector search algorithm (e.g., approximate nearest neighbors), adds computational cost. There is no requirement for near real-time grading.
- Continuous Maintenance: The RAG approach demands ongoing curation and updates to the knowledge base. This process, however, is less taxing than frequent model fine-tuning or re-training.
