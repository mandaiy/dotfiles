function colima-up
    colima start --arch aarch64 \
        --vm-type=vz --vz-rosetta \
        --mount-type virtiofs --mount-inotify \
        --cpu 8 --memory 16 --disk 128 \
        --dns 8.8.8.8 --dns 1.1.1.1
end
