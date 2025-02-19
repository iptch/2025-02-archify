# AI Use Cases

## Date:
2025-02-13

## Status:
Accepted

## Decision Details
We will implement AI primarily for exam grading automation and test case management, while deprioritizing other potential AI applications like cheat detection and analytics.

## Context:

Certifiable wants to leverage AI to address scalability challenges in light of anticipated growth. Many potential AI applications could support this goal, but time and resources are limited. A strategic decision is required to identify the most impactful AI solutions and prioritize their implementation.

## Decision:

### Areas to focus on
We will focus on two key AI applications. Our expectation is that these two applications can save the most amount of "expert human hours" and hence will improve scalability:

1. **Automating the grading process**: 
    * AI will assist with grading by analyzing responses, reducing manual effort. 
    * Enriching the AI usage by integrating the 120k existing graded exams in the grading context, which stream-lines and enhances the AI grading.
    * Aptitude test: Fully automated grading with minimal human review.
    * Architecture test: Automated grading and feedback suggestions with more human oversight.

2. **Managing test cases**: 
    * AI will provide support for the creation and maintenance of architecture test cases, such that a human expert spends significantly less time. Creating new exams is done using existing knowledge bases and previously taken exams (including case study scenarios).

### Less important opportunities  

We identified additional AI applications that will not be prioritized within this case study: 

* **Cheat Detection & Mitigation**: 
* **Analytics**
* **Grading Quality**
* **Automating feedback generation**

### Why did we take this decision?

The prioritized three use cases are ideal for LLMs.
Grading exams involves repetitive tasks (e.g. when the same question appears in multiple exams) and can require processing large amounts of text. 
LLMs can efficiently automate grading and feedback provisioning as well as creating new tests and case studies. In addition, scaling is possible based on demand.

We view **manual grading** as the primary barrier to scalability.
The current process requires a fixed amount of time per exam, and as the volume of exams increases, Certifiable would struggle to maintain the desired one-week turnaround while keeping the same grading quality.
While hiring additional experts could help, it won't be sufficient to meet future demand.
Automation offers the flexibility to quickly scale up or down in response to fluctuations in demand, particularly in short-term or seasonal spikes. 
Given these factors, we conclude that automating the grading process is the most critical use case for improving scalability.

We consider **managing test cases** to be the second most important challenge. 
Maintaining test cases requires significant manual effort.
As demand grows, the management workload will increase, as there is the requirement to have more variation in test questions and case studies when there are more candidates taking the exams.
In addition, Certifiable must incorporate new technologies into the test cases to stay up to date.
Automating test case management will help reduce manual effort and address scalability.
Additionally, the greater variation in text cases will reduce the need for extensive cheat detection and mitigation, allowing those efforts to be deprioritized for now.

## Consequences:
* **Mistakes in the automated grading**:
    * With these use cases we automate some of the core business of Certifiable. Errors in these ares can be fatal to the company.
    * We will need to define additional measures to minimize the impact errors of the AI has.
    * We will also need to define measures to reduce the chance of the AI making errors.
* Manual Labor will not be completely eliminated. This means that some scalability concerns remain unadressed.
    * We accept this risk. Not soley relying on AI means that we still have a demand for human experts that could become the bottleneck, when scaling the exam takers out-paces the hiring of new IT experts.
* Missed Oportunities. By only prioritizing 3 use cases we miss out on additional improvements to be made in other areas. 
  * We accept this trade off. We can't implement everything at once, and decided to foucs on the tasks that enable us to save the most human hours. In addition, we can add the other LLM use-cases at a later stage.

### 3. Consequences

* **Mistakes in automated grading**: Errors in automated grading or generated test cases could severely impact Certifiable's reputation. To mitigate this, we will implement measures to minimize AI errors and ensure thorough monitoring and review processes. Especially in the beginning of embedding LLMs in the grading process, we let human experts manually investigate all of the grading and feedback provisioning to confidentally estimate the LLM capabilities, before making use of more and more automatic grading.

* **Non deterministic grading**: Due to the nature of LLMs the automation of grading with AI can lead to non-deterministic results. We need to implement measures to address this.

* **Limited reduction in manual labor**: While AI will automate key tasks like grading and test case creation, some manual intervention will remain, leaving certain scalability concerns unaddressed. We accept this trade-off, as a balanced approach reduces dependency on AI alone.

* **Missed opportunities**: By prioritizing only three use cases, we will miss out on potential improvements in other areas. However, focusing on the most impactful tasks first allows us to tackle immediate challenges and leaves room for future enhancements.
