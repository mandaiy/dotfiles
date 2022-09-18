function _brew_shellenv
    set -l brew

    switch (uname)
    case Darwin
        set brew /opt/homebrew/bin/brew
    case Linux
        set brew /home/linuxbrew/.linuxbrew/bin/brew
    end

    test -x $brew; and eval ($brew shellenv)
end


if status is-interactive
    # Commands to run in interactive sessions can go here
    _brew_shellenv

    if test -z "$XDG_CONFIG_HOME"
        set -gx XDG_CONFIG_HOME $HOME/.config
    end

    if test -z "$EDITOR"
        set -gx EDITOR nvim
    end

    if test -z "$GOPATH"
        set -gx GOPATH $HOME/.go
        set -gx PATH $GOPATH/bin $PATH
    end

    if type -q direnv
        eval (direnv hook fish)
        alias tmux "direnv exec / tmux"
    end

    if type -q rbenv
        rbenv init - fish | source
    end

    alias docker-sha256="docker inspect --format='{{index .RepoDigests 0}}'"
    alias docker-exited="docker ps --filter \"status=exited\""

    alias _f=_fzf_wrapper
    alias cd-gitroot="cd (git rev-parse --show-toplevel)"

    # bindings
    bind \ez 'fzf_z'
    bind \e\ct 'fzf_bazel'
    bind \e\cd 'fzf_docker'
    bind \e\cb 'fzf_git_branch'

    # Fish git prompt
    set __fish_git_prompt_showdirtystate 'yes'
    set __fish_git_prompt_showstashstate 'yes'
    set __fish_git_prompt_showuntrackedfiles 'yes'
    set __fish_git_prompt_showupstream 'yes'
    set __fish_git_prompt_color_branch yellow
    set __fish_git_prompt_color_upstream_ahead green
    set __fish_git_prompt_color_upstream_behind red

    # Status Chars
    set __fish_git_prompt_char_dirtystate '⚡'
    set __fish_git_prompt_char_stagedstate '→'
    set __fish_git_prompt_char_untrackedfiles '☡'
    set __fish_git_prompt_char_stashstate '↩'
    set __fish_git_prompt_char_upstream_ahead '+'
    set __fish_git_prompt_char_upstream_behind '-'

    # Disable venv's prompt modification.
    set -gx VIRTUAL_ENV_DISABLE_PROMPT true

    if not test -z "$Z_DATA"
        z_cleanup
    end
end

set -l config_local $XDG_CONFIG_HOME/fish/config.local.fish
if [ -e $config_local ]
    source $config_local
end

