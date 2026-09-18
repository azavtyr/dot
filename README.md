# dot
My macOS config files and scripts.

Run `./setup` from this repository to install the config symlinks and link
`duck`, `lynx`, `urlencode`, and `vic` into `~/Scripts`. Run `./setup --opt`
to also install FlashSpace and skhd. To install only the
script symlinks, run `./scripts/setup`.

After installing the required packages, `./setup` moves a GitHub clone into
`~/Repos/github.com/<owner>/<repo>` before creating any config symlinks. The
owner and repository name come from the `origin` remote. Set `REPOS` to use a
different absolute repository root; Bash will keep using that value for the
clone helper. Setup stops without moving anything if the target already exists.
Re-running setup from a repository that is already in this structure does not
require an `origin` remote.

In Bash, `?` is an alias for `duck`, which opens a
DuckDuckGo Lite search in Lynx. English and Ukrainian queries are encoded as
UTF-8 URLs. The `lynx` wrapper uses the configuration in `~/.config/lynx`.
Lynx and Bash must be installed; tmux is optional.
