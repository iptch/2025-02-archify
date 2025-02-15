# Input Guardrails for Aptitude & Architecture Test

## Date:
2025-02-15

## Status:
Proposed

## Context:
Our certification platform uses an AI-driven grading system, incorporating Retrieval-Augmented Generation (RAG). There is a possibility that test-takers might embed malicious or confusing prompts within their responses to manipulate our AI system. Such prompt injections could cause the system to deviate from its intended grading logic, leading to incorrect outcomes. This creates a security concern for both the company.

The following points were taken into consideration:
* Security & Trust: An unguarded system risks exploitation, damaging the credibility of our certification process.
* Implementation Complexity: Building robust guardrails adds development and maintenance overhead. This might involve input sanitization, detection heuristics, or advanced methods for context isolation.
* False Positives & Negatives: Aggressive filtering could incorrectly flag legitimate inputs and add more work for human graders. Weak filters might fail to catch malicious injections and our company could lose credibility.

## Decision:
We chose to implement guardrails to ensure that our system is safe against malicious prompt injection.

### Why did we take this decision?
* Maintaining Assessment Integrity: A compromised grading engine reduces confidence in our certification process. Guardrails help ensure consistent performance.
* Practical Feasibility: Guardrail solutions can range from regex-based filtering to more advanced LLM-based anomaly detection. We will start with a simple implementation and leave room for future improvements.
* Risk Management: If it is known that our platform is not secure against malicious prompt injections, the impact on our companys reputation could be fatal and it would lead to a loss in market share.

## Consequences:
* Added Complexity & Costs: Implementing guardrails will require ongoing updates to detection logic and user feedback flows. This can increase development and human grading overhead.
* Increased Platform Confidence: Properly handling potential injection attacks preserves grading integrity, mitigating reputational and legal risks.
* Future Flexibility: Once in place, input guardrails can be refined to handle new threats or unusual text patterns without fully overhauling the system.