function fzf_z --description "fzf for z"
    set fzf_arguments --ansi $fzf_dir_opts
    set chosen (z -l | _fzf_wrapper $fzf_arguments)

    if test $status -eq 0
        commandline --current-token --replace -- (echo $chosen | awk '{ print $2 }')
    end

    commandline --function repaint
end

