# Raw Idea: Eliminate Template Duplication

**Spec Name:** eliminate-template-duplication

**Date:** 2025-12-01

## Description

Redesign QA Agent OS to eliminate duplication between templates and standards, reduce token usage, and simplify the architecture by making standards the single source of truth. Templates should become minimal structure references that rely on standards for content. Unused workflows and files should be identified and removed.

## Key Problems

1. Templates duplicate information from standards (e.g., bug-report-template.md duplicates content from standards/bugs/)
2. Workflows like bug-reporting.md exist but aren't being used
3. No way to detect unused files (no compiler for markdown)
4. Adding new requirements requires updating both templates AND standards (double maintenance)
5. High token/context usage due to duplication

## Goal

Make standards the single source of truth, minimize templates to structure-only, eliminate unused files, and optimize for token efficiency.

## Initial Scope

- Audit current template vs. standards duplication
- Identify unused workflow files
- Design new architecture where standards are the single source of truth
- Create detection mechanism for unused files
- Reduce token usage while maintaining functionality
- Simplify maintenance by eliminating double-updates
