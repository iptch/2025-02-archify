# Automated Architecture Case Study Grading (C3)

![Container diagram](./Component-Architecture-Grading.png)

### Architecture Submission Service

This component is part the existing Certifiable Inc. system. 
It provides a way for candidates to submit their solutions to a case study. 

### Architecture Manual Grader

This component is part the existing Certifiable Inc. system.
The manual grader is used by Certifiable Inc. IT Experts to evaluate submitted case studies. 
The graded results are stored in the submission graded database. 

### Submission Ungraded Database

This component is part the existing Certifiable Inc. system.
The submission ungraded database contains submitted but ungraded case studies. 

### Submission Graded Database

This component is part the existing Certifiable Inc. system.
The submission  graded database contains graded case studies and the feedback/result of the grading. 

### Architecture Autograding Adapter

This component is a gateway between the new Archify AI system and the existing Certifiable Inc. System.
It regularly reads ungrded case studies together with the relevant evaluation criteria from the submission ungraded database .
The result of automatic grading is written into the submission graded database ([ADR-010](/assets/adr/ADR-010-system-integration.md)).
The actual propmting of the LLM is delegated to the Architecture Autograding PromtOrchestrator.

### Architecture Promt Orchestrator

The promt orchestrator uses the Knowledge Vector Database to identify technical knowledge that is relevant for grading a given case study. 
It then constructs a promt to grade a complete case study using a template [ADR-013](/assets/adr/ADR-013-prompt-template.md). 
The promt includes the complete case study submission, the associated evaluation criteria and relevant technical context ([ADR-006](/assets/adr/ADR-006-architecture-test-rag.md)).
The constructed prompt is is sent to the LLM via the guard rails component.

### Architecture Guard Rails Component

The guard rails component is responsible for sanitizing input and output for the LLM. 
Promts received from the orchestrator are sanitized to prevent prompt injection ([ADR-005](/assets/adr/ADR-005-input-guradrails.md)). 
Output from the LLM is checked for harmful content. 
Additionally it is verified, that the received output has to correct structured format ([ADR-009](/assets/adr/ADR-009-aptitude-ai-output-verification.md)).

### Knowledge Data Updater

The knowledge data updater is responsible for pre-processing context data that can be used to augment LLM promts. 
It regularly reads data from Certifiable Inc. knowledge base and embeds the data into vector space ([ADR-011](/assets/adr/ADR-011-data-aggregation-for-rag.md)). 
The created vectors can be used to identify relevant technical context for grading architectural case studies 
and generating new exam questions / case studies ([ADR-006](/assets/adr/ADR-006-architecture-test-rag.md)).

### Knowledge Vector Database

Contains Q&A data used to evaluate similarity between existing question asnwers and new exam submissions.

### LLM Model 

See [C01-SystemContext](./C01-SystemContext.md)