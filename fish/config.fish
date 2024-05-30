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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniforge3/bin/conda
    status is-interactive && eval $HOME/miniforge3/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniforge3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniforge3/bin" $PATH
    end
end

if test -f "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
    source "$HOME/miniforge3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<
