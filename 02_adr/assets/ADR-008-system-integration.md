# Integrate AI into existing architecture

## Date:
2025-02-15

## Status:
Draft

## Context:
We need to integrate AI into an existing system. 
AI components need to be triggered from the existing system. 
Output from AI needs to be integrated into the existing process. 

## Decision:
AI is never directly prompted from existing components. 
Each use of AI receives a gateway component. 
The gateway is a piece of indifidually developed software. 
The gateway reads data from existing databases where needed. 
The gateway triggers AI interaction where needed. 
The gateway processes AI output and makes it available to the existing system. 
Reuse of databases. 
Scheduling Jobs. 

### Why did we take this decision?

## Consequences:
What are the consequences?