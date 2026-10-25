# lyxsly-rice

My Arch Linux / Hyprland dotfiles.

## Includes

- Hyprland
- Waybar
- Kitty
- Neovim
- Yazi
- Eww
- scripts
- Codex（設定・共通指示・ユーザースキル）

## Codexの復元

Codexをインストールした環境で、このリポジトリをcloneしてから実行します。clone先は任意です。

```sh
cd ~/dotfiles
bash scripts/setup_codex.sh
```

`~/.codex/config.toml`、`~/.codex/AGENTS.md`、`~/.codex/skills/`、`~/.agents/skills/` を、リポジトリ内の実体にリンクします。同じリンクがあれば何もしません。既存のファイルやディレクトリがある場合は、隣の `名前.backup.XXXXXX/original` に退避してからリンクします。別の場所にcloneし直した場合も、同じコマンドでリンクを張り直せます。独自の `CODEX_HOME` を使う環境は、このスクリプトの対象外です。

ユーザースキルは実体を保存しています。今後 `~/.codex/skills/` または `~/.agents/skills/` に追加・編集した内容も、リンク経由でこのリポジトリに反映されます。組み込みの `.system/`、Pythonキャッシュ、認証情報、会話履歴はGit管理に含めません。

MCPを追加するときは `~/.codex/config.toml` の設定と、必要な外部コマンドの導入手順を管理します。現時点ではMCPサーバーの登録はありません。トークンやパスワードは設定に直接書かず、環境変数などで渡してください。Codexへのログイン、MCPの認証、スキルが必要とする実行環境・外部依存は移行先で別途用意します。

現在の設定には `/home/lyxsly` 配下のプロジェクト信頼設定を含みます。別のPCでは、必要に応じてそのPCのプロジェクトを信頼してください。

スキルや設定を追加したら、差分を確認して保存します。

```sh
cd ~/dotfiles
git status --short
git diff -- .codex .agents
git add -- .codex/config.toml .codex/AGENTS.md .codex/skills .agents/skills
git diff --cached
git commit -m "Update Codex configuration and skills"
git push origin main
```

## パッケージの移行

明示的にインストールした139件を用途ごとのファイルで管理します。

```text
packages/
  common.tsv              # 標準
  desktop.tsv             # 標準
  dev.tsv                 # 任意
  apps.tsv                # 任意
  profiles/thinkbook.tsv  # 機種別
  profiles/latitude.tsv   # 機種別
  review.tsv              # 保留
  remove.tsv              # 移行先では導入しない
```

各行は `入手元<TAB>パッケージ名` です。`repo` は pacman、`foreign` は yay に渡します。外部パッケージがすべて AUR 由来とは限らないため、移行時に入手できないものは個別に確認してください。

`common` と `desktop` は標準でインストールします。`dev`、`apps`、`thinkbook`、`latitude` は必要な場合だけ選択します。`review` と `remove` は記録用で、スクリプトはインストールも削除もしません。`awww` は `desktop`、移行予定の `eww-git` と `hyprpaper` は `remove` に分類しています。現在の設定はまだ Eww や hyprpaper を参照しているので、設定の移行を終えてから新しいPCに適用してください。

新しいPCでは、一般ユーザーで yay を先に導入します。yay の[公式手順](https://github.com/Jguer/yay#installation)に従い、PKGBUILD を確認してからビルドしてください。

```sh
sudo pacman -Syu --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

その後、dotfiles リポジトリで次のように実行します。`--list` はインストールせず、対象を表示します。

```sh
cd ~/dotfiles
bash scripts/install_packages.sh --list
bash scripts/install_packages.sh
bash scripts/install_packages.sh --with dev --with apps --profile thinkbook
```

`--profile latitude` を指定すると Latitude 用の候補を選びます。機種別パッケージと `common` のブートローダーは、新しいPCの構成に合うか確認してください。スクリプトは pacman のシステム更新後に、yay で外部パッケージを導入します。

パッケージを追加したら、用途に合う TSV に1行追加します。迷うものは `review.tsv` に記録し、移行先に導入しないものは `remove.tsv` に移します。`bash scripts/install_packages.sh --check` は、このPCで明示的にインストールされているのに、どの TSV にも載っていないパッケージを表示します。インストールや一覧の変更は行いません。実行前には `--list` で対象を確認してください。
