# Hybrid Approach for Aptitude Test Grading

## Date:
2025-02-15

## Status:
Accepted

## Decision Details
We will determine when human review is required by using vector similarity thresholds and random sampling in our automated grading system.

## Context:
We need to identify which questions in our automated grading system require human review. With a database of 120,000 graded exams, we're implementing a hybrid approach that combines RAG with selective human review.

## Decision:
#### Vector Similarity Threshold
We embedd the existing database with 120k graded exams as **question-answer** tuples in a vector database. By embedding questions and answers together, we are much less likely going to retrieve answers that belong to "other" questions, where the question context might be very different. For each exam question/answer tuple we need to grade, we compute the cosine similarity to relevant vectors in the database (this is done after applying [locality sensitive hashing](https://en.wikipedia.org/wiki/Locality-sensitive_hashing), one of the most common techniques for using vector databases to speed up retrieval). If the similarity is below a certain threshold (e.g., indicating new or unique content), the question will be forwarded to a human grader. The model still provides a grade that can then be reviewed by the ML expert, as this is valuable feedback for the model performance.

#### Random Sampling
Even if the similarity is above the threshold (implying confident matching), randomly sample a small percentage of these submissions for human review as a quality-control measure. Also these exams are graded by the model, and compared to the human-in-the-loop review, to check if the model outputs and IT experts results are aligned.

### Why did we take this decision?
- Confidence Alignment: Cosine similarity provides a straightforward way to measure how closely a new question aligns with historical data. Lower similarity implies unseen content and higher risk for AI misinterpretation.
- Scalability and Efficiency: This approach keeps the majority of grading automated while still offering a safety net for edge-case scenarios. Human graders can focus their efforts where the AI is least certain. Repetitive work will be reduced for graders, which will keep them motivated and intrigued.
- Continuous Improvement: Each human-reviewed instance (including the random checks of high-similarity questions) provides valuable data for refining both the vector database and the RAG model’s performance.

## Consequences:
- Implementation Complexity: We must integrate a vector similarity pipeline into the grading workflow, maintain threshold logic (fine-tuning the threshold is done by a hired ML expert), and manage random sampling.
- Reduced Grader Workload but Not Eliminated: 
  - Human effort becomes more targeted but remains necessary
  - Proper staffing and scheduling must account for peak periods when many submissions fall below the threshold
