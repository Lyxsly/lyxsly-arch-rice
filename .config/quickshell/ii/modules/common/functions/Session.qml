pragma Singleton
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common

Singleton {
    id: root

    property bool hibernateAvailable: false

    function refreshCapabilities() {
        hibernateCapabilityProc.running = true;
    }

    Process {
        id: hibernateCapabilityProc
        running: true
        command: ["busctl", "--system", "call", "org.freedesktop.login1",
            "/org/freedesktop/login1", "org.freedesktop.login1.Manager", "CanHibernate"]
        stdout: StdioCollector {
            onStreamFinished: {
                const response = text.trim();
                root.hibernateAvailable = response === 's "yes"' || response === 's "challenge"';
            }
        }
    }

    function changePassword() {
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.changePassword}`]);
    }

    function lock() {
        Quickshell.execDetached(["bash", "-c", "exec bash \"$HOME/dotfiles/scripts/lock_ii.sh\""]);
    }

    function suspend() {
        Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]);
    }

    function logout() {
        Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.exit()"]);
    }

    function launchTaskManager() {
        Quickshell.execDetached(["bash", "-c", `${Config.options.apps.taskManager}`]);
    }

    function hibernate() {
        if (!root.hibernateAvailable) return;
        Quickshell.execDetached(["bash", "-c", `systemctl hibernate || loginctl hibernate`]);
    }

    function poweroff() {
        Quickshell.execDetached(["bash", "-c", `systemctl poweroff || loginctl poweroff`]);
    }

    function reboot() {
        Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]);
    }

    function rebootToFirmware() {
        Quickshell.execDetached(["bash", "-c", `systemctl reboot --firmware-setup || loginctl reboot --firmware-setup`]);
    }
}
