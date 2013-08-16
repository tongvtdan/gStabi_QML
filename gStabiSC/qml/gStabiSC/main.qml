import QtQuick 2.1

import "AppHeader"
import "Comm"
import "GDashboard"

Rectangle {
    id: rectangle1
//    width: 1200
//    height: 760
    property int header_height: 30
    color: "#242424"
    BorderImage {
        id: gstabiBackgroundImage
//        width: 1024
//        height: 700
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        source: "qrc:/images/qml/gStabiSC/images/ui_02/main_window.png"
    }
    AppHeader{
        id: header
        anchors.top: gstabiBackgroundImage.top
        anchors.left: gstabiBackgroundImage.left
        implicitHeight: gstabiBackgroundImage.height
        implicitWidth: gstabiBackgroundImage.width
    }
    CommSetting{
        id: comportSettingPanel
        anchors.top: header.bottom
        anchors.left: gstabiBackgroundImage.left
        implicitHeight: 250
        implicitWidth: 300
    }
    GDashBoard{
//        x: 211
//        y: 80
        width: 700
        height: 250
        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 80
    }

}
