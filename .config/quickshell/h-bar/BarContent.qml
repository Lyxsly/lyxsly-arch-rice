import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitHeight: 30

    RowLayout {
        id: leftContent
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
    }

    RowLayout {
        id: centerContent
        anchors.centerIn: parent
        spacing: 8

        ClockWidget {}
    }

    RowLayout {
        id: rightContent
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
    }
}
