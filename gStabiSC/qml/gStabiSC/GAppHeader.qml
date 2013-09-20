import QtQuick 2.0
import "Components"

Item {
    id: header
    width: 1024
    height: 25

    GTextStyled{
        id: applicationName
        color: "#00ffff"
        anchors.left: header.left
        anchors.leftMargin: 10
        anchors.verticalCenterOffset: 0
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent.Center
        text: _configuration.application_name() + " " + _configuration.application_version()
    }
}
