# LLM Ruleset Manager

A template repository for managing reusable Markdown "rules" that can be composed into comprehensive LLM instruction documentation. Perfect for teams that want to maintain consistent, modular AI prompts and instructions.

## 🚀 Quick Start

1. **Use this template**: Click "Use this template" on GitHub to create your own repository
2. **Install the CLI** (optional):
   ```bash
   ./scripts/llm-rules install
   ```
3. **Create your first rule database**:
   ```bash
   ./scripts/llm-rules new --database myproject
   ```
4. **Add some rules** to `rules/myproject/rules/`:
   ```bash
   echo "## Code Quality\nAlways write clean, readable code." > rules/myproject/rules/code-quality.md
   echo "## Testing\nWrite comprehensive tests." > rules/myproject/rules/testing.md
   ```
5. **Create a manifest** in `rules/myproject/manifest`:
   ```
   # My Project Rules
   | code-quality
   | testing
   ```
6. **Build your documentation**:
   ```bash
   ./scripts/llm-rules build --manifest rules/myproject/manifest
   ```

Your compiled documentation will be in `build/myproject.md`!

## 📋 Features

- **🧩 Modular Rules**: Break complex instructions into reusable components
- **📚 Multiple Databases**: Organize rules by project, team, or domain
- **🌳 Hierarchical Structure**: Support for nested rule organization (up to 6 levels)
- **📝 Automatic Titles**: Auto-generated rule titles and proper heading levels
- **✅ Validation**: Built-in validation to catch errors before building
- **🔧 POSIX Compatible**: Works on any Unix-like system
- **🧪 Comprehensive Tests**: 17 test cases covering functionality and edge cases

## 📁 Project Structure

```
llm-ruleset-manager/
├── scripts/
│   ├── llm-rules          # Main CLI tool
│   └── test              # Test runner
├── rules/
│   └── README.md         # Template for rule databases
├── build/
│   └── .example.md       # Example output
└── test/                 # Comprehensive test suite
    ├── fixtures/         # Test data
    └── *.sh             # Test scripts
```

## 🛠️ CLI Commands

### Build Documentation
```bash
./scripts/llm-rules build --manifest <path> [--out <file>]
```
Compiles rules from a manifest into a single markdown file.

**Examples:**
```bash
# Build with default output location
./scripts/llm-rules build --manifest rules/myproject/manifest

# Build with custom output
./scripts/llm-rules build --manifest rules/myproject/manifest --out custom-docs.md
```

### Create New Database
```bash
./scripts/llm-rules new --database <name>
```
Creates a new rule database with proper directory structure.

**Example:**
```bash
./scripts/llm-rules new --database frontend-rules
```

### Validate Manifest
```bash
./scripts/llm-rules validate --manifest <path>
```
Validates manifest syntax and checks that all referenced rules exist.

**Example:**
```bash
./scripts/llm-rules validate --manifest rules/myproject/manifest
```

### Install CLI
```bash
./scripts/llm-rules install [--prefix <path>]
```
Installs the CLI tool to your system.

### Deploy Documentation
```bash
./scripts/llm-rules deploy --manifest <path> --out <file>
```
Builds documentation and creates a symlink for easy access.

## 📋 Manifest Format

Manifests use a pipe-based hierarchical format:

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

## 📝 Writing Rules

Rules are standard Markdown files stored in `rules/<database>/rules/`:

**rules/myproject/rules/code-style.md:**
```markdown
## Consistent Formatting

Use consistent code formatting throughout the project.

### Naming Conventions
- Use camelCase for variables
- Use PascalCase for classes

### Indentation
Use 2 spaces for indentation.
```

**Key Points:**
- Use any heading levels you want - they'll be automatically normalized
- Support for code blocks, lists, links, and all Markdown features
- Each rule file becomes a titled section in the output

## 🏗️ Example Workflow

### 1. Create a New Project Database
```bash
./scripts/llm-rules new --database react-guidelines
```

### 2. Add Rules
```bash
# Component rules
cat > rules/react-guidelines/rules/component-structure.md <<EOF
## Component Structure

Every React component should follow this structure:
- Props interface at the top
- Component function with proper typing
- Export at the bottom
EOF

# State management rules
cat > rules/react-guidelines/rules/state-management.md <<EOF
## State Management

Use React hooks for local state:
- useState for simple state
- useReducer for complex state logic
EOF
```

### 3. Create Manifest
```bash
cat > rules/react-guidelines/manifest <<EOF
# React Development Guidelines
| component-structure
| state-management
EOF
```

### 4. Build and Validate
```bash
# Validate first
./scripts/llm-rules validate --manifest rules/react-guidelines/manifest

# Build documentation
./scripts/llm-rules build --manifest rules/react-guidelines/manifest
```

### 5. Use Your Documentation
The compiled documentation in `build/react-guidelines.md` will look like:
```markdown
# Rule: component-structure

## Component Structure

Every React component should follow this structure:
- Props interface at the top
- Component function with proper typing
- Export at the bottom

# Rule: state-management

## State Management

Use React hooks for local state:
- useState for simple state
- useReducer for complex state logic
```

## 🌳 Hierarchical Example

**Manifest:**
```
# Complex Project Structure
| introduction
| architecture
|| frontend
||| components
||| styling
|| backend
||| api-design
||| database
| conclusion
```

**Output Structure:**
```markdown
# Rule: introduction
## Introduction
...

# Rule: architecture
## Architecture
...

## Rule: frontend
### Frontend
...

### Rule: components
#### Components
...

### Rule: styling
#### Styling
...

## Rule: backend
### Backend
...

# Rule: conclusion
## Conclusion
...
```

## 🧪 Testing

Run the comprehensive test suite:
```bash
# Run all tests
./scripts/test

# Run specific tests
./scripts/test build-01-basic.sh validate-01-basic.sh

# Run tests by pattern
./scripts/test build-*
```

**Test Coverage:**
- ✅ Build functionality (basic, nested, error conditions)
- ✅ Validation (success and error cases)
- ✅ New database creation
- ✅ Edge cases (missing files, invalid nesting, EOF handling)

## 🔧 Development

**Requirements:**
- POSIX-compliant shell
- Standard Unix utilities (`grep`, `sed`, `awk`)

**Environment Variables:**
- `LLM_RULES_DIR`: Override rules directory (useful for testing)

## 📄 Use Cases

Perfect for:
- **AI/LLM Prompt Engineering**: Modular, reusable prompt components
- **Team Coding Standards**: Shared development guidelines
- **Documentation Templates**: Consistent documentation across projects
- **Policy Management**: Modular business rules and policies
- **Training Materials**: Structured learning content

## 🤝 Contributing

1. Fork this template repository
2. Create your rule databases in the `rules/` directory
3. Add tests for new functionality in `test/`
4. Ensure all tests pass: `./scripts/test`
5. Submit a pull request

## 📧 Support

This is a template repository - customize it for your needs! The CLI tool is designed to be portable and easily modified.

---

**Happy rule management!** 🎉