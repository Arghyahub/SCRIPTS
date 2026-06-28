#!/usr/bin/env bash

set -e

FUNC_FILE="$HOME/.config/shell/func"

# --------------------------
# Helper: append only if missing
# --------------------------
append_if_missing() {
    local line="$1"
    local file="$2"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    grep -Fxq "$line" "$file" || printf "%s\n" "$line" >> "$file"
}

# ==========================
# Task Runner
# ==========================

run_task() {
    local title="$1"
    shift

    printf "\n####### %s #######\n\n" "$title"
    export FUNC_FILE
    bash -c "$(declare -f append_if_missing); $1"

    printf "\n"
}

#!/usr/bin/env bash

run_task "CREATE FUNCTION FILE" '
mkdir -p ~/.config/shell
touch "${FUNC_FILE}"

cat > "$FUNC_FILE" <<EOF
#!/usr/bin/env bash

# --------------------------
# Append line to file if missing
# --------------------------
append_if_missing() {
    local line="$1"
    local file="$2"

    mkdir -p "$(dirname "$file")"
    touch "$file"

    grep -Fxq "$line" "$file" || printf "%s\n" "$line" >> "$file"
}

# --------------------------
# macOS-like clipboard commands
# --------------------------
pbcopy() {
    if command -v wl-copy >/dev/null 2>&1; then
        if [ $# -gt 0 ]; then
            wl-copy < "$1"
        else
            wl-copy
        fi
    elif command -v xclip >/dev/null 2>&1; then
        if [ $# -gt 0 ]; then
            xclip -selection clipboard < "$1"
        else
            xclip -selection clipboard
        fi
    else
        echo "No clipboard utility found." >&2
        return 1
    fi
}

pbpaste() {
    if command -v wl-paste >/dev/null 2>&1; then
        wl-paste
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -o
    else
        echo "No clipboard utility found." >&2
        return 1
    fi
}

# --------------------------
# Create directory and cd
# --------------------------
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# --------------------------
# Create file with parent directories
# --------------------------
mkfile() {
    mkdir -p "$(dirname "$1")"
    touch "$1"
}

# --------------------------
# Extract common archives
# --------------------------
extract() {
    [ -f "$1" ] || {
        echo "File not found: $1"
        return 1
    }

    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.tar.xz)  tar xJf "$1" ;;
        *.tar)     tar xf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.xz)      unxz "$1" ;;
        *)         echo "Cannot extract '$1'" ;;
    esac
}

# --------------------------
# Print PATH one entry per line
# --------------------------
path() {
    printf "%s\n" "${PATH//:/\\n}"
}

# --------------------------
# Reload current shell config
# --------------------------
reload() {
    if [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc
    else
        source ~/.bashrc
    fi
}
EOF
'

run_task "UPDATING ENV" '
BASH_LINE3="[ -f ~/.config/shell/func ] && . ~/.config/shell/func"
ZSH_LINE3="[[ -f ~/.config/shell/func ]] && source ~/.config/shell/func"

append_if_missing "$BASH_LINE3" ~/.bashrc
append_if_missing "$ZSH_LINE3" ~/.zshrc
'