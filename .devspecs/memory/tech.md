---
applyTo: "**/*"
---

# Technology Brief

## Core Runtime Requirements

### Shell Environment

- **Bash**: Version 5 or higher required
- **Installation on macOS**: Must be installed via Homebrew (`brew install bash`) or Nix
- **Platform Support**: Linux and macOS only (Windows explicitly not supported)

### System Dependencies

- **Git**: Required for version control and feature branch workflow
- **GitHub CLI (gh)**: Required for GitHub integration and issue management
- **BATS**: Bash Automated Testing System (included as Git submodule, no separate installation needed)

## Architecture and Installation

### Installation Model

- **Distribution**: Downloaded via Git to user-specified location
- **Symlink Strategy**: Installation script symlinks framework files into project's `.github` directory

### Directory Structure

```
.devspecs/
├── scripts/          # Core framework scripts
├── prompts/          # Workflow prompts (symlinked to .github/prompts/)
├── memory/           # Steering documents
└── specs/            # Specification documents
```

## Framework Architecture

### Core Components

- **Core Functions**: `scripts/functions.sh` contains primary framework logic
- **Utility Scripts**: Additional helper scripts in `scripts/` directory
- **Testing Infrastructure**: BATS test files in `scripts/test/` directory
- **Prompt Library**: Structured prompts for each workflow phase

### Branch Management

- **Naming Convention**: `<xxx>-<feature-name>` (3-digit prefix with feature name)
- **Workflow**: Feature-based development with numbered branches
- **Integration**: Git-based feature branch management

## Document Architecture

### Steering Documents (`/memory`)

Persistent knowledge files included in every AI interaction:

- `product.md`: Product overview, purpose, target users, key features, business objectives
- `tech.md`: Technology stack, frameworks, libraries, development tools, technical constraints
- `structure.md`: Project structure, file organization, naming conventions, architectural decisions (optional)

### Specification Documents (`/specs/<xxx>-<name>`)

Per-feature specification files:

- `requirements.md` (alias: PRD): Product requirements in EARS notation
- `design.md`: Technical architecture, sequence diagrams, implementation considerations, architectural decisions, technical approach, dependency mapping
- `plan.md`: Detailed implementation plan with discrete, trackable tasks

## GitHub Integration

### Workflow Phases

```mermaid
graph LR
    A[PRD Creation] --> B[Epic Planning]
    B --> C[Task Decomposition]
    C --> D[GitHub Sync]
    D --> E[Parallel Execution]
```

### Integration Points

- **GitHub CLI**: Issue creation and management
- **Repository Integration**: Feature branch workflow
- **Prompt Distribution**: Phase-specific prompts symlinked to `.github/prompts/`

## AI Assistant Integration

### GitHub Copilot Optimization

- **Target Platform**: Designed specifically for GitHub Copilot workflows
- **Non-goals**: Does not support other AI assistants
- **Document Structure**: Optimized for AI context understanding
- **Prompt Engineering**: Curated prompt library for consistent specification creation

### Workflow Triggers

- Each development phase triggered by specific prompts from `/prompts` directory
- Prompts distributed via symlinks to `.github/prompts/` during installation
- Structured approach to transform high-level ideas into detailed implementation plans

## Testing Framework

### Test-Driven Development

- **Methodology**: TDD mandatory per project constitution
- **Framework**: BATS (Bash Automated Testing System)
- **Test Organization**: Test files located in `scripts/test/` with `.test.bats` extension
- **Coverage**: All Bash scripts must be tested
- **Dependencies**: BATS included as Git submodule (no separate installation)

### Test Structure

- **Test Files**: `devspecs/scripts/test/*.test.bats`
- **BATS Framework**: `devspecs/scripts/test/bats/`
- **Test Helpers**: `devspecs/scripts/test/bats-helpers/` (includes bats-assert and bats-support)

## Development Standards

### Code Quality

- **Testing**: TDD methodology with comprehensive BATS test coverage
- **Documentation**: Clear documentation standards for all framework components
- **Shell Standards**: Follow established Bash scripting best practices
- **Linting**: Shell scripts validated with shellcheck
- **Formatting**: Shell scripts formatted with shfmt

### Framework Constraints

- **Performance**: No specific scalability constraints documented
- **Security**: No special security considerations beyond standard Git/GitHub practices
- **Maintenance**: Reference existing coding guidelines for development practices
