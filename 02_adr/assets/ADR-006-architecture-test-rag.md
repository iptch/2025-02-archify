# ADR: Choosing RAG over Prompt Engineering, Fine-Tuning, and Full Model Training

## Date:
2025-02-14

## Status:
Proposed

## Context:
After passing the initial aptitude test, candidates proceed to a second assessment phase—a case study in which each candidate designs an architecture. There are five possible case studies, randomly assigned. Candidates have two weeks to upload their final solution, after which expert software architects review and grade the submission within a week. An overall score of 80% is required to pass and receive certification.

We aim to automate (or semi-automate) the grading process for these architectural submissions. This poses unique challenges and opportunities:

* Diversity: Architectural solutions can vary significantly in approach while still meeting grading criteria.
* Expert Oversight: While automation is desired, the creative and evaluative nature of architectural design may still necessitate human review.

We already decided in a previous ADR (ADR-001)[todo:link] to leverage Retrieval-Augmented Generation (RAG) for short-answer grading. This ADR considers whether RAG is also the right approach for large, unstructured architectural submissions.

## Decision:

Adopt a RAG-based system to automate the preliminary grading of architecture case studies, augmented with a human-in-the-loop review.
The promting of the LLM will be augmented with the following relevant information: 

* Set of evaluation criteria for the given case study. 
* Set of past submitted exams for the same case study. 
* Factual technical information rlevant to the case study.

### Why did we take this decision?

Our decision to adopt Retrieval-Augmented Generation (RAG) over fine-tuning or full model training was primarily driven by the following factors:

* Grounded Evaluation: A key requirement is to ensure that each submission is scored according to the correct criteria for the specific case study. With RAG, we can integrate official grading rubrics and best-practice guidelines into a retrieval layer. The model’s output can reference these materials, increasing transparency and traceability.
* Easier Maintainbility: As architectural standards evolve or we introduce new case studies, we only need to update the knowledge base. This is simpler and cheaper than repeatedly fine-tuning or re-training an entire model whenever the exams or grading criteria change.


## Consequences:

The consequences are similar to (ADR-01 "todo" -> link). This problem introduces additional consequences that gain importance given the nature of the test:
* Risk of Over-Reliance: Given the subjective nature of architectural design, there is a risk that fully automated grading could overlook creative but valid solutions. This risk is mitigated by retaining human expert oversight as the final decision-maker.
* Data Demands: The effectiveness of the RAG system is based on a well-maintained, domain-specific knowledge base. Ongoing efforts will be required to keep a clean database. The biggest challenge relies in the fact that there is likely to be a huge variation in how old exams have been solved.
* Over Reliance: The simplicity of using a RAG for grading may induce that the grader over-relies on the proposed grading. We will try to mitigate this risk by designing a RAG output that helps the grader to reduce long-lasting operational efforts. (ADR-...)[todo: link to adr]

This decision to adopt RAG as an assistive tool, rather than a complete replacement for human grading, finds a balance between the needed scalability and the required imagination and interpretability while grading the exam