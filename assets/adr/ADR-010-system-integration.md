# Integrate AI into existing architecture

## Date:
2025-02-15

## Status:
Proposed

## Decision Details
We will integrate AI capabilities through dedicated gateway components that interface with existing databases, rather than directly embedding AI into current system components.

## Context:
We need to integrate AI into an existing system. 
AI components need to be triggered from the existing system. 
Output from AI needs to be integrated into the existing process. 

## Decision:

We decide upon the following principles for integrating AI usages in the system:

1. AI is never directly prompted from existing components.
2. Each AI usage receives a gateway component orchestrating interactions with the system.
3. Output data from AI usages are written into existing data bases. 
4. Input data for AI usages is read from existing databases.   
5. Input data that doesn't change often may be pre processed and stored in dedicated data sources.  
6. Tasks executed by the AI systems are triggered by the AI gateway in configurable intervals.
7. Each AI system receives a UI for managing and scheduling tasks. 

### Why did we take this decision?

With these principals we prioritize **modularity, scalability, and maintainability**  

We to minimize changes to the existing system wherever possible. 
Creating a gateway component allows us to abstract the integration of AI into the system. 
Reading from and writing to existing data bases makes the integration more seemless. 
This allows the AI systems to perform their tasks, without the sourrouning system needing to change.

While some system changes are inevitable due to process adjustments, limiting AI output to existing components ensures that modifications remain localized to the areas that inherently need updates.  

## Consequences:  

* **Minimal Changes to Existing System**  
  * The AI gateway abstracts interactions, reducing modifications to core components.  

* **Scalable & Maintainable AI Integration**  
  * New AI features can be added without disrupting the existing architecture.  

* **Increased Operational Overhead**  
  * The AI gateway and UI management introduce additional maintenance efforts.  

* **Potential Latency in AI Processing**  
  * Since AI tasks are scheduled rather than real-time, results may have delays.  

