# Phase 2: Gather Feature Documentation

## Collect Documentation from Stakeholders

Now let's gather all available documentation for this feature. I'll ask about different types of documents, and you can either:
- Provide a file path
- Paste content directly
- Skip if you don't have that document type

**Documentation to gather:**

### 1. Business Requirements Document (BRD)

"Do you have a Business Requirements Document or similar BRD?"

Options:
- [File path] - Paste the path to your BRD file
- [Paste content] - Paste the BRD content directly
- [Skip] - You don't have a BRD

### 2. API Specifications

"Do you have API specifications or technical contracts?"

Options:
- [File path] - Paste the path to API spec files (YAML, JSON, etc.)
- [Paste content] - Paste API specification details
- [Skip] - You don't have API specs

### 3. Business Rules & Calculations

"Do you have documentation on business rules, calculations, or formulas?"

Options:
- [File path] - Paste the path to business rules documentation
- [Paste content] - Paste the business rules content
- [Skip] - You don't have this documentation

### 4. UI Mockups & Wireframes

"Do you have UI mockups, wireframes, or design files?"

Options:
- [File paths] - List file paths to mockup images
- [Skip] - You don't have mockups

### 5. Other Technical Documentation

"Do you have any other relevant technical documentation?"

Options:
- [File path] - Paste the path
- [Paste content] - Paste the content
- [Skip] - No other documentation

**What happens next:**

Each document you provide will be:
1. Stored in `features/[feature-name]/documentation/` with a descriptive filename
2. Listed in `documentation/COLLECTION_LOG.md` with metadata (what it is, when collected, source)

**Note:** If you don't have all documents now, that's okay! You can add more later. The collection process ensures an audit trail of what was gathered and when.

Once you've provided or skipped all document types, we'll proceed to Phase 3 to consolidate this information into a master feature-knowledge.md document.
