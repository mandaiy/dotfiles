function org-note --description "org-note"
    argparse --name note --exclusive "o,s" \
        "o/open" "s/sync" -- $argv or return

    if set -lq _flag_open
        _note_open
        return
    end

    if set -lq _flag_sync
        _note_sync
        return
    end
end

function _note_open
    nvim $MANDAIY_ORG_NOTE_DIR/index.norg
end


function _note_sync
    echo "Not implemented"
end
