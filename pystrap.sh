#!/usr/bin/env bash
set -euo pipefail

print_usage() {
    echo "Usage: pystrap [-h] <github-url> [command-name]"
    echo
    echo "Arguments:"
    echo "  github-url       GitHub repo URL (e.g. https://github.com/user/repo.git)"
    echo "  command-name     Optional command name (default: repo name)"
    echo
    echo "Options:"
    echo "  -h               Show this help message"
}

make_executable() {
    local path="$1"
    chmod +x "$path"
}

ensure_python_shebang() {
    local path="$1"
    if [[ "$path" == *.py ]]; then
        local first_line
        first_line=$(head -n 1 "$path")
        if [[ "$first_line" != "#!"* ]]; then
            echo "[*] Inserting Python shebang into $path"
            sed -i '1i#!/usr/bin/env python3' "$path"
        fi
    fi
}

# Parse options
while getopts ":h" opt; do
    case ${opt} in
        h )
            print_usage
            exit 0
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            print_usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check required positional argument
if [[ $# -lt 1 ]]; then
    echo "Error: GitHub URL is required."
    print_usage
    exit 1
fi

REPO_URL="$1"
CMD_NAME="${2:-}"

# Determine repo and install path
REPO_NAME="$(basename -s .git "$REPO_URL")"
INSTALL_DIR="/opt/$REPO_NAME"
COMMAND="${CMD_NAME:-$REPO_NAME}"

# Wipe existing install
if [[ -d "$INSTALL_DIR" ]]; then
    echo "[*] Removing existing install: $INSTALL_DIR"
    sudo rm -rf "$INSTALL_DIR"
fi

# Clone repo
echo "[*] Cloning $REPO_URL to $INSTALL_DIR..."
git clone "$REPO_URL" "$INSTALL_DIR"

# Setup virtual environment
echo "[*] Creating virtual environment..."
python3 -m venv "$INSTALL_DIR/venv"
source "$INSTALL_DIR/venv/bin/activate"

cd "$INSTALL_DIR"

# Install dependencies
if [[ -f REQUIREMENTS ]]; then
    echo "[*] Installing from REQUIREMENTS..."
    pip install -r REQUIREMENTS
elif [[ -f requirements.txt ]]; then
    echo "[*] Installing from requirements.txt..."
    pip install -r requirements.txt
else
    echo "[*] No requirements file found. Skipping dependency install."
fi

# Detect main script
ENTRY="$(find . -maxdepth 1 -type f \( -name '*.py' -o -executable \) | head -n1)"
if [[ -z "$ENTRY" ]]; then
    echo "Error: No entrypoint found."
    exit 1
fi

ENTRY_PATH="$(realpath "$ENTRY")"
make_executable "$ENTRY_PATH"
ensure_python_shebang "$ENTRY_PATH"

# Create launcher
echo "[*] Creating launcher: /usr/local/bin/$COMMAND"
cat <<EOF | sudo tee /usr/local/bin/"$COMMAND" > /dev/null
#!/bin/bash
source "$INSTALL_DIR/venv/bin/activate"
exec "$ENTRY_PATH" "\$@"
EOF

sudo chmod +x /usr/local/bin/"$COMMAND"
echo "[+] Tool installed. Run it with: $COMMAND"

