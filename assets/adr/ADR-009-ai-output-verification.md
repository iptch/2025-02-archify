# Standardize AI Output

## Date:
2025-02-15

## Status:
Accepted

## Decision Details
We will implement a layered approach combining LLM function calling, similarity-based human review, and content moderation to ensure structured and safe AI-generated grading outputs.

## Context:

Certifiable Inc. is automating exam grading using AI but must ensure that AI-generated outputs are accurate, safe, and consistently structured. The grading results must meet company standards, avoid harmful content, and follow a defined JSON format for downstream processing.

To achieve this, we must decide how to validate and constrain AI output. Several approaches exist:

1. Schema Validation – Enforce JSON format with strict validation.
2. Post-Processing Filters – Detect and remove harmful content or errors.
3. Human-in-the-Loop (HITL) – Experts review AI-generated scores.
4. Prompt Engineering – Use structured prompts to guide AI responses.
5. LLM Function Calling – Restrict AI to structured function outputs.

## Decision:
To ensure AI-generated grading is structured, safe, and reliable, we adopt a layered approach combining automation with human oversight:

1. **LLM Function Calling**:
    * The AI will call predefined functions that enforce a strict JSON output template, ensuring consistent and structured results.
    
2. **Similarity-Based HITL Review**: 
    * Responses that differ significantly from past graded answers will be flagged for human review, ensuring fairness and consistency.
    
3. **Content Moderation & Confidence Scoring**:
    * Automated filters will detect harmful content and flag low-confidence responses for additional checks.

### Why did we take this decision?
This approach minimizes errors, maintains structure, and ensures grading remains scalable while preserving accuracy and trust.


## Why did we take this decision?  
We chose this approach because it **balances automation with reliability** while ensuring scalability:  

* **Structured & Consistent Output** – LLM Function Calling prevents formatting errors and guarantees compliance with our predefined grading template.  

* **Improved Accuracy** – The **similarity-based HITL review** ensures that AI-generated grades align with past human-graded answers, reducing inconsistencies.  

* **Minimized Risk of Harmful Content** – A filtering layer proactively detects and removes inappropriate, biased, or misleading content before reaching candidates.  

* **Scalability with Human Oversight** – The AI handles most cases, but ambiguous or novel responses get human validation, ensuring quality without excessive manual workload.  

## Consequences  
* **Higher Initial Implementation Effort** – Setting up **function calling, content moderation, and similarity analysis** requires additional engineering effort.  

* **Possible False Positives in HITL Review** – Some valid but unique answers may be flagged unnecessarily, increasing human workload. This will need **fine-tuning over time**.  

* **Ongoing Model & Rule Updates** – As test cases evolve, **grading rules and similarity thresholds** will require periodic updates to maintain accuracy.  

* **Reduced AI Hallucinations & Formatting Issues** – Function calling and predefined templates significantly decrease unpredictable AI behavior.  
