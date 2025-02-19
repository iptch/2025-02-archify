# ADR: Using RAG to enrich context for the architecture case study exam

## Date:
2025-02-14

## Status:
Accepted

## Decision Details
We will use RAG to provide AI-assisted preliminary grading of architecture case studies, while maintaining human expert review of the AI's suggested grades and feedback.

## Context:
After passing the initial aptitude test, candidates proceed to a second assessment phase—a case study in which each candidate designs an architecture. There are five possible case studies, randomly assigned. Candidates have two weeks to upload their final solution, after which expert software architects review and grade the submission within a week. An overall score of 80% is required to pass and receive certification.

We aim to automate (or semi-automate) the grading process for these architectural submissions. This poses unique challenges and opportunities:

- Diversity: Architectural solutions can vary significantly in approach while still meeting grading criteria.
- Expert Oversight: While automation is desired, the creative and evaluative nature of architectural design may still necessitate human review.

We already decided in [ADR-004](ADR-004-provide-context-for-llm.md) to leverage Retrieval-Augmented Generation (RAG) for short-answer grading. This ADR considers whether RAG is also the right approach for large, unstructured architectural submissions.

## Decision:

Use a RAG-based system to enhance the preliminary grading of architecture case studies, where a human-in-the-loop reviews suggested feedback and grading by the LLM.
The prompting of the LLM will be augmented with the following relevant information: 

- Set of evaluation criteria for the given case study.
- Set of past submitted exams for the same case study.
- Factual technical information relevant to the case study (see assumption A11).

### Why did we take this decision?
- We gain the same benefits as already discussed in [ADR-004](ADR-004-provide-context-for-llm.md).
- Grounded Evaluation: A key requirement is to ensure that each submission is scored according to the correct criteria for the specific case study. With RAG, we can integrate official grading rubrics and best-practice guidelines into a retrieval layer. The model's output can reference these materials, increasing transparency and traceability.
- Easier Maintainability: As architectural standards evolve or we introduce new case studies, we only need to update the knowledge base. This avoids the huge operational overhead that would be required for repeatedly fine-tuning the model.
- Interpretability: Since we can inspect exactly what context is provided to the model for each grading decision, we can better understand and validate the basis for its evaluations. This transparency helps in quality assurance and continuous improvement of the grading process.

## Consequences:

The consequences are similar to [ADR-004](ADR-004-provide-context-for-llm.md). This problem introduces additional consequences that gain importance given the nature of the test:
- Risk of Over-Reliance: Given the subjective nature of architectural design, there is a risk that partially automated grading suggestions could overlook creative but valid solutions. This risk is mitigated by retaining human expert oversight as the final decision-maker.
- Data Demands: The effectiveness of the RAG system is based on a well-maintained, domain-specific knowledge base. Ongoing efforts will be required to keep a clean database. The biggest challenge relies in the fact that there is likely to be a huge variation in how old exams have been solved.
- Over Reliance: The simplicity of using a RAG for grading may induce that the grader over-relies on the proposed grading. We will try to mitigate this risk by designing a RAG output that helps the grader to reduce long-lasting operational efforts [ADR-002](ADR-002-human-in-the-loop.md).

This decision to adopt RAG as an assistive tool, rather than a complete replacement for human grading, finds a balance between the needed scalability and the required imagination and interpretability while grading the exam.
