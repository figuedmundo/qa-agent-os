# Raw Idea: Original Agent-OS Architecture Analysis

## User Description

We need to understand the original agent-os architecture design that we may have missed during the QA workflow redesign. Specifically:

1. Commands have both single-agent/ and multi-agent/ folders - why?
2. Commands reference workflows like {{workflows/testing/testcase-generation}} - what's the relationship?
3. There are workflows in profiles/default/workflows/ that seem outdated or unused after refactor
4. There are agents in profiles/default/agents/ that aren't analyzed during the refactor

The recent refactor (specs/2025-11-20-qa-workflow-redesign/) may have missed important architectural patterns. We need to analyze the original design intent and ensure everything makes sense together.

## Context

This spec was initiated on 2025-11-21 to investigate potential architectural patterns from the original agent-os design that may not have been properly integrated during the recent QA workflow redesign.

The QA workflow redesign focused on creating 5 orchestrated commands for the QA workflow, but there are questions about whether the original single-agent/multi-agent architecture, workflow system, and agent roles were properly considered or if they represent unused/outdated patterns that should be cleaned up.

## Scope

This analysis should cover:
- The purpose and design of single-agent/ vs multi-agent/ folder structure in commands
- The workflow system and how {{workflows/...}} references are meant to work
- The status of existing workflows in profiles/default/workflows/
- The role and integration of agents in profiles/default/agents/
- How these patterns should integrate with the current QA workflow commands
- Whether any patterns are obsolete and should be removed or updated
