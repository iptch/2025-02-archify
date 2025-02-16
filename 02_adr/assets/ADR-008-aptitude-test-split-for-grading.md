# Chose A hybrid Approach for Aptitude Testing

## Date:
2025-02-15

## Status:
Proposed

## Context:
We have decided on a hybrid approach for grading text responses using Retrieval-Augmented Generation (RAG) combined with selective human review. A practical challenge is determining how to identify the subset of questions or answers that need human attention.

## Decision:
* Vector Similarity Threshold: For each exam question/answer, compute the cosine similarity with relevant vectors in the database. If the similarity is below a set threshold (e.g., indicating new or unique content), route the question to a human grader. (todo: should we also grade this exam and use it as feedback for the model?)
* Random Sampling: Even if the similarity is above the threshold (implying confident matching), randomly sample a small percentage of these submissions for human review as a quality-control measure. (todo: should we also grade this exam and use it as feedback?)

### Why did we take this decision?
* Confidence Alignment: Cosine similarity provides a straightforward way to measure how closely a new question aligns with historical data. Lower similarity implies unseen content and higher risk for AI misinterpretation.
* Scalability and Efficiency: This approach keeps the majority of grading automated while still offering a safety net for edge-case scenarios. Human graders can focus their efforts where the AI is least certain. Repetitive work will be reduced for graders, which will keep them motivated and intrigued.
* Continuous Improvement: Each human-reviewed instance (including the random checks of high-similarity questions) provides valuable data for refining both the vector database and the RAG model’s performance.

## Consequences:
* Implementation Complexity: We must integrate a vector similarity pipeline into the grading workflow, maintain threshold logic (ADR?), and manage random sampling.
* Reduced Grader Workload but Not Eliminated: Human effort becomes more targeted but still necessary. Proper staffing and scheduling must account for peaks when many submissions fall below the threshold. Given the structure of the business model (hiring consultants on an hourly wage, we accept this risk, as we consider that they are more flexibel)