// Bar.qml
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: bar
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barRoot
            required property var modelData
            screen: modelData

            implicitHeight: 30
            // exclusiveZone: 20
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "quickshell:bar"
            BarContent {
                id: barContent
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }
            ClockWidget {
                anchors.centerIn: parent
            }
        }
    }
}
