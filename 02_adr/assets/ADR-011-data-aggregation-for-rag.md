# Vector Databases for RAG data

## Date:
2025-02-15

## Status:
Proposed

## Context:
In ADRxxx and ADRxxx we decided to use RAG to augment the promts for evaluating aptitude and architectural exams. 
As content we will use exam submissions for the same questions / case studies from the past. 
This data needs to be made available to the components promting the LLM.
We also need a way for the component to identify, which submissions to include in the context. 

There are the following ways to achieve this: 

1. Directly load relevant submissions from the graded exam databases. The correlation can be done over simple identifiers for the given exam variant. 
2. Pre-Process all submissions and integrate them in a Vector Database that can be used by the LLM Prompter. 

## Decision:

We choose implement a data pipeline to pre-process all submissions and relevant techniical information. 
The pre-processing includes transforming the data and sotring it in a vector databases accessible by the individual llm integrations.

### Why did we take this decision?

* Interpretability – With the vector database we can better identify relevant context as we can compare the actual contents entries instead of manually correlating them by the connected exam variant. 
* Reusability – The similarity score used for retrieving the relevant context can be reused for further processing. 
* Maintainability – With the vector databases we can define a format that is usable by the LLM integration. If the format of the input data changes we can handle this in the data pipeline layer and do not need to change the LLM integration itself. This 

## Consequences:

* Added complexity in initial implementation - The data pipeline needs to implemented, which will take significant effort. 
* Added complexity in maintenance - The data in the vector databses needs to stay up to date. This will take additional implementation effort. 
* Better accuracy - We can better idenfity relevant context quantify confidence in the AI output. 
