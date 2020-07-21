#! /bin/bash

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cat > ~/.oh-my-zsh/themes/pers_robbyrussell.zsh-theme << EOF
PROMPT="%{\$fg_bold[yellow]%}%m "
PROMPT+="%(?:%{\$fg_bold[green]%}➜ :%{\$fg_bold[red]%}➜ )"
PROMPT+=' %{\$fg[cyan]%}%c%{\$reset_color%} \$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{\$fg_bold[blue]%}git:(%{\$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{\$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{\$fg[blue]%}) %{\$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{\$fg[blue]%})"
EOF
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="pers_robbyrussell"/g' ~/.zshrc

rm -rf ~/.vimrc
echo "set tabstop=4" >> ~/.vimrc
echo "set shiftwidth=4" >> ~/.vimrc
echo "set autoindent" >> ~/.vimrc
echo "syntax on" >> ~/.vimrc

echo "alias rs='rails s -b=0.0.0.0'" >> ~/.zshrc
source ~/.zshrc
