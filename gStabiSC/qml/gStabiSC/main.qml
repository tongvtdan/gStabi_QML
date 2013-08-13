import QtQuick 2.0

import "AppHeader"
import "Comm"

Rectangle {
    width: 1024
    height: 700
    property int header_height: 30
    BorderImage {
        id: gstabiBackgroundImage
        anchors.fill: parent
        source: "images/background.png"
    }
    AppHeader{
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        implicitHeight: header_height
        implicitWidth: parent.width
    }
    CommSetting{
        id: comportSettingPanel
        anchors.top: header.bottom
        implicitHeight: 250
        implicitWidth: 300
    }
}
