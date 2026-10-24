# matugen-wisteria.nvim

[masisz/wisteria.nvim](https://github.com/masisz/wisteria.nvim) を改変した、Matugen連携用のローカルテーマです。
元の著作権表示とMITライセンス全文は [LICENSE](LICENSE) に保持しています。

主な変更は、Luaモジュール・カラースキーム名の変更、配色トークンの `color00` 形式への変更、Matugenによるパレット生成への対応です。

Neovimは `~/.config/nvim/local/matugen-wisteria.nvim` から読み込みます。
Matugenの設定・テンプレートは `~/.config/matugen/config.toml` と `~/.config/matugen/templates/matugen-wisteria.lua` にあります。

`lua/matugen_wisteria/lib/palette.lua` は現在の配色を初期値として同梱しています。Matugen実行時に上書きされるため、生成ルールはテンプレート側で変更してください。
