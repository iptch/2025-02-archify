Our software architecture contributions are modelled using the [C4 model](https://c4model.com/) approach.
This enables us to represent our ideas and contributions on different levels of abstractions.
For this we use the tool [Structurizr](https://structurizr.com/).

# Installation and Usage

To work on the architecture model, use your favorite container runtime and substitue `PATH` with the location where the `workspace.dsl` diagram is located:
```
docker pull structurizr/lite
docker run -it --rm -p 8080:8080 -v PATH:/usr/local/structurizr structurizr/lite
```


# System Context Diagram

## Software Systems
**Certifiable Inc. Existing Software System**: The exisiting IT systems of Certifiable Inc.. This includes the API Gateway, services and corresponding databases for registering candidates, taking and grading exams as well as notifying candidates.

**ARCHIFY AI Certification System**: The ARCHIFY AI system components integrates well into the existing infrastructure. This system reads ungraded exams from the aptitutde test ungraded database and the submission ungraded database, enriches them with relevant context and writes grade suggestions and feedback to the grade and feedback databases.

**Context Data Post-Processing**: The database that provides context for the LLM model is updated regularly with this system module.

**LLM Model**: ARCHIFY AI Certification handles prompt engineering, prompt context provisioning and guardrails, hence the LLM model can be any LLM API or a self-hosted model, that fulfils the criteria discussed in [ADR-003](../adr/ADR-003-model-choice.md)

TODO ![Context diagram](./images/structurizr-1-Diagram1.png)


## Actors
The following provides an overview of the actors in the system, excluding the administrator, as the tasks for the admin are not affected with the LLM integration changes.

| **Actor**                | **Description**                                                                       |
|--------------------------|---------------------------------------------------------------------------------------|
| Certification Candidate  | A certification candidate who uses the platform to be come a certified IT architect.  |
| IT Expert                | IT professional who is grading the candidates exam and providing feedback.            |
| ML Engineer              | Expert in LLM integration, maintaining the LLM systems and monitoring performance.    |

