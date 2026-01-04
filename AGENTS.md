# AGENTS.md - Aurora Theme Manager

YOU MUST ALWAYS COMMUNICATE IN BRAZILIAN PORTUGUESE, REGARDLESS OF THE INPUT LANGUAGE USED.

**You are Kilo Code, an experienced, curious technical leader with excellent planning skills. Your goal is to gather information and context to create a detailed plan to accomplish the user's task, which will be reviewed and approved by them before moving to another mode to implement the solution. You are proactive, almost an Optimization Consultant, due to your multidisciplinary intelligence.** Your main function is:

```IMPORTANT
1. **Critically analyze** every request received
2. **Identify opportunities for improvement** in quality, robustness, efficiency, and security
3. **Creatively expand** the scope when relevant
4. **Anticipate problems** before execution
5. **Only then** execute the improved version of the task
```

This file contains build/lint/test commands and code style guidelines for agentic coding agents working on the Aurora project.

## Build / Lint / Test Commands

### Core Commands

- **Build**: `bash src/aurora.sh` (direct execution) or `./aurora` (from project root)
- **Install Dependencies**: `sudo bash src/aurora.sh install` or `sudo aurora install`
- **Test Font Detection**: `bash test_font_detection.sh`
- **Debug Font Installation**: `bash debug_font_install.sh`

### Single Test Commands

- **Font Detection Test**: `bash test_font_detection.sh`
- **Theme Validation**: `bash src/aurora.sh list` (validates theme files)
- **Preview Test**: `bash src/aurora.sh preview ganache_lait` (tests theme preview)

### Linting & Validation

- **Shell Script Linting**: `shellcheck src/*.sh src/modules/*.sh`
- **Bash Strict Mode**: All scripts use `set -euo pipefail`
- **Theme File Validation**: `bash src/aurora.sh list` (validates .theme files)

## Code Style Guidelines

### Shell Scripting Standards

#### 1. Script Structure & Headers

```bash
#!/bin/bash
# ==============================================================================
# AURORA - Module Name
# Brief description of module purpose
# ==============================================================================
```

#### 2. Error Handling & Safety

- **Always use strict mode**: `set -euo pipefail`
- **Function validation**: Check dependencies before execution
- **Root privilege checks**: Use `check_root()` function for admin operations
- **File existence checks**: Validate files before operations

#### 3. Variable Naming Conventions

- **Constants**: `UPPER_SNAKE_CASE` with `readonly` declaration
- **Global variables**: `UPPER_SNAKE_CASE` (exported when needed)
- **Local variables**: `lower_snake_case`
- **Function names**: `lower_snake_case` with descriptive names
- **Theme constants**: Prefix with theme name, e.g., `COLOR_GANACHE_DARK`

#### 4. Function Patterns

```bash
# Function with validation
function_name() {
    local param1="$1"
    local param2="${2:-default_value}"

    # Validation
    if [[ -z "$param1" ]]; then
        echo "Error: param1 is required" >&2
        return 1
    fi

    # Implementation
    # ...
}
```

#### 5. Import & Source Patterns

- **Module imports**: Use relative paths with source validation

```bash
# shellcheck source=/dev/null
source "$AURORA_ROOT/src/modules/module_name.sh"
```

- **Theme loading**: Validate theme files before sourcing

```bash
if [[ -f "$theme_file" ]]; then
    # shellcheck source=/dev/null
    source "$theme_file"
fi
```

### Code Organization

#### 1. Directory Structure

```
src/
├── aurora.sh           # Main entry point
└── modules/
    ├── ansi.sh         # ANSI escape sequences
    ├── parser.sh       # YAML/JSON parsing
    ├── utils.sh        # Utility functions
    ├── state.sh        # State management
    ├── ui.sh           # User interface
    ├── hooks.sh        # Shell integration
    └── plugins.sh      # Plugin system
```

#### 2. Module Dependencies

- **Core modules**: `ansi.sh`, `utils.sh` (no dependencies)
- **Parser modules**: `parser.sh` (requires yq)
- **UI modules**: `ui.sh` (requires gum)
- **State modules**: `state.sh` (requires jq for JSON operations)

#### 3. Theme File Format

```bash
# Theme files use .theme extension
# Variables follow THEME_* naming convention
THEME_NAME="Display Name"
THEME_DESCRIPTION="Human readable description"
BG_COLOR="#RRGGBB"
FG_COLOR="#RRGGBB"
ACCENT="#RRGGBB"
KMSCON_BG="R,G,B"
KMSCON_FG="R,G,B"
```

### Dependencies & External Tools

#### 1. Required System Dependencies

- **kmscon**: Terminal emulator for headless servers
- **starship**: Prompt engine
- **gum**: Interactive UI toolkit (Charm.sh)
- **fontconfig**: Font management
- **curl**: Download utility

#### 2. Optional Dependencies

- **yq**: YAML parser (Python version preferred)
- **jq**: JSON parser (for state management)
- **fc-list**: Font listing utility

#### 3. Dependency Checking Pattern

```bash
check_dependency() {
    local cmd="$1"
    local package="$2"

    if ! command -v "$cmd" &>/dev/null; then
        echo "❌ ERRO: '$cmd' não está instalado."
        echo "Instale com: sudo apt install $package"
        exit 1
    fi
}
```

### Error Handling & User Experience

#### 1. User Feedback Standards

- **Success messages**: Use `box_success()` function with green styling
- **Error messages**: Use `box_error()` function with red styling
- **Warnings**: Use `box_warning()` function with yellow styling
- **Info messages**: Use `box_info()` function with accent color

#### 2. Interactive Elements

- **Confirmations**: Use `gum confirm` for critical operations
- **Selections**: Use `gum choose` for theme selection
- **Loading**: Use `gum spin` for long operations
- **Input**: Use `gum input` for user input

#### 3. Color & UI Constants

```bash
# Ganache color palette (DO NOT ALTER)
readonly COLOR_CARAMEL="#6a4928"
readonly COLOR_DARK_CARAMEL="#5f4224"
readonly COLOR_COCOA="#553a20"
# ... (full palette defined in aurora.sh)

# UI Colors
readonly UI_BORDER="$COLOR_CARAMEL"
readonly UI_TEXT="$COLOR_ROASTED_ALMOND"
readonly UI_ACCENT="$COLOR_SOFT_BROWN"
readonly UI_SUCCESS="#26a048"
readonly UI_ERROR="#b03a24"
```

### Security & System Integration

#### 1. Root Privilege Management

- **Installation**: Requires root for system-wide changes
- **Theme Application**: Root required for kmscon configuration
- **User Operations**: Non-root for preview and listing

#### 2. File Safety Patterns

- **Backup before modify**: Use `backup_system_config()` function
- **Atomic operations**: Write to temp file, then move
- **Permission checks**: Validate file permissions before operations

#### 3. System Integration Points

- **kmscon.conf**: `/etc/kmscon/kmscon.conf`
- **starship.toml**: `$HOME/.config/starship.toml`
- **bashrc**: `$HOME/.bashrc`
- **Theme directory**: `/etc/aurora/themes/`

### Testing & Validation

#### 1. Test Categories

- **Unit tests**: Individual module functions
- **Integration tests**: Theme application workflow
- **System tests**: Font detection and installation
- **UI tests**: Interactive elements and user experience

#### 2. Validation Patterns

```bash
# Theme file validation
validate_theme_file() {
    local theme_file="$1"

    # Required variables check
    local required_vars=("THEME_NAME" "BG_COLOR" "FG_COLOR" "ACCENT")
    for var in "${required_vars[@]}"; do
        if ! grep -q "^$var=" "$theme_file"; then
            echo "Error: Missing required variable $var in $theme_file"
            return 1
        fi
    done
}
```

#### 3. Debugging Tools

- **Font detection**: `test_font_detection.sh`
- **Installation debugging**: `debug_font_install.sh`
- **Theme validation**: `aurora list` command

### Performance & Optimization

#### 1. Resource Management

- **Minimal dependencies**: Prefer system tools over external packages
- **Efficient parsing**: Use grep/sed for simple operations, jq/yq for complex data
- **Caching**: Cache font detection results and theme listings

#### 2. Startup Optimization

- **Lazy loading**: Load modules only when needed
- **Early validation**: Check dependencies at startup
- **Fast fallbacks**: Provide alternatives when optional tools are missing

### Documentation & Maintenance

#### 1. Code Documentation

- **Function headers**: Describe purpose, parameters, return values
- **Inline comments**: Explain complex logic and calculations
- **TODO markers**: Use `# TODO:` for future improvements

#### 2. Version Management

- **Script version**: Define `SCRIPT_VERSION` constant
- **Theme versioning**: Include version in theme files
- **Backward compatibility**: Maintain compatibility with older theme formats

#### 3. Development Workflow

- **Feature branches**: Use descriptive branch names
- **Commit messages**: Follow conventional commit format
- **Testing**: Run validation scripts before commits

## Cursor Rules Integration

This project follows Cursor rules defined in `.cursor/rules/`:

- **cursor_rules.mdc**: General coding standards and file structure
- **taskmaster.mdc**: Task management and development workflow
- **dev_workflow.mdc**: Development process and best practices

## Environment Variables

- **AURORA_ROOT**: Project root directory (auto-detected)
- **AURORA_THEME**: Override current theme for session
- **AURORA_HOME**: Installation directory (default: /etc/aurora)
- **FORCE_INSTALL**: Skip installation confirmations (set to "true")

## Common Pitfalls to Avoid

1. **Don't hardcode paths**: Use defined constants and environment variables
2. **Don't skip validation**: Always check dependencies and file existence
3. **Don't ignore errors**: Use proper error handling and user feedback
4. **Don't modify system files without backup**: Always use backup functions
5. **Don't break the color palette**: Never modify the Ganache color constants
6. **Don't assume root privileges**: Check and handle privilege levels appropriately
7. **Don't ignore shell compatibility**: Use bash-specific features intentionally
8. **Don't skip testing**: Validate changes with test scripts before committing

## Quick Reference for Common Tasks

### Adding a New Theme

1. Create theme file in `/etc/aurora/themes/`
2. Follow theme file format with required variables
3. Test with `aurora list` and `aurora preview <theme_name>`
4. Validate color contrast with built-in WCAG validation

### Adding a New Module

1. Create file in `src/modules/`
2. Follow naming convention and header format
3. Add dependency checks if required
4. Source module in main script with validation

### Modifying Core Functions

1. Check for existing usage patterns
2. Maintain backward compatibility
3. Update documentation and comments
4. Test with all theme variations
5. Run validation scripts before committing
