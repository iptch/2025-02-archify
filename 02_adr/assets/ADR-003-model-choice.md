# Using a LLM model via API vs self-hosting

## Date:
2025-02-15

## Status:

## Context:
Given the large set of available LLM models, we need to determine which LLM to use based on our requirements.
This decision impacts development velocity, operational costs and system (grading) performance.

The most crucial criteria for this are integration complexity, performance requirements, cost structure, context length capabilities and future migration paths (e.g. when switching the LLM provider). We need to evaluate local deployment options such as DeepSeek-R1/V1, Llama-3 or Mistral, or API services like OpenAI's GPT series, Anthropics Claude or Googles Gemini.

## Decision:
Decision is based on the following criteria
To quantify the criteria better, we make use of the [Huggingface Leaderboard](https://lmarena.ai/), which ranks LLM capabilities by doing pairwise comparisons.
What is a decision?

### Why did we take this decision?

## Consequences:
What are the consequences?
