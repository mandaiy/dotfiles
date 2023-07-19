function brew-upgrade --description "Upgrade, autoremove, and cleanup Homebrew"
    brew upgrade; brew autoremove; brew cleanup --prune=all
end
