# DisasterOps AI – Git Workflow

## Main Branch

main

Contains stable project code.

## Development Branch

develop

Used for integration and development.

## Feature Branches

Backend:
feature/backend

Frontend:
feature/frontend

## Workflow

1. Pull the latest develop branch.
2. Create or switch to the appropriate feature branch.
3. Implement the feature.
4. Test the feature.
5. Commit the changes.
6. Push the feature branch.
7. Create a Pull Request.
8. Review the changes.
9. Merge into develop.
10. Merge stable code into main when the milestone is complete.

## Rules

- Do not directly push unfinished work to main.
- Do not commit passwords or API keys.
- Do not commit .env files.
- Pull the latest develop branch before starting new work.