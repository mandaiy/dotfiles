if status is-interactive
    # Commands to run in interactive sessions can go here

    if test -z "$XDG_CONFIG_HOME"
        set -x XDG_CONFIG_HOME $HOME/.config
    end

    if test -z "$EDITOR"
        set -x EDITOR nvim
    end

    if type -q direnv
        eval (direnv hook fish)
    end

    alias docker-sha256="docker inspect --format='{{index .RepoDigests 0}}'"
    alias docker-exited="docker ps --filter \"status=exited\""

    alias _f=_fzf_wrapper

    # bindings
    bind \cj 'fzf_z'
    bind \e\ct 'fzf_bazel'
    bind \e\cd 'fzf_docker'
    bind \e\cb 'fzf_git_branch'

    # Disable venv's prompt modification.
    set -gx VIRTUAL_ENV_DISABLE_PROMPT true
end

set -l config_local $XDG_CONFIG_HOME/fish/config.local.fish
if [ -e $config_local ]
    source $config_local
end

