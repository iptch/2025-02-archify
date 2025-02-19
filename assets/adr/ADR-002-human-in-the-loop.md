# Human-in-the-Loop Grading  

## Date:  
2025-02-15  

## Status:  
Accepted  

## Decision Details
Human oversight will be maintained in the AI-assisted grading process, with full review for architecture exams and partial review for aptitude tests.

## Context:  
In [ADR-001](ADR-001-ai-use-cases.md), we decided to automate the grading process for aptitude and architectural exams. However, AI-generated output is **non-deterministic** and may contain **errors or harmful content**. Since certification results have a **significant impact on an individual’s career**, it is **crucial to ensure grading accuracy and fairness**.  

We identified three possible approaches for human oversight in AI-assisted grading:  

1. **No human oversight** – AI output is validated solely through technical measures, with no human intervention.  
2. **Full human oversight** – AI provides an initial grading, but every result is reviewed and verified by a human.  
3. **Partial human oversight** – AI fully grades exams, but technical measures identify cases requiring human intervention. 

## Decision:  
We chose different levels of human oversight for aptitude and architectural exams:  

1. **Partial human oversight for aptitude tests**  
2. **Full human oversight for architecture tests**  

### Why did we take this decision?  

We aim to **maximize scalability** without compromising **accuracy, and fairness**. Completely eliminating human oversight is not a viable option, as AI cannot guarantee perfect accuracy.  

- **Aptitude tests** consist mostly of structured, well-defined questions that **LLMs handle effectively**. Human review can be triggered on a **question-by-question basis** when needed, minimizing manual effort.  
- **Architecture case studies** require **complex reasoning and nuanced judgment** that are harder to verify automatically. Even with AI assistance, full human oversight is necessary to maintain grading accuracy and fairness. Grading the architecture test takes a large amount of time. Even without fully automating the process we can gain significant time savings.

## Consequences:  

- **Increased efficiency** – AI automation significantly reduces grading time, particularly for aptitude tests, while maintaining accuracy.  
- **Maintained grading integrity** – Human oversight ensures errors or biases in AI-generated evaluations are corrected.  
- **Additional operational complexity** – A system must be in place to determine when human review is required, and manual review processes need to be integrated smoothly.  
- **Potential inconsistencies in human-reviewed cases** – Different human reviewers may interpret AI-generated grades differently, requiring clear guidelines to ensure consistency.  

