# pystrap (a.k.a. bootstrappy)

**Bootstrap any Python tool from GitHub in a single command.**  
Clone, install, and launch it globally — without the virtualenv headaches.

---

## 🔧 What it Does

`pystrap` is a shell script that turns any Python-based GitHub project into a globally accessible CLI tool. It:

- Clones the repo to `/opt/<toolname>`
- Creates a Python virtual environment in that directory
- Installs dependencies from `requirements.txt` or `REQUIREMENTS`
- Finds the most likely main script
- Writes a launcher to `/usr/local/bin/<toolname>` that activates the venv and runs the tool

No symlinks, no aliases, no manual setup. Just run the tool by name.

---

## 🚀 Quick Install

Install `pystrap` directly from this repo:

```bash
curl -sSL https://raw.githubusercontent.com/tjt263/pystrap/main/install.sh | bash
```

---

## ⚡ Usage

```bash
pystrap <github-url> [custom-name]
```

### Example:

```bash
pystrap https://github.com/lanmaster53/recon-ng.git
```

This will install `recon-ng`, and you’ll be able to run it from anywhere:

```bash
recon-ng
```

Or install it under a custom name:

```bash
pystrap https://github.com/you/some-cool-tool.git mytool
mytool
```

---

## 📂 How it Works

Behind the scenes, `pystrap`:

1. Extracts the repo name from the URL
2. Clones it to `/opt/<reponame>`
3. Creates a Python virtual environment inside
4. Installs dependencies automatically
5. Detects a likely main script
6. Creates a launcher at `/usr/local/bin/<name>` that runs it in the right environment

---

## 🛠 Requirements

- Bash
- Python 3
- pip
- git
- curl

Tested on Debian/Ubuntu. Works on most Unix-like systems.

---

## 🧭 Philosophy

Scripting shouldn’t derail your momentum.  
You shouldn’t have to babysit venvs, symlink scripts, or manually wire up boilerplate just to try a tool.

This is the one-liner we always wanted.

---

## 🧪 Future Plans

- Auto-update support
- Uninstall command
- Local path support
- Domain-based install URL (`pystrap.sh` or similar)

---

## 🔓 License

MIT — do what you want, just don’t be evil.
