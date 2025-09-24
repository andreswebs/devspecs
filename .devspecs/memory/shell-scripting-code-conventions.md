---
applyTo: "**/*"
---

# Shell scripting code conventions

## General Guidelines

- Name Bash scripts with the `.bash` extension.

- DO NOT ADD USELESS COMMENTS to generated code.

- Always use the shebang `#!/usr/bin/env bash` for Bash scripts.

- Be explicit when using command line arguments, always use the long form of command flags when available.

- Use strict mode when the script is intended to be run directly:

  ```bash
  set -o errexit
  set -o nounset
  set -o pipefail
  ```

- Always use double brackets and quotes for variable references:

  ```sh
  "${EXAMPLE}" ## good
  ```

  ```sh
  $EXAMPLE ## NOT good
  ${EXAMPLE} ## NOT good
  "$EXAMPLE" ## NOT good
  ```

- Use 4 spaces indentation

- Run `shellcheck` and `shfmt -i 4`:

```bash
# Verify shell scripts with shellcheck
shellcheck devspecs/scripts/*.bash

# Format shell scripts
shfmt -i 4 -w devspecs/scripts/*.bash

# Run full test suite before deployment
./devspecs/scripts/test/test.bash
```

- Follow `.editorconfig` for code formatting

### Function Guidelines

- Functions should have error checking where relevant
- Use `log` function from `functions.bash` for error messages; error messages must go to stderr
- Standard output (stdout) reserved for function return values
- Return appropriate exit codes (0 for success, 1 for failure)
- Validate inputs using existing validation functions where relevant

### BATS Guidelines

- When manipulating the filesystem during tests, make sure to use the temporary directories and global variables provided by Bats.
- Important variables and temp directories:
  - `BATS_FILE_TMPDIR`: A temporary directory common to all tests of a test file. Can be used to create files required by multiple tests in the same test file.
  - `BATS_SUITE_TMPDIR`: A temporary directory common to all tests of a suite. Can be used to create files required by multiple tests.
  - `BATS_TEST_TMPDIR`: A temporary directory unique for each test. Can be used to create files required only for specific tests.
