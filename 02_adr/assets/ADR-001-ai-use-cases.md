# AI Use Cases

## Date:
2025-02-13

## Status:
Proposed

## Context:

Certifiable wants to leverage AI to address scalability challenges in light of anticipated growth. Many potential AI applications could support this goal, but time and resources are limited. A strategic decision is required to identify the most impactful AI solutions and prioritize their implementation.

## Decision:

### Areas to focus on
We will focus on three key AI applications to improve scalability:

1. **Automating the grading process**: 
    * AI will assist with grading by analyzing responses, reducing manual effort. 
    * Aptitude test: Fully automated grading with minimal human review.
    * Architecture test: Automated grading with more human oversight.

2. **Managing test cases**: 
    * AI will create and maintain test cases, generating new ones from existing content and knowledge bases, including case study scenarios.

3. **Automating feedback generation**: 
    * AI will summarize exam results and provide personalized, actionable feedback to users.

### Areas to ignore 

We identified additional AI applications that will not be prioritized within this case study: 

* **Cheat Detection & Mitigation**: 
* **Analytics**
* **Grading Quality**

### Why did we take this decision?

The prioritized three use cases are ideal for AI, especially LLMs.
They involve repetitive tasks that require processing large amounts of text. 
AI can efficiently automate grading, test case creation, and feedback generation, scaling easily to meet growing demand.

We view **manual grading** as the primary barrier to scalability. 
The current process requires a fixed amount of time per exam, and as the volume of exams increases, 
Certifiable would struggle to maintain the desired one-week turnaround. 
While hiring additional experts could help, it won't be sufficient to meet future demand. 
Automation offers the flexibility to quickly scale up or down in response to fluctuations in demand, particularly in short-term or seasonal spikes. 
Given these factors, we conclude that automating the grading process is the most critical use case for improving scalability.

We consider **managing test cases** to be the second most important challenge. 
Maintaining test cases already requires significant manual effort.
As demand grows this workload will also increase. 
On one hand Certifiable must incorporate new technologies into the test cases to stay up to date.
On the other hand more candidates will require a greater variation in questions and case studies.
Automating test case management will help reduce manual effort and address scalability.
Additionally, the greater variation in text cases will reduce the need for extensive cheat detection and mitigation, allowing those efforts to be deprioritized for now.

**Automating feedback generation** will further reduce manual effort. 
While the potential savings are smaller compared to grading and test case management, the implementation effort is also less demanding. 
Summarizing feedback for graded exams is a task well-suited for large language models (LLMs). 


## Consequences:
* **Mistakes in the automated grading**:
    * With these use cases we automate some of the core business of Certifiable. Errors in these ares can be fatal to the company. 
    * We will need to define additional measures to minimize the impact errors of the AI has. 
    * We will also need to define measures to reduce the chance of the AI making errors. 
* Manual Labor will not be completely eliminated. This means that some scalability concerns remain unadressed. 
    * We accept this risk. Not soley relying on AI means t
    
* Missed Oportunities. By only prioritizing 3 use cases we miss out on additional improvements to be made in other areas. 
  * We accept this trade off. We can't implement everything at once. Doing the important stuff (the one with the largest impact) first allows to face immeadiat challanges. We can still do the other stuff later.  


  ### 3. Consequences

* **Mistakes in automated grading**: Errors in automated grading or generated test cases could severely impact Certifiable's reputation. To mitigate this, we will implement measures to minimize AI errors and ensure thorough monitoring and review processes.

* **Non deterministic grading**: Due to the nature of LLMs the automation of grading with AI can lead to non-deterministic results. We need to implement measures to address this.

* **Limited reduction in manual labor**: While AI will automate key tasks like grading and test case creation, some manual intervention will remain, leaving certain scalability concerns unaddressed. We accept this trade-off, as a balanced approach reduces dependency on AI alone.

* **Missed opportunities**: By prioritizing only three use cases, we will miss out on potential improvements in other areas. However, focusing on the most impactful tasks first allows us to tackle immediate challenges and leaves room for future enhancements.