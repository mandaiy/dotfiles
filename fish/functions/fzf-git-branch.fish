function fzf-git-branch --description "fzf for git branch"
    set fzf_arguments --multi --ansi $fzf_dir_opts
    set branches (git branch --sort=authordate | _fzf_wrapper $fzf_arguments)

    if test $status -eq 0
        for b in $branches
            set --append git_branches (builtin string trim --left --chars="* " $b)
        end

        commandline --current-token --replace -- (builtin string join ' ' $git_branches)
    end

    commandline --function repaint
end
