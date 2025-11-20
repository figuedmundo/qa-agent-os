# Phase 2: Gather Ticket Documentation

## Collect Ticket-Specific Documentation

Now let's gather all documentation specific to this ticket. I'll ask about different document types.

For each prompt, you can:
- **[File path]** - Provide the path to the file
- **[Paste content]** - Paste the content directly
- **[Skip]** - You don't have this document type

### 1. Jira Ticket Export

"Do you have the Jira ticket export or PDF copy?"

Options:
- [File path] - Paste the path to the Jira export
- [Paste content] - Paste ticket details (ID, title, description)
- [Skip] - You'll enter details manually

### 2. Requirements & Acceptance Criteria

"Do you have ticket-specific requirements or acceptance criteria?"

Options:
- [File path] - Path to requirements document
- [Paste content] - Paste acceptance criteria directly
- [Skip] - Enter criteria during analysis

### 3. Technical Specifications

"Do you have technical specifications for this ticket?"

Options:
- [File path] - Technical spec document
- [Paste content] - Paste specifications
- [Skip] - None available

### 4. Mockups & Screenshots

"Do you have UI mockups or screenshots for this ticket?"

Options:
- [File paths] - List paths to mockup files
- [Skip] - No visual assets

### 5. API Examples

"Do you have API request/response examples?"

Options:
- [File path] - Path to API documentation
- [Paste content] - Paste API examples (JSON, YAML, etc.)
- [Skip] - No API examples

### 6. Other Documentation

"Do you have any other ticket-specific documentation?"

Options:
- [File path] - Other documentation
- [Paste content] - Paste other content
- [Skip] - Nothing else

**What happens with your documents:**

1. Each document is stored in `features/[feature-name]/[ticket-id]/documentation/`
2. `COLLECTION_LOG.md` is created listing all documents with metadata
3. This creates an audit trail of what was gathered and when

**Next Phase:**

In Phase 3, I will:
1. Read all ticket documentation
2. Read the parent feature-knowledge.md and feature-test-strategy.md
3. **Detect gaps** - Identify new requirements not in feature-knowledge.md
4. Prompt you to update feature knowledge if gaps are found
5. Create a comprehensive test-plan.md with detailed requirements analysis

Proceed with gathering documentation...
