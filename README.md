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
