# Know-How Database 

## Date:
2025-02-16

## Status:
Proposed

## Context:
The grading of architectural exams and the generation of new exam questions require access to accurate technical knowledge. 
This technical knowledge is already available today in Certifiables knowledge base (See A11).
The relevant factual information needs to be made available to the components processing these tasks. 

## Decision:

* Vector database for technical knowledge – A dedicated vector database will store and structure relevant technical information, enabling efficient retrieval.
* Dedicated non-AI knowledge management system – A new system component within Certifiable will manage the creation, validation, and maintenance of technical knowledge.
* Data pipeline for aggregation and transformation – A processing pipeline will collect, preprocess, and structure knowledge before storing it in the vector database. 

### Why did we take this decision?

* Consistency – A structured knowledge base ensures accurate AI outputs. 
* Scalability & Maintainability – Decoupling the knowledge management system from AI processing enables reuse across multiple AI-driven tasks.


## Consequences:
* Increased implementation and maintenance effort – Building and maintaining the knowledge database, pipeline, and management system requires additional resources.
* Improved AI accuracy – AI outputs will be more consistent, explainable, and grounded in validated knowledge.
* Improved future proofing – New technical developments can be integrated into the know how database. This allows to generate
exams for new topics and consider latest developments when grading. 