#!/bin/sh

# On Debian based systems, inclusion and exclusion of this file can be
# triggered with 'dpkg-reconfigure -plow git-stuff'.

alias a="git-amend-all"
alias c="git commit -a"
alias ch="git cherry-pick"
alias g="git"
alias l="git log --show-signature"
alias lp="git log --show-signature -p"
alias p="git push && git push --tags"
alias pf="git push -f && git push -f --tags"
alias s="git show --show-signature"

alias dc="${EDITOR:-vi} debian/changelog"
