function fzf_docker --description "fzf for docker completion"
    set -l args (commandline | builtin string trim | builtin string replace " " "")

    if builtin string match -r '^docker$' $args > /dev/null 2>&1
        set subcommand (docker --help | \
            sed -n -e '/Management Commands:/,$p' | \
            grep -v "Management Commands:" | \
            grep -v "Commands:" | \
            grep -v "COMMAND --help" | \
            grep -v "To get more" | \
            grep . | \
            _fzf_wrapper | awk '{ print $1 }')
        commandline --replace "docker $subcommand"

    else if builtin string match -r '^docker(run|push)' $args > /dev/null 2>&1
        set image (docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}" | \
            _fzf_wrapper --header-lines=1 | awk '{ print $1 }'
        )
        commandline --insert $image

    else if builtin string match -r '^docker(rmi)' $args > /dev/null 2>&1
        set images (docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.ID}}\t{{.CreatedSince}}" | \
            _fzf_wrapper --header-lines=1 --multi | awk '{ print $1 }' | builtin string join ' '
        )
        commandline --insert $images
    end

    commandline --function repaint
end
