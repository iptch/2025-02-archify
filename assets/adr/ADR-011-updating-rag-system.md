# Keep Vector Databases updated

## Date:
2025-02-15

## Status:
Accepted

## Decision Details
We will implement a periodically running data pipeline job to update the vector database with new (as successful evaluated) exam submissions. 
The same pipeline can be manually triggered and used for updating the knowledge base, e.g. to integrate new technical documents that can be retrieved to grade an exam.
This ensures up-to-date and accurate context retrieval in our RAG systems.

## Context:
In [ADR004](/assets/adr/ADR-004-provide-context-for-llm.md) and [ADR006](/assets/adr/ADR-006-architecture-test-rag.md), we decided to use RAG to enhance the prompts for evaluating aptitude and architectural exams. 
We provide exam submissions for the same questions / case studies from previous successfully passed examinations to the prompt orchestrator.

There are the following ways to achieve this: 
1. Directly load relevant submissions from the graded exam databases. The correlation can be done over simple identifiers for the given exam variant (e.g. when the exact same question is used repeatedly, use the question ID).
2. Embedd all submissions into vectors (similar as natural language is tokenized and then embedded into a vector space for the usage within LLM models) and store them in a Vector Database that can be used by the LLM Prompt Orchestrator. 

Both approaches require a separate data processing job, that keeps the databases updated.

## Decision:

We choose implement a data pipeline to process all successful submissions regularly and insert them into the RAG systems vector database using high-watermarking.

### Why did we take this decision?

Updating the vector database lets us keep up-to-date with the current question and case study catalog. It also enriches the vector database, as over time, more and more graded exams are available that can be used in future grading.

## Consequences:
### Technical Impact
- Need to implement and maintain a new data pipeline for processing exam submissions abc
- Must ensure reliable vector database operations and monitoring abc
- Additional infrastructure costs for running the vector database abc

### Operational Impact

- Regular monitoring needed to ensure pipeline reliability abc
- Need to establish backup and recovery procedures for the vector database abc
- May require additional team training for vector database operations abc

### Quality Impact

- More accurate context retrieval through semantic similarity matching abc
- Better ability to handle variations in exam submissions abc
- Improved maintainability through separation of concerns abc

