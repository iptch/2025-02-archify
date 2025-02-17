# Assumptions and Requirements
In this document, we derive context that is relevant for our architecture contributions. Using the context, we formulate assumptions and requirements. We use the short-hand notations C, A and R for contexts, assumptions and requirements. C1(A1,A2) indicates that context statement C1 depends on or is based on the assumptions A1 and A2. Missing numbers in the enumeration indicate deleted statements.

## Context (C)
- C1: The Software Architect profession becomes a licensed profession, implying that the number of IT experts seeking a software architect license is expected to grow. Certifiable Inc. expects 5-10x demand growth.
- C3: The certification process consists of two sub-processes, an **aptitutde test** and an **architecture case study**. Both are graded manually (except for some multiple choice part) and for both tests, the candidate gets detailed feedback.
- C4: The grading process and the feedback provisioning takes, on average, 3h for the aptitute test and 8h for the case study. The grading is done by an externally hired IT expert (in the following referred to as _expert_).
- C6: There is a **1 week turnaround time** for the grader for each, aptitude and case study tests. While the aptitude test is time boxed to avoid cheating, the architecture test has to be solved within 2 weeks.
- C7: Taking the exam costs a participant 800$, experts are paid 50$ per hour. Currently there are 300 experts hired for the grading.
- C8: 120 000 IT architects have already been certified by Certifiable Inc..
- C9: The experts are also responsible for analysing reports and manual processes for updating test questions and new case study creations.
- C10: _Administrators_ maintain the certified architects database.
- C11: To maintain its market leadership and candidate trust, Certifiable Inc. has to keep the accuracy of the grading process at the same level.
- C12: Candidates, especially when they failed an exam, require detailed feedback.

## Assumptions (A)
- A1: LLMs can be used via [LLM-as-a-Judge](https://arxiv.org/abs/2306.05685) approach to automate evaluation tasks on the human level. In the linked research, models reach 80% agreement, the same level of agreement between humans.
- A2 (A1): Reasoning Models, which only occurred in the end of 2024, can perform multi-step evaluations, generate reasonable explanations and align with human reasoning for architecture solutions. 
- A3: AI generated feedback can meet the quality and detail required to evaluate candidates (e.g. to identify partially correct answers, explain flaws in the architecture)
- A4: AI can reduce grading time per candidate, e.g. from the previous 3h to minutes for the aptitute test and from 8h to 1-2h for the architecture case study.
- A5: AI-assisted question updates (flagging questions, suggestion new ones) reduces manual effort for the experts that maintain the question and case study database.
- A6 (C8): Using old exams from the existing database either within an 1) extended context window, or via 2) RAG; we can ensure that the LLM has a proper understanding of the exam evaluation criteria.
- A7 (C1,C2): The grading process of Certifiable Inc. will not be able to keep up with the expected growth rates to process all incoming IT architect certification requests. Certifiable Inc has a slower hiring rate for experts than the market of IT architects (who now require a certification) is expected to grow.
- A8 (C8): Given C8, we have access to an existing database with solved tests and case studies from 120k certifications that can be used to enrich our LLM usage.
- A9 (C4): We assume that at the moment, there is also a certain overhead for formulating the emails providing feedback for an exam taker.
- A10: The case study contains architectural diagrams. We assume those diagrams in the case study are created via an established DSL language such as Structurizr. Since the language is well established in the industry, we assume that LLMs can process the language and hence the LLM can be used to support the evaluation in the case study.
- A11: Certifiable Inc. already has a system that can provide technical knowledge in the form of research articles, books and or blog entries. 
This knowledge base is used as a basis for grading aptitude exams and architecture exam submissions. 

## Requirements (R)
- R1 (C4, A1, A4): Scalability: by automating the grading process for the expected 5-10x volume growth while keeping the turnaround time at 1 week per test.
- R2 (C11, A1): High accuracy and consistency: this is given when the AI grading matches human accuracy for grading short answers and architecture submissions. To stay consistent, the database with 120k solved exams can be used to enrich the grading process.
- R3 (C7): Cost efficient: keep or increase the current market share by reducing the cost-per candidate cost (currently $50/hour and on average 11 hours), which makes it possible to also reduce the cost of the certification and hence attracts more candidates.
- R4 (C3, C12): Feedback quality: Generate detailed feedback for candidates
- R5 (C7, C9): Human-in-the-loop: Enable the experts to check AI based decisions and to enrich the available test database.
