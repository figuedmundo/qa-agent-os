# Raw Idea: Bug Folder Structure Reorganization

## User's Description

The user wants to reorganize the bug reporting structure in QA Agent OS. Currently, bugs are created per ticket, but the user believes bugs should be organized at the feature level instead, with the following structure:

```
/qa-agent-os/features/[feature-name]/bugs/
├── [bug-id]-[short-title]/
│   ├── bug-report.md
│   ├── screenshots/
│   │   ├── screenshot1.png
│   │   └── screenshot2.png
│   └── logs/
│       ├── log1.txt
│       └── log2.txt
```

## Key Requirements

1. Bugs organized at feature level (not ticket level)
2. Each bug gets its own folder with unique ID and short title
3. Folder structure allows for organizing supporting materials:
   - bug-report.md for the bug report
   - screenshots/ folder for images
   - logs/ folder for error logs and diagnostic info
4. bug-report.md should include a field to track which tickets the bug is related to
5. User is asking for design guidance: should the bug folder have subfolders (screenshots/, logs/) or keep everything flat inside the bug folder?

## Context

This spec addresses a structural change to how bugs are organized in the QA Agent OS feature workflow. The current implementation organizes bugs at the ticket level, but the proposed change would reorganize them at the feature level to better reflect that bugs often relate to multiple tickets or the feature as a whole.

## Open Questions

1. Should the bug folder structure use subfolders (screenshots/, logs/) or keep all files flat within the bug folder?
2. How should bug IDs be generated or assigned?
3. Should there be a migration path for existing bugs organized at the ticket level?
4. How should the bug reporting commands be updated to support this new structure?
5. Should there be an index or tracking mechanism at the feature level to list all bugs?
