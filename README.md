# lyxsly-arch-rice

Arch Linux / Hyprland向けのdotfiles。Quickshell（Illogical Impulse）を使ったデスクトップに、壁紙に合わせたGTK・Qt・ターミナルの配色を組み合わせています。

- Hyprland / Quickshell / Matugen
- Kitty / Zsh / Starship
- Neovim / Yazi
- Fcitx5 / Mozc

## 必要な環境

- インストール済みのArch Linux
- sudoを使える一般ユーザーとインターネット接続
- 機種に合うGPUドライバー・ファームウェア

OS・カーネル・ブートローダーの導入は事前に済ませてください。設定はHyprlandのLua形式を使います。clone先は `~/dotfiles`、XDGディレクトリは標準の配置を前提としています。

## インストール

一般ユーザーで実行します。

```sh
sudo pacman -Syu --needed git base-devel
git clone --branch end-4-quickshell https://github.com/Lyxsly/lyxsly-arch-rice.git ~/dotfiles
cd ~/dotfiles
```

yayがなければ、先に導入します。ビルド前にPKGBUILDを確認してください。

```sh
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
less PKGBUILD
makepkg -si
cd ~/dotfiles
```

導入対象を確認してから適用します。

```sh
bash scripts/restore.sh --list
bash scripts/restore.sh --apply
```

スクリプトはパッケージ導入、設定のリンク配置、UI専用Python環境の構築、サービスの有効化を行います。既存設定は `名前.backup.XXXXXX/original` に退避します。ydotoolによる入力のため、ユーザーを `input` グループへ追加します。

開発ツールやアプリを含める場合は、次のオプションを指定します。

```sh
bash scripts/restore.sh --list --with dev --with apps --profile thinkbook
bash scripts/restore.sh --apply --with dev --with apps --profile thinkbook
```

| オプション | 内容 |
| --- | --- |
| `--with dev` | Neovim、Node.js・Ruby関連などの開発ツール |
| `--with apps` | ブラウザーなどのアプリ |
| `--profile thinkbook` | AMD向けの機種別パッケージ |
| `--profile latitude` | Intel向けの機種別パッケージ |

機種別一覧は `packages/profiles/` にあります。使うPCの構成に合わせて選んでください。標準では `common.tsv` と `desktop.tsv` を導入します。`review.tsv` と `remove.tsv` は導入対象外です。

Zshをログインシェルにする場合は設定し、再起動します。

```sh
chsh -s /usr/bin/zsh
systemctl reboot
```

## 起動と設定

TTYから `Hyprland` を実行するか、ログイン画面でHyprlandを選びます。ディスプレイマネージャーは別途用意してください。QuickshellはHyprlandと一緒に起動します。

モニター名・配置・倍率は [.config/hypr/hyprland.lua](.config/hypr/hyprland.lua) の `MONITORS` を調整してください。現在は `eDP-1` と `HDMI-A-1` を指定しています。

壁紙はUIから選択できます。初期壁紙で配色を適用し直す場合は、Hyprland内で次を実行します。

```sh
bash ~/dotfiles/scripts/run_ii.sh --wallpaper --mode dark \
  --image "$HOME/.config/quickshell/ii/assets/images/default_wallpaper.png"
```

| 操作 | キー |
| --- | --- |
| ターミナル | Super + Return |
| アプリ検索 | Super + Space |
| ワークスペース一覧 | Super + Tab |
| クリップボード | Super + Shift + V |
| UI設定 | Super + Escape |
| 壁紙選択 | Ctrl + Super + T |
| ロック | Ctrl + Super + L |
| UI再起動 | Ctrl + Super + R |

## 個別セットアップ

```sh
# 設定のリンク配置
bash scripts/setup_desktop.sh

# UI専用Python環境の作成・同期
bash scripts/setup_ii_python.sh

# Codexの設定・ユーザースキルを配置（本体の導入とログインは別途）
bash scripts/setup_codex.sh
```

`hypr_setup.sh` と `zsh_setup.sh` は旧構成用です。現在のセットアップには使いません。

## トラブルシューティング

```sh
# Hyprlandの設定エラー
hyprctl configerrors

# UIをターミナルから起動してエラーを確認
bash scripts/run_ii.sh

# ユーザーサービスの状態
systemctl --user status hypridle.service ydotool.service
```

新規OSでのインストール全工程は未検証です。UIの取り込み元と動作確認記録は [UPSTREAM.md](rice/illogical-impulse/UPSTREAM.md) を参照してください。
