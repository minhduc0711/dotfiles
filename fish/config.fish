if status is-interactive
    # Commands to run in interactive sessions can go here
end

# add custom executables to path
set --prepend PATH "$HOME/.local/bin"

# suppress the default login message
set -g fish_greeting

fish_vi_key_bindings
fish_config theme choose Tomorrow

eval (dircolors -c ~/.dircolors)

# FZF
fzf_configure_bindings --directory=\cp
set fzf_preview_file_cmd cat -n

# Environment variables
set -x YDIFF_OPTIONS '-s -w0 --wrap'

direnv hook fish | source
