# Setup ZSH
```sh
#!/usr/bin/env bash

set -e

# ==========================
# Versions
# ==========================

run_task() {
    local title="$1"
    shift

    printf "\n####### %s #######\n\n" "$title"
    bash -c "$1"
    printf "\n"
}



run_task "INSTALLING ZSH" '
sudo apt install zsh -y

zsh --version

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
'

run_task "DOWNLOADING PLUGINS" '
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/t413/zsh-background-notify.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-background-notify
'

printf "#############################################\n"
printf "#         SETUP COMPLETED SUCCESSFULLY      #\n"
printf "#############################################\n\n"


```
Download: https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo/L/Regular/MesloLGLNerdFont-Regular.ttf
Click and Open with Fonts and install

# Set zsh theme to
```sh
ZSH_THEME="powerlevel10k/powerlevel10k"
```

# Add this before plugin
```sh
bgnotify_threshold=60


notify_formatted() {
    local exit_status="$1"
    local command="$2"
    local elapsed="$3"

    # Ignore common interactive commands
    case "${command%% *}" in
        vim|nvim|vi|nano|cat|bat|batcat|less|more|man|watch|top|htop|btop)
            return
            ;;
    esac

    if (( exit_status == 0 )); then
        title="Command Finished"
    else
        title="Command Failed"
    fi

    bgnotify "$title (${elapsed}s)" "$command"
}

# Inside plugins in .zshrc add these
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    bgnotify
)
```

# Run
echo 'source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-background-notify/bgnotify.plugin.zsh'
echo 'source ~/.zshrc'