-- Illogical Impulse integration. The user's main config remains authoritative.
hl.env("qsConfig", "ii")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", os.getenv("HOME") .. "/.local/state/quickshell/.venv")

hl.bind("CTRL + SUPER + L", hl.dsp.exec_cmd("bash $HOME/dotfiles/scripts/lock_ii.sh"),
    { description = "Session: Lock" })

hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"), { description = "Terminal" })
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("bash $HOME/dotfiles/scripts/run_ii.sh --settings"),
    { description = "Shell: Settings" })
hl.bind("SUPER + A", hl.dsp.global("quickshell:sidebarLeftToggle"), { description = "Shell: Left sidebar" })
hl.bind("SUPER + N", hl.dsp.global("quickshell:sidebarRightToggle"), { description = "Shell: Right sidebar" })
hl.bind("SUPER + Period", hl.dsp.global("quickshell:overviewEmojiToggle"), { description = "Shell: Emoji" })
hl.bind("SUPER + Slash", hl.dsp.global("quickshell:cheatsheetToggle"), { description = "Shell: Keybinds" })
hl.bind("CTRL + SUPER + T", hl.dsp.global("quickshell:wallpaperSelectorToggle"),
    { description = "Shell: Wallpaper picker" })
hl.bind("CTRL + SUPER + SHIFT + D", hl.dsp.global("quickshell:toggleLightDark"),
    { description = "Shell: Light/dark mode" })
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("bash $HOME/dotfiles/scripts/run_ii.sh --restart"),
    { description = "Shell: Restart" })
hl.bind("SUPER + SHIFT + S", hl.dsp.global("quickshell:regionScreenshot"),
    { description = "Utilities: Screenshot" })

-- The GUI writes only this dedicated override file.
require("hyprland.shellOverrides.main")
