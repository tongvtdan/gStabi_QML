import QtQuick 2.1

import "AppHeader"
import "Comm"
import "GDashboard"

Rectangle {
    id: rectangle1
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
    GDashBoard{
        x: 211
        y: 80
        width: 600
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 80


    }
}
