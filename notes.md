Final README structure
- Introduction for problem, our best use-cases and ADRs, introduction to the ARCHIFY system component
- Our thinking behind solving the scalability problem (i.e. we didnt interfere with the existing system, added a new LLM component that reduced required human intervention)
- Explain system diagram components (?)
- How and when do we require human-in-the-loop
- From where data is read and written (during processing the exams)
- How we enrich the LLM prompt using RAG, prompt engieering
- Ensuring quality/consistency of the grading
- How we provide context for the architecture exam
- Architecture characteristics: Scalability, maintainability, accuracy etc. (what is important and why)
- When and where do IT experts interact with the system? How much interaction is required and why?

Required TODOs
- Finish system diagram components
- Restructure folder
- Knowledge Base (add this as assumption) -> ADR not sufficient yet
- Fix linking/references in the README
- Quickly ensure no more TODOs

Optional TODOs
- Reference Huyen book for guard rails
- Architecture exam: LLM should be able to interpret architecture diagram somehow (its already in the assumptions)
- Describe detailed how new tests are created, possibly as ADR
