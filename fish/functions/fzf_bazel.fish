function fzf_bazel --description "fzf for bazel"
    type -q bazel || return 0

    set -l targets (bazel query ... 2>/dev/null | _fzf_wrapper)

    if test $status -eq 0
        commandline --current-token --replace $targets
    end

    commandline --function repaint
end
