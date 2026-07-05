# --- コマンド履歴の設定 ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt share_history # 複数のターミナル(ペイン)間で履歴をリアルタイム共有
setopt correct

autoload -U compinit
compinit

bindkey -v

setopt auto_cd

zmodload zsh/complist
zstyle ':completion:*' menu select

alias ls='ls --color=auto'
alias ll='ls -la'
alias v='nvim'
alias g='git'
alias update='sudo pacman -Syu'
# --- プラグインの読み込み (Arch Linuxのパス) ---
# 入力途中に過去の履歴を灰色でサジェスト (右矢印で決定)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# コマンドの正誤を色分け (※競合を防ぐため、必ず最後に読み込む)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#Starshipの設定ファイルパス
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# --- Starshipの起動 ---
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
