ZSH_THEME_GIT_PROMPT_BRANCH_CAP=25           # Maximum number of characters from the branch name to show
ZSH_THEME_GIT_PROMPT_BRANCH_CAP_SUFFIX="..." # Text to display if the branch is clean

# modified version of git_prompt_info() in ./lib/git.zsh
# that includes the CAP'ed leanth of the branch ref

function voidy_git_prompt_info() {
  # If we are on a folder not tracked by git, get out.
  # Otherwise, check for hide-info at global and local repository level
  if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
     || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
    return 0
  fi

  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
  || return 0

  if (( ${+ZSH_THEME_GIT_PROMPT_BRANCH_CAP} )) && \
     [[ ${#ref} -gt ($ZSH_THEME_GIT_PROMPT_BRANCH_CAP + ${#ZSH_THEME_GIT_PROMPT_BRANCH_CAP_SUFFIX}) ]];
  then    
    ref="${ref:0:$ZSH_THEME_GIT_PROMPT_BRANCH_CAP}"
    ref+="${ZSH_THEME_GIT_PROMPT_BRANCH_CAP_SUFFIX}"
  fi

  # Use global ZSH_THEME_GIT_SHOW_UPSTREAM=1 for including upstream remote info
  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# aws-vault prompt
function awsvault_prompt_info() {
  [[ -n "$AWS_VAULT" ]] || return
  echo "${ZSH_THEME_AWSVAULT_PREFIX=<aws-vault:}${AWS_VAULT:gs/%/%%}${ZSH_THEME_AWSVAULT_SUFFIX=>} "
}

if [[ "$SHOW_AWSVAULT_PROMPT" != false && "$RPROMPT" != *'$(awsvault_prompt_info)'* ]]; then
  RPROMPT='$(awsvault_prompt_info)'"$RPROMPT"
fi

PROMPT="%(?:%{$fg_bold[green]%}λ :%{$fg_bold[red]%}λ )"
PROMPT+='%{$fg_bold[white]%}%n@%m %{$fg[cyan]%}%3~%{$reset_color%} $(voidy_git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
