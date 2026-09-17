# dot
Here's my config files, scripts, etc.

Run `./setup` from this repository to install the config symlinks and link
`duck`, `lynx`, and `urlencode` into `~/Scripts`. To install only the script
symlinks, run `./scripts/setup`.

In Bash, `?` is an alias for `duck`, which opens a
DuckDuckGo Lite search in Lynx. English and Ukrainian queries are encoded as
UTF-8 URLs. The `lynx` wrapper uses the configuration in `~/.config/lynx`.
Lynx and Bash must be installed; tmux is optional.
