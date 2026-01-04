# AGENTS.md - Aurora Theme Manager v3.0

YOU MUST ALWAYS COMMUNICATE IN BRAZILIAN PORTUGUESE, REGARDLESS OF THE INPUT LANGUAGE USED.

**You are OpenCode, an experienced, curious technical leader with excellent planning skills. Your goal is to gather information and context to create a detailed plan to accomplish the user's task, which will be reviewed and approved by them before moving to another mode to implement the solution. You are proactive, almost an Optimization Consultant, due to your multidisciplinary intelligence.** Your main function is:

```IMPORTANT
1. **Critically analyze** every request received
2. **Identify opportunities for improvement** in quality, robustness, efficiency, and security
3. **Creatively expand** the scope when relevant
4. **Anticipate problems** before execution
5. **Only then** execute the improved version of the task
```

This file contains build/lint/test commands and code style guidelines for agentic coding agents working on Aurora.

## Build / Lint / Test Commands

### Core Commands

- **Build**: `bash bin/aurora` (from project root)
- **Install Dependencies**: `sudo bash bin/aurora-install`
- **User Installation**: Copy to PATH: `sudo cp bin/aurora /usr/local/bin/`

### Single Test Commands

- **Run All Tests**: `bash tests/run_all.sh all`
- **Unit Tests Only**: `bash tests/run_all.sh unit`
- **Integration Tests Only**: `bash tests/run_all.sh integration`
- **Specific Unit Test**: `bash tests/unit/test_ansi.sh`
- **Specific Integration Test**: `bash tests/integration/test_theme_loading.sh`
- **Font Detection**: `bash tests/integration/test_font_detection.sh`

### Linting & Validation

- **Shell Linting**: `shellcheck src/**/*.sh bin/**/*.sh`
- **Theme Validation**: `bash bin/aurora list` (validates .yml theme files)
- **Strict Mode**: All scripts use `set -euo pipefail` (enforced)

## Code Style Guidelines

### Script Structure & Headers

```bash
#!/bin/bash
# ==============================================================================
# AURORA - [Module Name]
# [Brief description of module purpose]
# ==============================================================================
set -euo pipefail
```

### Variable Naming Conventions

**Constants**: `UPPER_SNAKE_CASE` with `readonly`

```bash
readonly SCRIPT_VERSION="3.0"
readonly THEME_DIR="$AURORA_ROOT/themes"
readonly COLOR_CARAMEL="#6a4928"
```

**Global Variables**: `UPPER_SNAKE_CASE` (exported when needed)

```bash
export THEME_NAME THEME_BG THEME_FG THEME_ACCENT
```

**Local Variables**: `lower_snake_case`

```bash
local theme_name="$1"
local theme_file="$THEME_DIR/${theme_name}.yml"
```

**Functions**: `lower_snake_case` with descriptive names

```bash
load_theme() { ... }
apply_theme_terminal() { ... }
```

### Module Import Pattern

All modules loaded via `src/config/loader.sh`:

```bash
source "$AURORA_ROOT/src/config/constants.sh"
# Then loads core/ and modules/ automatically
```

Never hardcode module paths. Use `$AURORA_ROOT`.

### Error Handling Pattern

```bash
function_with_validation() {
    local required_param="$1"

    # Validate parameters
    if [[ -z "$required_param" ]]; then
        echo "Error: required_param is required" >&2
        return 1
    fi

    # Try operation
    if ! operation_that_might_fail; then
        echo "Error: operation failed" >&2
        return 1
    fi

    return 0
}
```

### Theme File Format (YAML)

```yaml
name: "Display Name"
description: "Brief description"

colors:
  background: "#RRGGBB"
  foreground: "#RRGGBB"
  accent: "#RRGGBB"

  palette: # Exactly 16 colors required
    - "#RRGGBB"
    - "#RRGGBB"
    # ... (16 total)
```

**Ganache Palette Constants** (in src/config/constants.sh):

- NEVER modify these - project identity
- All colors defined as `readonly COLOR_*`

### Dependencies & Validation

**Required**: `yq` (YAML parser)
**Optional**: `gum` (UI), `starship` (prompt), `kmscon` (headless)

Check before use:

```bash
if ! command -v yq &>/dev/null; then
    echo "Error: yq not installed" >&2
    exit 1
fi
```

### Module Organization

```
src/
├── config/              # Constants & loader
│   ├── constants.sh   # Palette, paths, symbols
│   └── loader.sh      # Auto-load all modules
├── core/               # Main functionalities
│   ├── theme_manager.sh       # Theme loading/validation
│   ├── kmscon_integration.sh  # kmscon support
│   ├── backup_manager.sh      # Backup system
│   └── plugin_manager.sh      # Remote themes
└── modules/            # Reusable utilities
    ├── ansi.sh      # ANSI sequences
    ├── parser.sh    # YAML parser (yq wrapper)
    ├── state.sh      # State persistence
    ├── ui.sh         # User interface (gum)
    ├── utils.sh      # General utilities
    └── hooks.sh      # Shell integration (Bash/Zsh/Fish)
```

### Multi-Shell Support

Hooks support: Bash, Zsh, Fish

- Bash: `~/.bashrc` → sources `~/.config/aurora/current_theme.sh`
- Zsh: `~/.zshrc` → sources same script (compatible)
- Fish: `~/.config/fish/config.fish` → sources `~/.config/aurora/current_theme.fish`

Theme globals (`THEME_*`) must be loaded before hook injection.

### Kmscon Integration

**Detection**: `is_kmscon()` checks `$TERM == "linux"` or `$KMSCON_SESSION`
**Application**: `kmscon_apply_theme()` updates `/etc/kmscon/kmscon.conf`
**Colors**: Format `R,G,B` (comma-separated RGB), not hex

### Testing Requirements

**Unit Tests**: Test individual functions

```bash
# In tests/unit/
test_ansi.sh       # Test ANSI sequences
test_parser.sh     # Test YAML parsing
```

**Integration Tests**: Test workflows

```bash
# In tests/integration/
test_theme_loading.sh   # Test complete theme load/apply
test_kmscon.sh         # Test kmscon integration
```

**Test Pattern**:

```bash
test_something() {
    if [[ condition ]]; then
        echo "✓ Pass"
        return 0
    else
        echo "✗ Fail"
        return 1
    fi
}
```

### Security & Safety

**Root Privileges**:

- `bin/aurora-install` requires root
- `bin/aurora apply <theme>` requires root for kmscon
- Other commands work as non-root

**File Safety**:

- `backup_file()` called before any modification
- Atomic writes (temp file → move)
- Limit backups to 10 most recent

### Common Patterns

**Theme Loading**:

```bash
# 1. Validate file exists
# 2. Load with yq
# 3. Validate required fields
# 4. Export THEME_* globals
# 5. Apply with apply_theme_terminal()
```

**Backup Pattern**:

```bash
backup_file() {
    local file="$1"
    local backup_file="$BACKUP_DIR/$(basename $file).$(date +%Y%m%d_%H%M%S).bak"
    cp "$file" "$backup_file"
    cleanup_old_backups  # Keep only 10
}
```

**Error Messages**: Use `echo "..." >&2` for errors, `echo "..."` for info.

### Cursor Rules

See `.cursor/rules/cursor_rules.mdc` for:

- General coding standards
- File structure requirements
- Import/export patterns

### Environment Variables

- `AURORA_ROOT`: Auto-detected project root
- `THEME_DIR`: Location of YAML themes (`$AURORA_ROOT/themes`)
- `AURORA_PLUGIN_REPO`: Override remote theme repo URL
- `AURORA_DEBUG`: Set to `1` for debug output

### Quick Reference

**Add New Theme**:

1. Create YAML in `themes/` (follow format)
2. Test: `bash bin/aurora preview theme_name`
3. Validate contrast is WCAG AA compliant (≥ 4.5:1)

**Add New Core Module**:

1. Create in `src/core/` or `src/modules/`
2. Follow header pattern
3. Add dependency checks if needed
4. Auto-loaded by `loader.sh`

**Test Changes**:

```bash
# Run all tests
bash tests/run_all.sh all

# Lint
shellcheck src/**/*.sh
```

### Prohibited Actions

1. NEVER modify Ganache palette constants
2. NEVER hardcode paths (use `$AURORA_ROOT`)
3. NEVER skip parameter validation
4. NEVER modify system files without `backup_file()`
5. NEVER use deprecated `.theme` format (YAML only)
6. NEVER bypass `loader.sh` - it manages all modules
7. NEVER ignore `set -euo pipefail`
8. NEVER break existing multi-shell hooks
