# QA Standard – Evidence Template

Use this template whenever attaching proof for requirement reviews, test execution, or defect verification. Evidence must live in the repository or an approved artifact store with stable links.

## Metadata Header
- **Artifact Type**: Test Execution / Bug Verification / Requirement Review
- **Related IDs**: Requirement, Test Case(s), Bug ID, Build or Commit hash
- **Environment**: OS, Browser/Device, API host, feature flags
- **Owner & Timestamp**: Tester name, UTC datetime

## Required Sections
1. **Summary of Validation**
   - Objective and outcome in 1–2 sentences.
2. **Test Data / Configuration**
   - Accounts, payloads, seed scripts; include sanitised values only.
3. **Steps Executed**
   - Numbered list referencing scripts/commands when applicable.
4. **Observed Results**
   - Actual UI/API output, console logs, monitoring IDs.
   - Wrap multiline logs in fenced code blocks.
5. **Evidence Links**
   - Screenshot/video file paths, log bundle URLs, trace IDs.
6. **Pass/Fail Conclusion**
   - Explicit status plus follow-up actions or open questions.

## Handling Rules
- Redact or mask PII, secrets, and internal URLs not for distribution.
- Store binary assets under `/artifacts/YYYY-MM-DD/<name>` with checksum if size >5 MB.
- Reference this document from bug reports and test summaries to avoid copy-paste divergence.
