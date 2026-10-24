# Color references

All initial values are literal `#rrggbb` values so color-preview plugins can display them directly.
The token names intentionally carry no hue, brightness, or semantic meaning.

| Token | Initial value | Original wisteria name | References |
|---|---|---|---|
| `color00` | `#eeede6` | `white` | Editor foregrounds; Neo-tree files; Snacks files; Markdown text and H5/H6; Tree-sitter variables, markup, TODO/error foregrounds; lualine normal C |
| `color01` | `#bababa` | `gray` | `Comment`; GitSigns previews; inline Markdown code background; Tree-sitter brackets |
| `color02` | `#c6c6c6` | `light_gray` | `LineNr` |
| `color03` | `#22272a` | `hanabi_night` | Non-transparent background; search foreground; GitSigns blame; Markdown code background; lualine base foreground/background |
| `color04` | `#a893d1` | `flower_fuji` | Statements, keywords and types; untracked files; Markdown H2/success; Tree-sitter types, classes, keywords and links; lualine visual mode |
| `color05` | `#9bbac9` | `sky` | Operators and diagnostic hints; Markdown bullets/hints; Tree-sitter fields and properties |
| `color06` | `#6565cc` | `watarase_blue` | Functions; Neo-tree directories/title; Markdown table head; Tree-sitter methods/functions/TODO background; lualine normal mode |
| `color07` | `#7fc18d` | `icho_green` | Strings; GitSigns additions; staged files; Markdown H4; checked lists; lualine insert/terminal modes |
| `color08` | `#ba5e5e` | `orihime_red` | Special, MatchParen; GitSigns deletion; Markdown H1; built-in variables; lualine replace mode |
| `color09` | `#d2c7a2` | `omugi_gold` | Numbers/constants; GitSigns changes; Markdown H3; constructors/parameters; lualine command mode |
| `color10` | `#e08d51` | `warning_orange` | Diagnostics and Markdown/Tree-sitter warnings |
| `color11` | `#e05151` | `error_red` | Diagnostics and Markdown/Tree-sitter errors |
| `color12` | `#65abcc` | `info_blue` | Diagnostics, Markdown info and Tree-sitter note background |
| `color13` | `#7239ac` | `flower_fuji_dark` | `Visual` background |
| `color14` | `#e0d1ef` | `flower_fuji_light` | Currently unused; retained for palette compatibility |
| `color15` | `#477b94` | `sky_dark` | Currently unused; retained for palette compatibility |
| `color16` | `#c4d9e2` | `sky_light` | Currently unused; retained for palette compatibility |
| `color17` | `#476594` | `watarase_blue_dark` | `CursorLine` background |
| `color18` | `#c4d0e2` | `watarase_blue_light` | `Search` background |
| `color19` | `#479457` | `icho_green_dark` | Currently unused; retained for palette compatibility |
| `color20` | `#c4e2cb` | `icho_green_light` | Currently unused; retained for palette compatibility |
| `color21` | `#7c3535` | `orihime_red_dark` | Currently unused; retained for palette compatibility |
| `color22` | `#d19393` | `orihime_red_light` | Currently unused; retained for palette compatibility |
| `color23` | `#948247` | `omugi_gold_dark` | Currently unused; retained for palette compatibility |
| `color24` | `#ebe6d5` | `omugi_gold_light` | `IncSearch` background |

`none = "NONE"` is not a color token. It is used for transparent editor, GitSigns, and lualine backgrounds when `transparent = true`.

## Source files

- `lua/matugen_wisteria/colors/editor.lua`: core editor, diagnostics, search, cursor line and visual selection.
- `lua/matugen_wisteria/colors/treesitter.lua`: Tree-sitter captures, comment annotations and Markdown captures.
- `lua/matugen_wisteria/colors/neotree.lua`: Neo-tree UI and Git states.
- `lua/matugen_wisteria/colors/snacks.lua`: Snacks dashboard and picker.
- `lua/matugen_wisteria/colors/markdown.lua`: render-markdown highlights.
- `lua/matugen_wisteria/colors/gitsigns.lua`: GitSigns status, preview and inline highlights.
- `lua/matugen_wisteria/colors/lualine.lua`: lualine modes and sections.
