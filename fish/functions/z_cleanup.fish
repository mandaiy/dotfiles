function z_cleanup --description "Clean up z data"
    for d in (cat $Z_DATA | awk -F"|" '{print $1}')
        test -e $d || sed -i "\|^$d|d" $Z_DATA
    end
end
