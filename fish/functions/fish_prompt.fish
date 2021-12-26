function fish_prompt --description 'Informative prompt'
    #Save the return status of the previous command
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    printf "\n"
    if functions -q fish_is_root_user; and fish_is_root_user
        printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
                                                         and set_color $fish_color_cwd_root
                                                         or set_color $fish_color_cwd) \
            (prompt_pwd) (set_color normal)
    else
        set -l status_color (set_color $fish_color_status)
        set -l statusb_color (set_color --bold $fish_color_status)
        set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
        set -l host_color brblue

        if test -n "$SSH_CONNECTION"
            set host_color bryellow
        end

        set -l venv_prompt ""
        if test -n "$VIRTUAL_ENV"
            set venv_prompt "(venv)"
        end

        printf '[%s] %s%s@%s %s%s %s %s%s%s\n> ' \
            (date "+%H:%M:%S") \
            (set_color $host_color) $USER (prompt_hostname) \
            (set_color $fish_color_cwd) $PWD \
            $venv_prompt \
            $pipestatus_string (set_color normal)
    end
end
