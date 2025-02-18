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

Certifiable, Inc. is an accredited leader in software architecture certification.
The current certification process requires candidates to pass two different tests: an aptitude test and an architecture submission.
Large parts of the evaluation process for submitted exams as well as maintenance of the exam base is done manually by IT experts. 

In the face of legislature changes Certifiable expects a significant growth.
It is expected that within four years the number of candidates taking the exams will increase tenfold. 
This is reason for concern, as the manual processes will likely not be able to scale up to the increased demand. 

Certifiable Inc. wants to leverage AI to address scalability challenges in light of the anticipated growth.
The task for this Kata is to provide a solution how this could be done. 

## Solution Summary

We propose two areas in which to levarage AI. 

### Automating the grading process
    * Aptitude test: Fully automated grading with minimal human review
    * Architecture test: Automated grading and feedback suggestions with more human oversight.

### Automating exam creation & maintenance
    * AI will provide support for the creation and maintenance of architecture test cases, such that a human expert spends significantly less time. Creating new exams is done using existing knowledge bases and previously taken exams (including case study scenarios).

## Driving Characteristics

* Scalability
    * [ADR-001](/assets/adr/ADR-001-ai-use-cases.md)
* Maintainability
    * [ADR-001](/assets/adr/ADR-001-ai-use-cases.md)
* Data Consistency & Accuracy
    * [ADR-002](/assets/adr/ADR-002-human-in-the-loop.md)

## Architecture

### System Context

### Aptitude Exam Automated Grading

### Architecture Case Study Grading

### Exam & Question Geneartion


## Requirements

TODO: define choice of requirements

- Ci (f.ex. [C1](/01-requirements/requirements-and-assumptions.md)) , for constraints
- Ri (f. ex. [R1](/01-requirements/requirements-and-assumptions.md)), for functional requirements
- Qi (f.ex. [Q1](/01-requirements/requirements-and-assumptions.md)), for non-functional requirements
- Ai (f. ex. [A1](/01-requirements/requirements-and-assumptions.md)) , for assumptions

We typically link to the file, but due to markdown limitations, the specific entry can not be referenced in the link.
