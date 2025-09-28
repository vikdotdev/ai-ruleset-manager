# AI Ruleset Manager

A template repository for managing reusable rule fragments (plain `*.md` files) that can be composed into comprehensive LLM instruction documentation. Perfect for individuals who want to manage their LLM instructions with `git` and compose specific rulesets from personal rule databases.

## Problem
Often projects have their own `*.md` rule/context files that provide LLMs with context about the project (architecture/design/styling/etc). This leaves no place for user-defined instructions that don't belong in the project (user-specific workflows/preferences/etc).

_A way_ out of this problem is to have a git-ignored `*.local.md` file that contains such user preferences. Keeping such ignored files outside of version control can get messy, especially if user wishes to carry their LLM instructions across multiple machines.

## Solution
Split LLM rule/context file into individual `*.md` rule files and build specific context file for specific project/LLM tool. Here's an example of what a repository could look like with this template:
```
my-ai-ruleset/
├── scripts/
│   ├── ai-rules            # Main CLI tool, copied from the template
│   └── test                # Test runner, copied from the template
├── rules/
│   ├── ruby                # Database of specific user rules for Ruby
│   ├── rails               # Database of specific user rules for Rails
│   └── my_rails_project    # Database of specific user project rules
├── build/
│   └── my_rails_project.md # Stores compiled artifacts (in case of using symlinks)
└── test/                   # Comprehensive test suite
    ├── fixtures/           # Test data
    └── *.sh                # Test scripts, automatically invoked by scripts/test
```

## 🚀 Quick Start

1. **Use this template**: Click "Use this template" on GitHub to create your own repository
2. **Clone your repository**: Clone your repository to your local machine
2. **Install the CLI**:
   ```bash
   ./scripts/ai-rules install # Creates `ai-rules` CLI command at your PATH
   ```
   
   Or as custom binary command:
   ```bash
   ./scripts/ai-rules install --bin-name <binary command name of your choice>
   ```
3. **Create your first rule database**:
   ```bash
   ai-rules new --database rails
   ```
4. **Add rules** to `rules/<database-name>/rules/`, e.g. specific rules for Rails projects:
   ```bash
   echo "Classes should always be defined as one-liners, e.g. `MyModule::AnotherModule::MyClass`." > rules/ruby/rules/class-definitions.md
   echo "# Callbacks\nNever use callbacks on models." > rules/rails/rules/models.md
   echo "# Testing\nAlways start writing tests with a basic outline and let me review it." > rules/rails/rules/testing.md
   echo "# Testing controllers\nNever do ..." > rules/rails/rules/testing-controllers.md
   ```
5. **Create a manifest** in `rules/<database-name>/manifest`:
   ```
   | ruby/class-definitions
   | rails/models
   | rails/testing
   || rails/testing-controllers
   ```
   Every rule fragment creates properly indented entry in the resulting `*.local.md` file.
6. **Compile your ruleset**:
   ```bash
   ai-rules build --manifest rules/<database-name>/manifest --out ~/my_project/CLAUDE.local.md
   ```

## 🛠️ CLI Commands

### Install CLI
```bash
./scripts/ai-rules install [--prefix <path>]
```
Installs the CLI tool to your system.

### Create New Database
```bash
ai-rules new --database <name>
```
Creates a new rule database with proper directory structure.

**Example:**
```bash
ai-rules new --database react
```

### Validate Manifest
```bash
ai-rules validate --manifest <path>
```
Validates manifest syntax and checks that all referenced rules exist. Validation is also run before `ai-rules build`.

**Example:**
```bash
ai-rules validate --manifest rules/myproject/manifest
```

### Compile ruleset
```bash
ai-rules build --manifest <path> [--out <file>]
```
Compiles rules from a manifest into a single markdown file at destination, or in `build/` directory.

**Examples:**
```bash
# Build with default output location
ai-rules build --manifest rules/myproject/manifest

# Build with custom output
ai-rules build --manifest rules/myproject/manifest --out path/to/myproject/ai-context.md
```

### Deploy Documentation
```bash
ai-rules build-link --manifest <path> --out <symlink path>
```
Builds documentation and creates a symlink for easy access.

## 🪢 Dependencies

**Runtime dependencies**:
- POSIX-compliant shell (`/bin/sh`)
- `cat`
- `sed`
- `cut`
- `wc`
- `basename`
- `dirname`
- `pwd`
- `cd`
- `mkdir`
- `ln`
- `mv`
- `rm`
- `read`

**Development dependencies**:
- `diff`
- `grep`

## 📋 Manifest Format

Manifests use simple text-based hierarchical format:

```
# Comments start with #
| top-level-rule
|| nested-rule
||| deeply-nested-rule
| another-top-level-rule
```

**Nesting Rules:**
- `|` = Level 1 (becomes `# Rule: name`)
- `||` = Level 2 (becomes `## Rule: name`)
- `|||` = Level 3 (becomes `### Rule: name`)
- Up to 6 levels supported
- Each level must increase by exactly 1 (no skipping levels)

### Rationale

**Why not YAML/JSON/TOML?:**
- There's no easy way to parse any of those formats (that I know of) without external dependencies that are not written in POSIX shell script

**Why `|`?:**
- Because if you squint, it makes the hierarchy look like a tree
- For easy parsing

## 📝 Writing Rules

- Rules are standard Markdown files stored in `rules/<database>/rules/*.md`
- Use any heading levels you want - they'll be automatically normalized based on hierarchy
- Each rule file becomes a titled section in the output (e.g. `# Rule: my_rule`)
- Try to keep rules small and focused for easy composition & re-use in the manifest

## 🔤 Glossary
- **Rule/Fragment**: A markdown file with instructions for LLMs on highly specific topic
- **Database**: A folder containing `rules/*.md` and `manifest` file
- **Manifest**: A file that describes the hierarchy of rules make it into the final compiled output file for LLMs to consume

## 🤝 Contributing

1. Fork this template repository
2. Create your rule databases in the `rules/` directory
3. Add tests for new functionality in `test/`
4. Ensure all tests pass: `./scripts/test`
5. Submit a pull request

### 🧪 Testing
When it comes to development of the template itself, here's the files contributor should care about:
```
ai-ruleset-manager/
├── scripts/
│   ├── ai-rules            # Main CLI tool, runned by automated tests
│   └── test                # Test runner, runs test/*.sh test scripts
└── test/                   # Comprehensive test suite
    ├── tmp/                # Place for test build artifacts
    ├── fixtures/           # Test data
    └── *.sh                # Test scripts, automatically invoked by scripts/test
```
To test the project, run `./scripts/test`. Run specific test file with `./scripts/test build-01-basic`.

## 🗺️ Roadmap
- Shell completions
- More comprehensive tests with combination of features (comments + deep nesting + rules from various databases)
- Better folder structure semantics
