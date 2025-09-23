# AGENTS.md

## Project Overview

This `devspecs`, an AI Spec-Driven Development framework for GitHub Copilot, written in Bash. The framework helps developers create and manage feature specifications using a structured workflow with numbered feature branches (e.g., `001-feature-name`). It's heavily inspired by Kiro and Spec Kit.

**Key Technologies:**

- Bash shell scripting
- Git-based workflow with feature branches
- BATS (Bash Automated Testing System) for testing
- Markdown for documentation and specifications

**Architecture:**

- Core functionality in `scripts/functions.bash`
- Feature branches follow naming convention: `001-feature-name`
- Specs are organized in a `specs/` directory structure
- Test-Driven Development (TDD) is mandatory per project constitution

## Development Workflow

### Run All Tests

```sh
# From project root
./devspecs/scripts/test/test.bash
```

### Run Specific Tests

```sh
# From test directory
pushd devspecs/scripts/test
./bats/bin/bats is_valid_spec_name.test.bats
./bats/bin/bats is_readable_file.test.bats
./bats/bin/bats is_non_empty_dir.test.bats
```

### Test File Locations

From `./devspecs`:

- Test files: `scripts/test/*.test.bats`
- BATS framework: `scripts/test/bats/`
- Test helpers: `scripts/test/bats-helpers/`

### Writing New Tests

Follow BATS format for new test files:

```txt
#!/usr/bin/env bats
# shellcheck shell=bats

load '../functions.bash'

@test "test description" {
    run function_name "argument"
    [ "${status}" -eq 0 ]
    [ "${output}" = "expected_output" ]
}
```

### TDD Workflow

1. Write failing test first
2. Get approval for test
3. Ensure test fails (Red)
4. Implement minimal code to pass (Green)
5. Refactor while keeping tests green (Refactor)

## Code Style Guidelines

### File Organization

Core framework is under `./devspecs`:

- Core functions: `scripts/functions.bash`
- Utility scripts: `scripts/*.bash`
- Tests: `scripts/test/*.test.bats`
- Agent instructions and directives: `memory/*.md`
- Prompts: `prompts/*.md`

### Naming Conventions

- Test files: `*.test.bats`
- Bash scripts: `*.bash`
- Prompts, agent instructions, directives: `*.md`

## Pull Request Guidelines

- **Title format**: Brief description of changes, in Conventional Commits format
- **Required checks**:
  - Follow TDD: Tests written and approved before implementation
  - All tests must pass: `./devspecs/scripts/test/test.bash`
  - Shell scripts must pass shellcheck: `shellcheck scripts/*.bash`
- **Branch naming**: Branches must follow `001-feature-name` pattern

## Additional Notes

### Framework Limitations

- **Non-goals**: Does not support Windows or AI assistants other than GitHub Copilot
- **Dependencies**: Requires Git, Bash, and BATS for testing
- **Target OS**: macOS and Linux only

### Spec-Driven Development Workflow

1. Create feature branch with proper naming
2. Write comprehensive specification in spec directory
3. Write tests first (TDD requirement)
4. Get approval for tests
5. Implement functionality
6. Ensure all tests pass
7. Create pull request

This framework is designed to work specifically with GitHub Copilot to provide a structured approach to feature development using specifications and test-driven development.
