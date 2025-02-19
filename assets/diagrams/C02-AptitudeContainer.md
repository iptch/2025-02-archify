# Automated Aptitude Grading (C2)

![Automated Aptitude Container Diagram](./Container-Aptitude-Grading.png)

## Containers

### Certifiable Aptitude Grading Module

This container represents a part the existing Certifiable Inc. system. 
It contains the parts that are relevant for the current manual grading process. 
This most notably includes databases for graded and ungraded exam questsions 
as well as existing infrastructure for manual grading. 

### Archify Aptitude Exam Grading

This container represents the new components that will automate the grading process ([ADR-001](/assets/adr/ADR-001-ai-use-cases.md)). 
Exams that need to be graded are read from the existing certifiable system. 
Exams are sent to an LLM for grading. 
It is decided for each question, whether human review is required or not ([ADR-008](/assets/adr/ADR-008-aptitude-test-split-for-grading.md)). 
The graded exams are then sent back to the existing certifiable system ([ADR-010](/assets/adr/ADR-010-system-integration.md)). 

### Aptitude Q&A Data Pipeline

This container is responsible for pre-processing data that is required to augment LLM promts. 
In the aptitude grading use case this includes reading known accepted answers for questions and embedding them into a vector database. 
This vector database can be used to identify similar answers to enhancve the LLM promts ([ADR-004](/assets/adr/ADR-004-provide-context-for-llm.md)). 

### LLM Model

See [C01-SystemContext](./C01-SystemContext.md)