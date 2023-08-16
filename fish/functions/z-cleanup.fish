function z-cleanup --description "Clean up z data"
    # Because POSIX sed does not have -i option,
    # here we use tmpfile and redirect to update the file.
    set -l tmp_file (mktemp)

    for d in (cat $Z_DATA | awk -F"|" '{print $1}')
        if not test -e $d
            sed "\|^$d|d" $Z_DATA > $tmp_file
            cp $tmp_file $Z_DATA
        end
    end

    rm -f $tmp_file
end
