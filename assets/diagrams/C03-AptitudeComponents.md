# Automated Aptitude Grading (C3)

![Container diagram](./Component-Aptitude-Grading.png)

## Components

### Aptitude Test Taker

This container represents a part the existing Certifiable Inc. system. 
The component is responsible for executing the exams provides the ungraded database. 

### Aptitude Manual Capture

This container represents a part the existing Certifiable Inc. system. 
The component receives the short question parts of the aptitude exam and writes them into the ungraded database.

### Aptitude Auto Grader

This container represents a part the existing Certifiable Inc. system. 
The component receives the multiple choice parts of aptitude questions applies automated grading writes the graded questions to the graded database. 

### Ungraded Database

This container represents a part the existing Certifiable Inc. system. 
This database contains the ungraded submissino for aptitude exam short questions.

### Graded Database

This container represents a part the existing Certifiable Inc. system. 
This database contains the graded submissino for aptitude exam short questions.

### Aptitude Autograding Adapter

This component is the gateway between the new Archify AI system and the existing Certifiable Inc. System.
It regularly reads ungrded exam questions from the ungraded database.
The result of automatic grading is written into the graded database.  
The actual propmting of the LLM is delegated to the Aptitude PromtOrchestrator.

### Aptitude Promt Orchestrator

The promt orchestrator uses the Aptitude Q&A Vector Database to identify similar question answers, that can be used as context when prompting the LLM. 

### Aptitude Guard Rails Component

### Aptitude Data Updater

### Aptitude Q&A Data Pipeline

### LLM Model 

See [C01-SystemContext](./C01-SystemContext.md)