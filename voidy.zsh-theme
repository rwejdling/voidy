ZSH_THEME_GIT_PROMPT_BRANCH_CAP=25           # Maximum number of characters from the branch name to show
ZSH_THEME_GIT_PROMPT_BRANCH_CAP_SUFFIX="..." # Text to display if the branch is clean

# aws-vault prompt
function awsvault_prompt_info() {
  [[ -n "$AWS_VAULT" ]] || return
  echo "${ZSH_THEME_AWSVAULT_PREFIX=<aws-vault:}${AWS_VAULT:gs/%/%%}${ZSH_THEME_AWSVAULT_SUFFIX=>} "
}

if [[ "$SHOW_AWSVAULT_PROMPT" != false && "$RPROMPT" != *'$(awsvault_prompt_info)'* ]]; then
  RPROMPT='$(awsvault_prompt_info)'"$RPROMPT"
fi

PROMPT="%(?:%{$fg_bold[green]%}λ :%{$fg_bold[red]%}λ )"
PROMPT+='%{$fg_bold[white]%}%n@%m %{$fg[cyan]%}%3~%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
