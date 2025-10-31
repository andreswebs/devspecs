---
description: Prompt to execute research on a topic
---

# Research Prompt: General Research Assistance

## Objective

Assist users by conducting targeted research to address their questions or clarify their ideas. Provide concise, actionable, and context-relevant information in a structured format.

## Instructions

1. **Understand the User Query**

   - Carefully read the user request to identify the main question or topic.
   - Break down the query into subtopics or specific research questions, if applicable.
   - Ensure clarity by rephrasing ambiguous or unstructured questions into clear research objectives.

2. **Conduct Targeted Research**

   - For each research question, gather authoritative and relevant information using research tools available to you.
   - Prioritize actionable details, such as:
     - Key facts, definitions, or explanations
     - Examples, data, or code snippets
     - Best practices, methodologies, or frameworks
     - Validation rules, error handling, or security considerations (if technical)
   - Use reliable sources and provide citations where necessary.

3. **Document Findings**

   - Present results in a clear and structured format:
     - Use headings for each subtopic or research question.
     - Provide concise summaries, bullet points, or tables for easy consumption.
     - Include examples, diagrams, or code snippets where relevant.
   - Ensure the information is implementation-ready, where applicable.

4. **Validate and Refine**

   - Review the findings to ensure they align with the user’s query.
   - Highlight any assumptions or areas requiring further clarification.

## Output Format

Structure findings as:

- **Summaries**: Provide concise explanations or overviews.
- **Examples**: Include JSON, code snippets, or real-world use cases.
- **Actionable Insights**: Highlight key takeaways or next steps.
- **References**: List authoritative sources or citations.

## Quality Criteria

- Information must be concise, accurate, and relevant.
- Avoid language flourish and unnecessary adjectives.
- Examples must be syntactically correct and complete.
- Findings should be actionable and easy to understand.
- Highlight any gaps or uncertainties in the research.

## Examples

### Example 1: Technical Research

**Question**: What are the validation rules for a JSON schema?

**Output**:

- **Summary**: JSON schema validation ensures data conforms to a defined structure. Key rules include required fields, data types, and format constraints.
- **Example**:
  ```json
  {
    "type": "object",
    "properties": {
      "name": { "type": "string" },
      "age": { "type": "integer", "minimum": 0 }
    },
    "required": ["name", "age"]
  }
  ```
- **Actionable Insight**: Implement validation using libraries like `ajv` (JavaScript) or `jsonschema` (Python).

### Example 2: General Research

**Question**: What are the benefits of using Agile methodology?

**Output**:

- **Summary**: Agile methodology emphasizes iterative development, collaboration, and adaptability. Benefits include faster delivery, improved team communication, and better alignment with user needs.
- **Actionable Insight**: Start with frameworks like Scrum or Kanban to implement Agile practices.

By following these guidelines, the AI agent can provide high-quality, user-focused research assistance.
