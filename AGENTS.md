# Repository Guidelines

## Project Structure & Module Organization
This repository manages user environment config and bootstrap tooling. Top-level directories map to target tools: `fish/`, `zsh/`, `nvim/`, `tmux/`, `screen/`, `alacritty/`, `git/`, `colima/`, and `docker/`. The bootstrap entrypoint is [`init`](/Users/mandai/.dotfiles/init), a Python script that creates symlinks under `$XDG_CONFIG_HOME` and clones required plugins such as `tmux/plugins/tpm`. Keep tool-specific changes inside their existing directory, and place longer design notes in `docs/`.

## Build, Test, and Development Commands
Use these commands from the repository root:

- `./init`: installs or refreshes symlinks and is the main smoke test used in CI.
- `pre-commit run --all-files`: runs repository checks, including YAML cleanup and formatting hooks.
- `stylua nvim/**/*.lua`: formats Lua files using the checked-in `.stylua.toml`.
- `black init && isort init`: formats the Python bootstrap script.
- `docker build -f ./docker/Dockerfile -t mandaiy/dotfiles:linux-amd64 --platform linux/amd64 .`: mirrors the Docker workflow.

## Coding Style & Naming Conventions
Follow the style already used in each area. Python in `init` is formatted with `black` and `isort`; prefer small helper functions and clear class names such as `GitClone` or `SymlinkToConfig`. Lua uses `stylua` with spaces, 3-space indentation, and a 120-column limit. Shell files should preserve the existing style of their shell (`fish` syntax in `fish/`, POSIX or zsh syntax in `zsh/`). Name files by tool and purpose, for example `fish/functions/fzf-z.fish`.

## Testing Guidelines
There is no unit-test suite today; validation is primarily smoke-test based. Run `./init` before opening a PR, ideally in a clean environment or container, and confirm the expected symlinks and plugin bootstrap behavior. For config changes, test the affected tool directly, such as launching `nvim` or starting a new `fish` session.

## Commit & Pull Request Guidelines
Recent commits use a short scope prefix followed by a concise summary, for example `tmux: fix TMUX_SHELL` or `nvim: add vim-slime`. Keep that pattern, use imperative mood, and keep the scope aligned to the directory you changed. PRs should describe the user-visible impact, list the commands you ran, and note platform assumptions. Include screenshots only for visual UI changes, such as terminal or editor appearance updates.

## Security & Configuration Tips
Do not commit machine-specific secrets or local overrides. Use `envrc.sample` as the template for environment variables, and keep personal overrides in untracked local config files such as `config.local.fish` or `.zshrc.local`.
