# Interview on Retrieval-Augmented Generation (RAG) and AI Scalability

## Purpose

The goal of this interview is to gather insights and practical knowledge from a colleague who has worked extensively with Retrieval-Augmented Generation (RAG) and AI-based systems. This information will help guide our software architecture decisions.

## Interview Structure

The interview will include a mix of high-level and technical questions. Topics range from AI provider selection (AWS, Google, Azure, OpenAI, etc.) to more detailed questions about performance tuning, data integration, security, and lessons learned from real-world projects.

Below are the questions we plan to ask:

---

<!-- ### 1. **Platform & Provider Selection**
> Which AI platform providers (e.g., AWS, Google, Azure, or others) have you used for RAG-based solutions, and why did you choose them? -->

<!-- ### 2. **Core Components of RAG**
> Could you walk me through the main components of a RAG architecture and how they fit together (retriever, reader, knowledge source, etc.)? -->

### 3. **Data Source Integration**
> What types of data sources have you integrated into your RAG pipeline (databases, APIs, documents, etc.), and how challenging was it to bring them all together?

I had several projects where we integrated a bunch of different data sources. The most common data sources were 
- internal data (from wikis, intranet, filesystems,...) which had to be crawled
- data available from other systems via APIs
- internal databases

Datatypes:
- Documents (PDFs, Docx, Markdown, Images)
- HTML Websites
- JSON Data Objects

The challenge is that each data source type needs a separate pipeline to fetch and preprocess the data respectively. Intranets (wiki, websites) usually do not send update notifications, so you need a pull mechanism to periodically fetch the content and check for updates (e.g. compare a hash, timestamp, ...) and data preprocessing can be a challenge (you want the relevant content in a form optimized for you RAG use case and reduce data noise).

Depending on your database for the RAG it is more or less a challenge. A simple Vectorstore DB is easier to manage. You check if a new or updated document is present, update the data chunks which come withit and its metadata (like RBAC, Document information,...). More complex is it if you habe a graph database for example. There you need to write more complex queries to insert or update the database. Deletion (or absence of data) can be a challenge too and it is important that you think of it at the beginning and implement respective approaches.

<!-- ### 4. **Scaling Approaches**
> When going from a few hundred users to thousands, what are the most significant technical considerations for scaling a RAG system? -->

<!-- ### 5. **Performance Tuning**
> Have you encountered latency or throughput issues in your RAG solutions, and what strategies did you use to improve performance? -->

### 6. **Security & Access Control**
> How do you handle sensitive or proprietary information when using RAG? What security measures have you found most effective?

It is important to understand the content of your data and which user has access to it. A common technique is to use RBAC on the data points in you RAG application. E.g. each chunk of the document in a vector database inherits the RBAC from the document. The users of your system should then be authenticated and authorized via the same identity provider which also manages the RBAC for the source data. It is therefore best if you can mirror the RBAC from the data source. Challenges are that you might have a system with data duplication and if not protected wright creates securiy leaks. Also you might have multiple data sources and they are not well integrated with the company RBAC.

<!-- ### 7. **Trade-offs in Model Selection**
> What are your thoughts on using large pre-trained models vs. smaller, more specialized models for RAG? When do you decide one is more appropriate than the other? -->

### 8. **Human-in-the-Loop**
> What’s your approach to balancing AI-driven automation with human oversight, especially in processes that used to require manual intervention (like exam corrections)?

It is important to have a human-in-the-loop if your process requires so. That could be a sensitive tool call or a human check if the model is not sure enough. The latter is not so easy with generative models, they overestimate themself. In a classical machine learning classification for example, it was easy to model the output as a probability distribution and hence the model prediction came with a sort of confidence score which could be compared to a threshold. With large language models it is a bit more difficult. Some offer Logprobs (Log probabilities represent the logarithm of the probability of each token in the output sequence), which can be used as a filter to evaluate retrieval accuracy in the rag pattern and give a measure for how likely an overall response is. Alternativ or in addition, one can write validators to evaluate a llm response. The trick is to use another llm call to validate the generation of the first llm call. This works as it is easier to validate if an answer to a given question is correct, than to generate the answer and validate it at the same time. In RAG systems one can implement a validator to check relevancy for the retrieved sources for example.

<!-- ### 9. **Tooling & Frameworks**
> Which libraries or frameworks (e.g., Hugging Face, Haystack, LangChain) have been most helpful for building RAG pipelines? -->

### 10. **Quality Metrics & Measurement**
> How do you measure success for your RAG solution? Are there specific metrics or KPIs you focus on (accuracy, F1, user satisfaction, etc.)?

First of all, it is important to build your system around your actual use case and if possible to limit the solution space as much as possible. This helps in the overall system, the components in the rag solution and mostly in the prompt engineering part. To measure success, one should define business relevant KPIs. E.g. if you build a support agent you can measure how much a certain self help is worth or how many minutes you can save per user if he creates an optimized incident ticket with your ai agent (which might aggregates your ticket with internal knowhow via rag).

Specifically for a RAG application there are severall metrics which come in handy. Like the [RAG Triad](https://www.trulens.org/getting_started/core_concepts/rag_triad/), which uses 3 metrics:
1) Context Relevance (is the retrieved context relevant to the user query)
2) Groundedness (is the response supported by the context)
3) Answer Relevance (is the answer relevant to the query)

Depending on the use case you might want to optimize recall, precision or the overall (F1). It is important to create a testset early in the development and it should represent your solution scope respectively. This is important for prompt engineering, so you optimize the overall solution and not fix one known bug and introduce 10 hidden ones.

It is important to understand your system and evaluate the overall performance as well as the individual components. E.g if the data is not present, you cannot answer the user question. If the data is present, but you cannot find it given a certain user question, you cannot answer the question either. If you can fetch the relevant context but the model with your prompt ignores it, again you cannot answer the question. 

### 11. **Content Filtering & Moderation**
> What strategies do you use to ensure the AI doesn’t generate incorrect, inappropriate, or biased outputs?

Check out answer from Human-in-the-loop (Logprobs, Validators, Context Relevancy Checks). In addtion one can use guardrails (input as well as output guardrails). Some cloud hyperscaler already provide some default guardrails.

### 12. **Cost Management**
> Speaking of cost, how do you predict and manage the cost of inference and data storage, especially if user traffic grows significantly?

One needs to calculate predictive costs in advance. Usually the fix costs for infrastructure like data storage sizes/plans remain relatively low and stable. The runtime costs scale per query or per user and therefore increase significantly if the user traffic grows. But if you calculate the business value of one user request and compare the cost against the benefits of it, the amount should not matter much... most likely your business case gets stronger.

<!-- ### 13. **Retrieval Engine Selection**
> What influenced your choice of retrieval engine (e.g., Elasticsearch, Pinecone, or vector databases like Milvus)? Any particular pros and cons? -->

### 14. **Data Preprocessing & Curation**
> How important is data preprocessing and curation in improving RAG outputs, and what best practices would you recommend?

Data preprocessing and curation is crucial to the success of your solution. As with all ai applications, good data quality is the key to success. The challenge is that it is not always easy in a RAG application, especially if your data comes from various unguided sources. The more noise there is in your data, the worse your solution becomes.

There are many challenges in the preprocessing task (check out my blog post from 1-2 year ago) [RAG Challenges](https://ipt.ch/de/impuls/der-weg-durchs-llm-labyrinth-herausforderungen-des-retrieval-augmented-generatio)

- Try to not ingest noisy data (carefully select your data sources)
- Keep important metadata and use it in the vector database for retrieval (like the timestamp when a document was created/updated or what category the document belongs)
- If necessary, anonymize relevant parts (e.g. personal information)
- Think of how to chunk the documents, how to create new data like generated summaries for documents
- If latency at runtime can be an issue, you might want to produce certain processing steps you would do at runtime already at ingestion time (for all data, which can cost more and takes storage space but might saves you time at runtime)

### 15. **Versioning & Updating Knowledge Sources**
> How do you handle updates to your knowledge base over time to ensure the RAG model stays current?

Depending on the data source you need a mechanism to know if you have this data in your database in that version or not. Common mechanism are to use timestamps if the data source already provides them. During data ingestion you can check if the id is present in you database (e.g. vectore store) and if the timestamp matches. Another way is to generate a hash of the relevant document content and store it as metadata. That way you can compare if something changed.

Generally it is important to update the data depending on your data source and the use case. If you need to update the data almost realtime, you need to implement more complex approaches. If the data source can provide you with update events, even better so you do not need a pull mechanism. Most of the time it is a combination though. A queue system can come in handy as well.

Challenges are usually deletion of data at a data source where the source does not inform you of it. Here you need to compare your database index against the the source and perform the deletion respectively.

<!-- ### 16. **Iterative Experimentation**
> What kind of experimentation process do you follow when iterating on the RAG pipeline (A/B testing, user feedback loops, etc.)? -->

### 17. **Lessons & Pitfalls**
> What are the biggest pitfalls you’ve encountered while deploying RAG at scale, and how would you advise others to avoid them?

A too big solution scope, i.e. you want a chatbot which can answer ALL question related to ALL internal data. Therefore the solution needs to be generic and cannot be optimized to maybe more relevant use cases regarding a business case. Try to reduce the solution space, start with one or two specific cases you can optimize and widen the solution space with technics like agents or multi agent systems.

The testset for the rag evaluation was not created at the beginning of the project because there were no specialists (employee with domain knowhow) available at the client. This makes it very hard to optimize the rag components and the overall solution. Always create one or multiple test set at the beginning of your project. So you can evaluate your solution as well as the individual components of your system against a gold standard.

A challenge is usually that the question or intent of the user is not directly linked with the semantic meaning of the relevant context. But a traditional vector search only compares the semantic representation of the search query to the embedded document chunks. Solutions could be to generate a search query which is used for the vectore search instead of using the user question directly. Or if more complex, having an agent which can generate multiple subqueries from a given user query to fetch the relevant context and combines the results to answer the question. Alternatively, one can generate at ingestion potential queries to a given document or document chunk and embedd those queries with the document.

**Author**: [*Philipp Rimle*]  
**Date**: *2025-02-18*
