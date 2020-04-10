find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    GIT_TERMINAL_PROMPT=0 GIT_HTTP_LOW_SPEED_TIME=1 GIT_HTTP_LOW_SPEED_LIMIT=10 git fetch origin --unshallow -j 6 --quiet > /dev/null 2>&1
    if [[ "$branch" == "HEAD" ]]; then
      branch=' detached*'
    fi
    git_branch=" ($branch)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty=' *'
  else
    git_dirty=''
  fi
}

count_commit() {
   local branch
   local ahead
   local behind
   if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
	   if [[ "$branch" == "HEAD" ]]; then
		   branch="master"
	   fi
	   ahead="$(git rev-list origin/$branch..HEAD --count)"
	   [[ $ahead -gt 0 ]] && ahead="$txtgrn↑$ahead$txtrst" || ahead="↑$ahead"
	   behind="$(git rev-list HEAD..origin/$branch --count)"
	   [[ $behind -gt 0 ]] && behind="$txtred↓$behind$txtrst" || behind="↓$behind"
	   git_commits="$txtrst $ahead$behind$txtrst"
   else
	   ahead=""
           behind=""
	   git_commits=""
   fi
}
PROMPT_COMMAND="find_git_branch; count_commit; find_git_dirty; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
