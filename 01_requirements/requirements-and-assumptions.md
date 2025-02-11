# Assumptions and Requirements
Since we are working on an established architecture, we derive context that is relevant for our new architecture contributions. Using these context statements, we formulate our assumptions and requirements. We use the short-hand notations C, A and R for contexts, assumptions and requirements. C1(A1,A2) indicates that context statement C1 depends on or is based on the assumptions A1 and A2.

## Context
- C1: The Software Architect profession becomes a licensed profession, implying that the number of IT experts seeking a software architect license will grow drastically
- C2: Certifiable Inc currently assesses 200 certification candidates (in the following always referred to as _candidate_) per week. This number is expected to **increase by 21% per year** over the next four years. General expansion is expected to grow 5-10x in total.
- C3: The certification process consists of two sub-processes, consisting of an **aptitutde test** and an **architecture case study**. Both are graded and for both tests, the candidate gets detailed feedback.
- C4: The grading process and the feedback provisioning takes, on average, 3h for the aptitute test and 8h for the case study. The grading is done by an externally hired IT expert (in the following referred to as _expert_).
- C5: The whole grading is done by a human, except for a multiple choice part within the aptitude test.
- C6: There is a **1 week turnaround time** for the grader for each, aptitude and case study tests. While the aptitude test is time boxed to avoid cheating, the architecture test has to be solved within 2 weeks.
- C7: Taking the exam costs a participant 800$, experts are paid 50$ per hour. Currently there are 300 experts hired for the grading.
- C8: 120 000 IT architects have already been certified by Certifiable Inc..
- C9: The experts are also responsible for analysing reports, with the purpose of modifying certification tests if a modification is required. Modifcations are required e.g. when a test question turns out to be poorly choosen, due to new technology trends, etc..
- C10: _Administrators_ maintain the certified architects database.

## Assumptions
### LLM processing related
- A1: LLMs can be used to automate evaluation tasks on the human level. This has been shown and is called [LLM-as-a-Judge](https://arxiv.org/abs/2306.05685): The models there reach 80% agreement, the same level of agreement between humans.
- A2 (A1): Reasoning Models, which only occurred in the end of 2024, are even more capable than previous "LLM as a judge" approaches, and hence can definitely be used for rating exams by letting the model explain the reasoning steps behind a certain grading.
- A9 (C8): Using old exams from the existing database either within an 1) extended context window, or via 2) RAG; we can ensure that the LLM has a proper understanding
- A10: Accuracy limitations AI or LLMs as a judge exist and is established, if 
- AX: While LLMs are known to be able to hallucinate, we assume that the usage of Reasoning Models.

### Future of Certifiable Inc.
- A1 (C1,C2): The grading process of Certifiable Inc. will not be able to keep up with the expected growth rates to process all incoming IT architect certification requests.
- A2: Certifiable Inc has a slower hiring rate for experts than the market of IT architects (who now require a certification) is expected to grow.
- A4 (C8): Given C8, we have access to an existing database with solved tests and case studies from 120k certifications that can be used to enrich our LLM useage.
- A5(C4): We assume that at the moment, there is also a certain overhead for formulating the emails providing feedback for an exam taker.
- A6: The case study contains architectural diagrams. We assume those diagrams in the case study are created via an established DSL language such as Structurizr. Since the language is well established in the industry, we assume that LLMs can process the language and hence the LLM can be used to support the evaluation in the case study.
- A7: Certificable is known for its detailed feedback provisioned after the exam, and hence is a popular choice amonst IT professionals to get certified.


## Functional and non-functional requirements
- R1 (A1,A2): In the future, an expert needs to be able to grade more candidates in the same amount of time.
- R2 (A7): The grading quality and accuracy has to stay consistent, as Certifiable Inc. wants to keep its position as trusted industry leader
- R3 (C6): Keep the 1 week turnaround time for each test.

