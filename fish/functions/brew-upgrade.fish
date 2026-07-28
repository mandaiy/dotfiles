function brew-upgrade --description "Upgrade, autoremove, and cleanup Homebrew"
    brew upgrade -y; brew autoremove; brew cleanup --prune=all
end
