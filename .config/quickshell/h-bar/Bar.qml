// Bar.qml
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    id: bar
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: barRoot
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            exclusiveZone: 30
            color: "transparent"

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell:bar"

            BarContent {
                id: barContent
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }
}
