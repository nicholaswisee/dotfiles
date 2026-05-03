source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
# function fish_greeting
#    # smth smth
#end

# Aliases
alias g='git'
alias n='nvim'
alias yz='yazi'
alias antigravity='antigravity 2>/dev/null'
alias gt="ghosttime"

abbr -a aidergemini "aider --model gemini/gemini-2.5-pro"
abbr -a aiderqwen "aider --model openrouter/qwen/qwen3-coder:free"

fnm env --use-on-cd | source

fzf --fish | source

starship init fish | source
zoxide init fish | source



# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# java
set -Ux JAVA_HOME /usr/lib/jvm/default

# golang
set -Ux GOPATH $HOME/go
set -Ux PATH $PATH $GOPATH/bin

if status is-interactive
and not set -q TMUX
    exec tmux
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/nicholaswisee/.ghcup/bin $PATH # ghcup-env

# pnpm
set -gx PNPM_HOME "/home/nicholaswisee/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end

set -x WINE_DISABLE_WOW64 1

# pnpm end

# opencode
fish_add_path /home/nicholaswisee/.opencode/bin

