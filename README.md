# Architecture & AI | O'Reilly Architectural Kata (Winter 2025)

Our solution for the O'Reilly Architectural Kata (Winter 2025)

- [Team](#team)
- [The Kata](#introduction)
- [Solution Summary](#summary)
- [Requirements](#requirements)
- [Driving Characteristics](#characteristics)
- [Architecture](#architecture)

## Team

(TODO) add pictures

- Manuel Kuchelmeister, [Linkedin](https://www.linkedin.com/in/m-kuchelmeister)
- Joshua Villing, [Linkedin](https://www.linkedin.com/in/joshua-villing-931078130)
- Ignacio de los Rios, [Linkedin](https://www.linkedin.com/in/ignacio-de-los-rios-ruiz-713150162)

## The Kata

Certifiable, Inc. is an accredited leader in the provisioning of software architect certifications. The current certification process requires candidates to pass two different tests: an aptitude test and an architecture case study. The evaluation of these exams and maintenance of the exam database heavily relies on manual work by IT experts. This manual approach has become a bottleneck as the demand for certified architects continues to grow. To address this challenge, Certifiable, Inc. needs to modernize its software architecture by incorporating AI approaches, allowing them to scale their certification process while maintaining high quality standards.

We present ARCHIFY, an innovative software component that seamlessly integrates with the existing software system of Certifiable, Inc. without requiring modifications of other components. ARCHIFY speeds up the certification evaluation process by leveraging a comprehensive existing database of 120,000 previously graded certifications. By enriching a Large Language Model (LLM) with this "historical" data, ARCHIFY generates both automated grading suggestions and detailed candidate feedback.

Our design prioritizes responsible AI integration by maintaining human oversight throughout the evaluation process. Rather than surrendering decision-making of the grading entirely to AI, ARCHIFY integrates IT experts as "human in the loop", ensuring accuracy and accountability in the certification assessment. This balanced approach addresses system bottlenecks, currently hindering scaling, while preserving the critical role of human expertise in the evaluation.

### Key Objectives

We identified the following key objectives:

1. Effective and Innovative AI Integration - Deliver a solution that incorporates generative AI in an **innovative** and **practical** way following industry best-practices
    * Our main contributions for this objective are: 
        * A deep analysis of which AI use cases can be implemented: [ADR-001](/assets/adr/ADR-001-ai-use-cases.md)
        * An interview with an expert for productive RAG systems: [Interview](workshops/01_use_cases/02_ai_interview.md)
        * A thorough analysis for the model decision: [ADR-003](/assets/adr/ADR-003-model.md)
2. Architectural Cohesion and Suitability - Deliver a solution integrates well with the current architecture
    * Our main contributions for this objective are: 
        * An ADR on how we want to integrate the AI within the existing architecture: [ADR-010](/assets/adr/ADR-010-system-integration.md)
3. Accuracy and Reliability of AI Outcomes -  We want that our solution contains mechanisms to maintain the **integrity**, **correctness** and **trustworthiness** of AI-generated results
    * Our main contributions for this objective are:
        * Human-in-the-loop approach: [ADR-002](assets/adr/ADR-002-human-in-the-loop.md)
        * Providing problem-specific context and instructions to the LLM: [ADR-004](assets/adr/ADR-004-provide-context-for-llm.md), [ADR-011](assets/adr/ADR-011-data-aggregation-for-rag.md), [ADR-012](assets/adr/ADR-012-knowhow-base.md)
        * Use input and output guardrails to add an additional layer of security: [ADR-005](assets/adr/ADR-005-aptitude-test-input-guradrails.md), [ADR-007](assets/adr/ADR-007-structured-output.md)

## Solution Summary

We propose to integrate AI within two areas of the Certifiable Inc. System: 

### Automating the grading process

The manual effort in the current process is the main barrier to scalability. 
We address this by automating large parts of the grading process for both aptitude short questions and the architectural case study. 

**Aptitude exam questions**: The majority of the exam questions will be graded by an AI system, which we chose to be a RAG component [ADR-02](assets/adr/ADR-002-human-in-the-loop.md). We decided to use a state of the art LLM API [ADR-03](assets/adr/ADR-003-model.md), being performance, context length and cost the main decision drivers. We propose an innovative solution to decide which exams will be corrected by a human grader and which exams will be graded by ARCHIFY [ADR-08](assets/adr/ADR-008-aptitude-test-split-for-grading.md). Additionally, we provide methods to secure our system both against malicious prompt injections [ADR-05](assets/adr/ADR-005-aptitude-test-input-guradrails.md)[ADR-13](assets/adr/ADR-013-prompt-template.md) and erroneous LLM outputs [ADR-07](assets/adr/ADR-007-structured-output.md)[ADR-09](assets/adr/ADR-009-aptitude-ai-output-verification.md). Another very important factor tha we considered is how we will enrich the LLM prompt: for the aptitude exam question, we will use our database with the 120k exams that were already corrected and graded. How these will be used has been decided in [ADR-12](assets/adr/ADR-012-knowhow-base.md) and [ADR-13](assets/adr/ADR-013-prompt-template.md)

**Architecture exam submission** will be automatically evaluated by an LLM. 
The prompt to the LLM will include the set of evaluation criteria as well as technical knowledge (e.g. books) for the given case study. 
The result of the automatic grading of architecture exam submissions will always be reviewed by a human. 

### Automating exam creation & maintenance

The second largest challenge Certifiable Inc. faces is maintenance of their exam base. 
With our solution we propose to automate parts of the maintenance process. 
AI will provide support for the creation and maintenance of architecture test cases, such that a human expert spends significantly less time. Creating new exams is done using existing knowledge bases and previously taken exams (including case study scenarios).
As with the automated grading process we want to keep the human in the loop. Generated questions and case studies will always be reviewed by a human before they are allowed to be used in exams.

### System Integration

Data needed to automate these use cases will be read directly from the databases of the existing Certifiable Inc. System. 
As there is no requirement for (near) realtime processing of data, this will be done by a polling mechanism within the new system components. 
Any output generated by the new system components will be written directly into the existing Certifiable Inc. Systems databases. 
This was the new review processes can be integrated into the existing solutions for grading exams. 


## Driving Characteristics

* Scalability
    * [ADR-001](/assets/adr/ADR-001-ai-use-cases.md)
* Maintainability
    * [ADR-001](/assets/adr/ADR-001-ai-use-cases.md)
    * [ADR-010](/assets/adr/ADR-010-system-integration.md)
* Data Consistency & Accuracy
    * [ADR-002](/assets/adr/ADR-002-human-in-the-loop.md)
    * [ADR-007](/assets/adr/ADR-007-structured-output.md)

## Requirements

We derive context that is relevant for our architecture contributions. Using the context, we formulate assumptions and requirements, that can be found in the [List of requirements and assumptions](./assets/requirements-and-assumptions.md).

In summary, we identified the following context (C), assumptions (A) and requirements (R) as most relevant and innovative:
#### Context
- C4: The manual grading process is quite time-intensive - 3 hours for aptitude tests and 8 hours for case studies, showing the significant human effort currently required.
- C9: Experts don't just grade - they're also responsible for analyzing reports and updating test questions, indicating a complex role beyond pure evaluation.
#### Assumptions
- A2: "Reasoning Models" from late 2024 can perform multi-step evaluations and align with human reasoning for grading architecture solutions. This suggests a significant advancement in AI capabilities specifically relevant to architecture evaluation.
- A6: Leveraging the database of old exams in two specific ways: either through extended context windows or RAG (Retrieval Augmented Generation), demonstrating a sophisticated approach to AI implementation.
- A10: The assumption that architectural diagrams are created in Structurizr DSL, making them machine-readable and processable by LLMs, is an important technical detail that could significantly impact the feasibility of automation.
#### Requirements
- R2: The requirement for "high accuracy and consistency" using the database of 120k solved exams to "enrich" the grading process, i.e. planning to use historical data to maintain grading standards.
- R5: The "human-in-the-loop" requirement focuses on having experts verify AI decisions and enrich the test database, indicating a hybrid approach rather than full automation.

These points together paint a picture of a sophisticated transition plan from manual to AI-assisted certification, with careful consideration for maintaining quality while scaling up operations.

## Architecture

### System Context (C1)

The software extension "ARCHIFY" integrates into the existing Certifiable Inc. software system and is visualized through [C4](https://c4model.com/) diagrams. showing how the new components interact with Certifiable Inc.'s existing software system. In the following, the system context diagram is visualized, click on the diagram to see a more detailed component description.

<div style="text-align: center">
  <a href="./assets/diagrams/C01-SystemContext.md">
      <img src="./assets/diagrams/SystemContext.png">
      <p>System Context Diagram, describing how ARCHIFY integrates into the existing software system.</p>
  </a>
</div>

The full Context diagram with the description of the Actors and Systems can be found [here](/assets/diagrams/C01-SystemContext.md).

### Container diagrams (C2)
<table>
  <tr>
    <td align="center">
      <a href="./assets/diagrams/C02-AptitudeContainer.md">
        <img src="./assets/diagrams/Container-Aptitude-Grading.png">
        <p>Aptitude Exam Automated Grading (C2)</p>
      </a>
    </td>
    <td align="center">
      <a href="./assets/diagrams/C02-ArchitectureContainer.md">
        <img src="./assets/diagrams/Container-Architecture-Grading.png">
        <p>Architecture Case Study Grading (C2)</p>
      </a>
    </td>
    <td align="center">
      <a href="./assets/diagrams/C02-MaintenanceContainer.md">
        <img src="./assets/diagrams/Container-Exam-Maintenance.png">
        <p>Exam & Question Generation (C2)</p>
      </a>
    </td>
  </tr>
</table>


### Component Diagrams

The component diagrams contain more detailed description of the design of the individual automation use cases: 

* [Aptitude Grading](/assets/diagrams/C03-AptitudeComponents.md)
* [Architecture Case Study Grading](/assets/diagrams/C03-ArchitectureComponents.md)
* [Exam Maintenance](/assets/diagrams/C03-MaintenanceComponents.md)


