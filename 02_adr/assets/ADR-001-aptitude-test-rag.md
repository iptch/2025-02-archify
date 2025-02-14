# ADR: Choosing RAG over Prompt Engineering, Fine-Tuning, and Full Model Training

## Date:
2025-02-13

## Status:
Proposed

## Context:
One part of the aptitude test consists of open-ended questions. Currently, human graders read and score each answer. While this worked with our original scale—around 200 new test-takers weekly—it will quickly become unmanageable as the certifying body expands to more countries, bringing up to ten times the volume.

We have a valuable dataset of 120k archived exams (A8). However, we must solve the following core challenge: how to efficiently and consistently grade new free-text responses using AI while ensuring that each score is grounded in correct knowledge, aligned with the certifier’s standards, and transparent enough for quality assurance.

Several AI approaches exist:

* Prompt Engineering: Rely on the model’s existing knowledge and craft prompts.
* Fine-Tuning: Extend a Large Language Model with domain-specific data.
* Full Model Training: Build a custom model from scratch.
* Retrieval-Augmented Generation (RAG): Leverage a retrieval engine to pull relevant textual evidence, then generate a score or explanation grounded in the retrieved data.

## Decision:

Adopt a RAG-based grading system that references curated exam content, guidelines, and rubrics when evaluating and scoring new textual answers.

### Why did we take this decision?

Our decision to adopt Retrieval-Augmented Generation (RAG) over fine-tuning or full model training was primarily driven by three key factors:

* Interpretability – The ability to trace and justify AI-generated grading decisions.
* Maintainability – The ease of updating and adapting the AI grading system over time.
* Cost Efficiency – The financial feasibility and sustainability of scaling the grading system.

Having these factors in mind, the following points led us to chose RAG:

* Frequent Knowledge Updates: RAG can be updated by modifying the underlying retrieval knowledge base without fully re-training or fine-tuning the model. This is critical when test content, grading rubrics, or regulatory requirements change—common in a multi-country operation.
* Grounded Grading: RAG ensures the AI’s judgments are based on actual, up-to-date content. This is crucial to reduce hallucinations and guarantee fair, accurate scoring.
* Data Efficiency: Fine-tuning or training a model from scratch would demand large, meticulously labeled datasets—especially for multiple countries and languages. RAG uses smaller, targeted retrieval sets, avoiding repeated model updates.
* Reduced Operational Overhead: Maintaining a vector database or search index for relevant grading materials is simpler and more agile than orchestrating repeated model retraining.

## Consequences:

* Implementation Complexity: We will maintain and scale a retrieval layer (e.g., vector database or similar "todo" -> link to adr) so the model can search relevant data efficiently. This adds infrastructure overhead compared to simple prompt engineering. Additionally there may be other components as part of RAG that bring complexity to the system. This will be adressed in other ADRs (todo).
* Lower Latency: Retrieval steps can introduce some overhead. We accept this consequence, because we have a relatively long time until the exam needs to be graded. There is no requirement for near real-time grading
* Continuous Maintenance: The RAG approach demands ongoing curation and updates to the knowledge base. This process, however, is less taxing than frequent model fine-tuning or re-training.