# lyxsly-arch-rice

Arch Linux上に、Hyprland・Quickshell（Illogical Impulse）・Kitty・Zshなどの設定を復元するためのdotfilesです。現在のUIはQuickshellで動きます。Waybar・Swayncなどの設定も残しています。

復元の目標は、主要な設定とUIを使える状態に戻すことです。GUIで調整した細かな配置、個人データ、履歴、ログイン情報は復元対象に含めません。

初回は「OSを消す前に」から「再起動後の確認」まで順に進めてください。その後の節は、設定を追加するときや復元が止まったときに参照します。

## OSを消す前に、復元元を別の場所へ保存する

このリポジトリが消去するディスクだけにある場合、OSと一緒に失われます。変更を確認し、最新版をGitHubまたは外部ストレージに保存してください。Git管理しているファイルだけがcloneで戻ります。

```sh
cd ~/dotfiles
git status --short
git branch --show-current
git log -1 --oneline
```

この手順を書いた時点の作業ブランチは `end-4-quickshell` です。GitHubの同じブランチに、復元に使うコミットと今回の変更が保存されていることを消去前に確認してください。mainへ統合した場合は、以下のcloneコマンドのブランチも変更します。

壁紙を同じものにしたい場合は、画像・動画も別途保存します。リポジトリには初期壁紙を含みますが、ホームディレクトリ内の個別の壁紙は含みません。

## Arch Linuxを導入し、一般ユーザーでログインする

復元スクリプトは、起動できるArch Linuxと、sudoを使える一般ユーザーを前提にしています。ディスクの初期化、OSのインストール、ブートローダーの設定は行いません。

OS導入時に、次の項目を済ませてください。

- カーネル、ファイルシステムに必要なツール、ブートローダー、CPUに合うマイクロコードの導入
- 一般ユーザーとsudo権限の設定
- インターネット接続と時刻の設定

GPUドライバーや音声用ファームウェアは機種によって異なります。パッケージの機種別一覧を確認してください。`review.tsv` にある `sof-firmware` なども、機種によっては追加が必要です。

一般ユーザーで次を実行します。HTTPSでcloneするため、以前のSSH鍵は不要です。

```sh
sudo pacman -Syu --needed git base-devel
git clone --branch end-4-quickshell https://github.com/Lyxsly/lyxsly-arch-rice.git ~/dotfiles
cd ~/dotfiles
```

**clone先は `~/dotfiles` にしてください。** Hyprlandの起動コマンドがこの場所を参照します。復元スクリプトもこの配置を確認します。標準以外の `XDG_CONFIG_HOME`・`XDG_STATE_HOME`・`XDG_CACHE_HOME` は、この手順の対象外です。

## yayを準備し、導入対象を確認する

AURなどの外部パッケージを扱うため、yayを先に導入します。一般ユーザーでビルドし、実行前に取得したPKGBUILDを確認してください。

```sh
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
less PKGBUILD
makepkg -si
cd ~/dotfiles
```

まず、復元スクリプトで対象を表示します。この操作では設定変更やインストールを行いません。

```sh
bash scripts/restore.sh --list
```

標準対象は `common.tsv` と `desktop.tsv` です。Quickshell本体、QMLモジュール、UIが呼び出すコマンド、フォント、UI専用Python環境の構築ツールを含みます。

開発環境、アプリ、機種別パッケージを追加する場合は、次のように指定します。

```sh
bash scripts/restore.sh --list --with dev --with apps --profile thinkbook
```

`dev` はNeovimやNode.js・Rubyなどの開発ツール、`apps` はブラウザーなどのアプリです。標準構成ではNeovimの設定だけが配置され、本体は `--with dev` で導入します。現在のZshは、任意の開発ツールを省いても起動できるようにしています。

`thinkbook` はAMD向け、`latitude` はIntel向けの候補です。別の機種へ移す場合は、中身が構成に合うか確認してください。Latitudeの一覧にはCPUマイクロコードを含まないため、OS導入時に用意します。

## 復元を適用し、再起動する

表示した内容でよければ、同じオプションに `--apply` を指定します。

```sh
bash scripts/restore.sh --apply --with dev --with apps --profile thinkbook
```

最小構成なら `bash scripts/restore.sh --apply` だけで進められます。スクリプト全体をsudoで実行しないでください。必要な操作だけがsudoを使います。

適用時には、次の順で処理します。

1. pacmanでシステムを更新して標準パッケージを導入し、yayで外部パッケージを導入する。
2. 設定ファイルと `.zshrc` を、リポジトリ内のファイルへリンクする。
3. pyenvでPython 3.12.14を構築し、固定したPython依存をUI専用環境へ導入する。
4. QtのウィジェットスタイルをDarklyに設定する。
5. NetworkManager・Bluetoothと、ユーザー用のhypridle・ydotoolを有効化する。
6. 実行ユーザーを `input` グループへ追加する。

`input` グループは、オンスクリーンキーボードがydotool経由で入力するために使います。サービスはその場では起動せず、次回起動時に反映します。

既存の設定がある場合、リンク先と同じ場所に `名前.backup.XXXXXX/original` として退避します。同じリンクは作り直しません。GUI設定の `~/.config/illogical-impulse/config.json` がなければ、導入するフォントに合わせた初期設定を作ります。既存のGUI設定は保持します。

ログインシェルもZshにする場合は、次を実行してから再起動してください。

```sh
chsh -s /usr/bin/zsh
systemctl reboot
```

途中で失敗した場合は、エラーを解消して同じ復元コマンドを再実行できます。全工程を取り消す機能はありません。Python環境に別のバージョンが存在するときは、上書きせず検査で停止します。

## 再起動後にHyprlandと配色を確認する

TTYからログインする場合は、次でHyprlandを起動します。ログイン画面を使う場合は、別途設定したディスプレイマネージャーからHyprlandを選びます。復元スクリプトはSDDMなどを導入・有効化しません。

```sh
Hyprland
```

モニター設定は `.config/hypr/hyprland.lua` の `MONITORS` にあります。現在は `eDP-1` と `HDMI-A-1`、内蔵画面の倍率1.25を指定しています。画面構成が違う場合は `hyprctl monitors` で出力名を調べて調整してください。

QuickshellはHyprlandの起動時に立ち上がります。初期壁紙からの配色生成も初回起動時に行う構成です。手動で配色を適用し直す場合は、Hyprland内のターミナルから実行します。

```sh
bash ~/dotfiles/scripts/run_ii.sh --wallpaper --mode dark \
  --image "$HOME/.config/quickshell/ii/assets/images/default_wallpaper.png"
```

この操作でGTK・Qtと、Kitty・Neovim・Starship・Yazi・Hyprlandの配色を生成します。起動済みのQtアプリは、再起動が必要な場合があります。

次のコマンドと操作で確認します。

```sh
hyprctl configerrors
systemctl --user status hypridle.service ydotool.service
systemctl status NetworkManager.service bluetooth.service
id -nG
```

| 確認する操作 | キー |
| --- | --- |
| ターミナル | Super + Return |
| アプリ検索 | Super + Space |
| ワークスペース一覧 | Super + Tab |
| クリップボード | Super + Shift + V |
| UI設定 | Super + Escape |
| 壁紙選択 | Ctrl + Super + T |
| ロック | Ctrl + Super + L |
| UI再起動 | Ctrl + Super + R |

`hyprctl configerrors` にエラーがないこと、`input` グループが反映されていることに加え、日本語入力、音声、通知、ロック解除を実際に確認してください。必要に応じて画面収録、オンスクリーンキーボード、サスペンド復帰も確認します。

## 個別の工程だけをやり直す

| 目的 | コマンド |
| --- | --- |
| 設定の配置予定を表示 | `bash scripts/setup_desktop.sh --dry-run` |
| 設定を配置 | `bash scripts/setup_desktop.sh` |
| Python環境を作成・同期 | `bash scripts/setup_ii_python.sh` |
| パッケージ一覧を表示 | `bash scripts/install_packages.sh --list` |
| パッケージだけ導入 | `bash scripts/install_packages.sh --with dev --with apps` |
| UIを再起動 | `bash scripts/run_ii.sh --restart` |

`setup_desktop.sh --home /絶対パス` で別のホームへ配置することもできます。これは配置の検証用で、デスクトップ全体の動作先を変更する機能ではありません。

以前の `hypr_setup.sh` と `zsh_setup.sh` は復元に使いません。前者は旧構成用、後者はPowerlevel10k用の設定であり、現在のLua設定・Starship構成と合いません。

Mouselessは設定だけを配置します。パッチ版の導入は、Goのビルド環境を用意して `bash packages/mouseless/install.sh` で行います。通常のUI起動には不要で、起動や権限の設定は別途必要です。

## Codexは必要に応じて復元する

Codex本体を導入してから、次を実行します。

```sh
bash scripts/setup_codex.sh
```

設定、共通指示、ユーザースキルをリポジトリ内の実体へリンクします。既存のファイルは退避します。独自の `CODEX_HOME` は対象外です。

ログイン情報、会話履歴、組み込みスキル、プラグインのキャッシュは保存していません。認証と外部依存の準備は移行先で行います。設定内のプロジェクト信頼設定は `/home/lyxsly` を含むため、別のユーザー名で復元した場合は見直してください。

## パッケージを追加したら一覧も更新する

一覧は `入手元<TAB>パッケージ名` 形式です。`repo` はpacman、`foreign` はyayへ渡します。`foreign` は現在の環境で公式リポジトリ外だったものを示し、移行時の入手可否を保証しません。

| ファイル | 用途 |
| --- | --- |
| `packages/common.tsv` | 共通ツール |
| `packages/desktop.tsv` | 標準のデスクトップとUI依存 |
| `packages/dev.tsv` | 任意の開発環境 |
| `packages/apps.tsv` | 任意のアプリ |
| `packages/profiles/*.tsv` | 機種別の候補 |
| `packages/review.tsv` | 導入を保留しているもの |
| `packages/remove.tsv` | 移行先に導入しないもの |

`review` と `remove` は記録用で、インストールも削除もしません。現在の環境で明示的に導入したパッケージの記録漏れは、次で調べられます。

```sh
bash scripts/install_packages.sh --check
```

未登録の表示だけで、すべてを標準対象へ追加する必要はありません。OS用、任意機能用、不要なものを判断して分類してください。

## 検証範囲と、復元が止まったときの調べ方

この手順の整備時に、シェルの構文、パッケージ一覧の重複、予定表示、設定配置の退避・再実行を検証しました。OSを初期化した環境での通し実行は未検証です。Archのパッケージは更新されるため、将来のバージョンで同じ動作になることも未確認です。

UI本体の取り込み元と、このPCでの動作確認記録は [rice/illogical-impulse/UPSTREAM.md](rice/illogical-impulse/UPSTREAM.md) にあります。HyprlandのLua設定を含むため、古いバージョンへの復元は想定していません。

UIが立ち上がらない場合は、ターミナルから `bash scripts/run_ii.sh` を実行してエラーを確認します。サービスの失敗は `journalctl --user -u ydotool.service -b` などで調べます。相談するときは、停止したコマンド、エラー、`pacman -Q hyprland quickshell` の結果を添えてください。

この文書の「リンク」は設定の実体をリポジトリへ向けるシンボリックリンク、「Python環境」はUI専用の仮想環境、「有効化」は次回起動時にサービスを開始する設定を指します。

最終更新: 2026-10-28
