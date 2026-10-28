# Illogical Impulse integration

Source: https://github.com/end-4/dots-hyprland

Upstream commit: `2f2a376` (2026-10-11).
Rounded polygon submodule: `e31ec4cb4ebf6a46b267f5c42eabf6874916fa16`.
The copied shell and its Python requirements retain the upstream GPL-3.0 license.

Python is managed by pyenv (3.12.14). uv installs the pinned upstream
`requirements.txt` into `${XDG_STATE_HOME:-~/.local/state}/quickshell/.venv`.
uv Python downloads are disabled. No global Python selection is changed.

Build: `bash ~/dotfiles/scripts/setup_ii_python.sh`

Run: `bash ~/dotfiles/scripts/run_ii.sh`

Settings: `bash ~/dotfiles/scripts/run_ii.sh --settings`

Local integration:

- `matugen/ii.toml` extends the existing application color templates with shell
  colors, excluding the retired Eww and Rofi output templates. The original
  Matugen config and application configs are retained.
- `switchwall.sh` uses that explicit config and switches adw-gtk3 between light
  and dark alongside the shell. GTK3 settings and GTK3/GTK4 palettes are generated
  under `~/.config/gtk-{3,4}.0/`.
- Hyprland GUI edits go to `hypr/hyprland/shellOverrides/main.lua`, which is
  loaded after the user's main Hyprland config.
- Local upstream compatibility fixes: notification popups use the declared
  `notifications.monitor` option; workspace groups use their existing default
  padding instead of referencing a missing property.
- The notification settings page also uses `notifications.monitor`, matching
  the popup and config schema. An isolated load with monitor selection enabled
  passes without TypeErrors.
- Recording no longer passes the unsupported `wf-recorder -t` option. Audio
  recording selects the default sink's monitor instead of combining every
  source name. Missing/null recording paths use the existing default directory.
  Full-screen and audio-enabled region recordings were validated on 2026-10-26.
- The launcher and Hyprland integration select the KDE Qt platform theme, so
  shell icons and newly launched Qt applications use the installed themes.
- Session actions no longer send termination signals to individual application
  processes before logout, shutdown or reboot. Logout uses Hyprland's exit
  dispatcher. The main session menu disables hibernation unless logind reports
  it as available; the action itself has the same guard. Lock routing uses
  the helper described below. Power command generation was
  tested with intercepted commands, without executing power/session actions.

Lock integration now routes through `scripts/lock_ii.sh`: it calls the native
shell lock handler, with `hyprlock-fallback.conf` as a fallback when that handler
is unavailable. Ctrl+Super+L uses the same route. `hypridle.conf` handles logind
lock requests and locks before suspend, with `inhibit_sleep = 3`; it contains no
idle timers. Enable it with `systemctl --user enable --now hypridle.service`.
The user confirmed native lock and password unlock work. Suspend/resume testing
still requires the user.

`mpvpaper` 1.9 was built from the reviewed AUR PKGBUILD and installed. `mpv` and
`gnome-desktop-4` were installed from the repositories and recorded in the
desktop package list. Native Python thumbnail generation now passes. An
isolated video-wallpaper test confirmed the compositor surface, poster image
and generated restore script, without changing the active wallpaper. The
launcher runs the generated restore script at startup. Video process cleanup
is restricted to the current user's exact process name, and generated file
paths are shell-quoted.

With the user's approval, `lyxsly` was added to `input` and the ydotool user
service was enabled. Its override is linked from
`.config/systemd/user/ydotool.service.d/override.conf`; it uses the private
`%t/.ydotool_socket` socket with mode 0600. The shell launcher exports the same
socket path. A temporary daemon launched with refreshed groups passed uinput
access and socket tests without typing text. The existing user manager still
has its old groups, so its service is skipped by ExecCondition until a fresh
user session; a reboot reliably refreshes it. Keyboard character input must
still be checked after that restart.

Japanese OCR and AI/translation setup are out of scope at the user's request.

Keybindings: Ctrl+Super+L (lock), Super+Space (search), Super+Tab (overview), Super+Shift+V
(clipboard), Super+Escape (settings), Ctrl+Super+T (wallpapers), Ctrl+Super+R
(restart). Existing terminal, editor, monitor, input and workspace settings are
retained. Waybar and awww autostart commands are kept as comments.

To generate colors manually:

```sh
bash ~/dotfiles/scripts/run_ii.sh --wallpaper --mode dark --image /path/to/image
```

Qt application theming was enabled on 2026-10-28. Terminal escape-sequence
theming and automatic night temperature changes remain disabled in
`~/.config/illogical-impulse/config.json`. The existing Matugen templates still
generate the user's Kitty, Neovim, Starship, Yazi and Hyprland colors.

## Application themes and system monitor (2026-10-28)

Plasma System Monitor is installed and the existing task-manager command opens
its Processes page. GTK uses the installed adw-gtk3/adw-gtk3-dark themes plus
Matugen palettes; Qt6 uses the installed Darkly style, KDE platform integration,
breeze-plus icons and kde-material-you-colors palettes. The GTK4 template uses
`:disabled` instead of the unsupported `:insensitive` pseudo-class.

The KDE generator wrapper disables Konsole application and optional KWin
titlebar updates. In the pinned 1.10.1 generator, passing zero for both titlebar
opacity options skips that KWin-only path; it does not make Hyprland windows
transparent. No Python package or environment was added or modified.

`~/.config/kdeglobals` is generated at runtime, retaining Darkly as widgetStyle.
The KDE-generator config and Darkly defaults are also stored in this repository
under `.config/kde-material-you-colors/` and `.config/darklyrc`; copies were
applied to the live user config. GTK3 settings.ini is updated by switchwall.
Existing Qt applications may need restarting to inherit the platform theme.
Sandboxed applications may require their own theme integration; those were not
tested. Qt5 style compatibility was not tested.

Pre-change settings and gsettings values are backed up under
`~/.local/state/rice-migration/themes-20261028-113750/`.
Validated: System Monitor window title `Processes — System Monitor`, GTK3 and
GTK4 palette parsing without errors, Libadwaita dark mode, KDE palette application
without KWin errors, and Hyprland configerrors empty. The actual shell wallpaper
IPC path was exercised with the same current wallpaper. Light-mode appearance
and login persistence have not been visually tested.

Initial configuration backups and SHA-256 manifests are stored under
`~/.local/state/rice-migration/20261025-211900/`.

## Validation on this machine

- Arch Linux, Hyprland 0.56.2, Quickshell 0.3.2, Qt 6.12.
- pyenv Python 3.12.14 and 33 pinned Python packages installed successfully;
  `uv pip check` and the runtime module imports pass. The interactive shell
  still selects pyenv `system`, Python 3.14.8.
- The shell and settings window load in the running Wayland session. Search,
  overview/clipboard bindings, sidebars and wallpaper picker are connected.
- Wallpaper application through shell IPC runs the dedicated Matugen config.
  Existing application settings retain their structure; generated color values
  change with the wallpaper.
- The Hyprland GUI configuration backend writes valid Lua to the dedicated
  override file. The test setting was removed afterwards. Hyprland reports no
  configuration errors.
- Quickshell receives notifications after the previous swaync service stops.
  Waybar and awww were stopped without uninstalling their packages.
- All 81 files in the original backup manifest still exist. Kitty, Neovim,
  Starship and generated Hyprland color files differ only in colors/source
  image. Starship non-palette TOML settings are identical.
- The existing user `.codex/config.toml` changes were not edited.

Some upstream nonfatal QML warnings and missing optional generated
translation/wallpaper-category files remain. Short recordings, English OCR,
all eight settings-page loads and the isolated video backend have been tested.
Actual on-screen keyboard character input, suspend/resume and every GUI
interaction have not been exercised. Native password unlock was confirmed by
the user. No idle timeout policy was installed.

## Returning to the previous desktop

The original config files are in the backup directory above. Stop this shell
with `qs -c ii kill`, restore the backed-up `hyprland.lua` and the generated
application color files, then run `hyprctl reload config-only`. The restored
startup commands take effect at the next login; Waybar and awww can also be
started manually. swaync was already disabled before migration; it was only
stopped in the current session. The new files and isolated Python environment
can remain on disk while using the previous desktop.
