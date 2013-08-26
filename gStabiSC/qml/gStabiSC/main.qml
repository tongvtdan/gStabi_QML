import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

import "AppHeader"
import "Comm"
import "GDashboard"
//import "Dashboard"

Rectangle {
    id: mainWindow
    property int header_height: 30
    property string main_log_msg: ""
    color: "#242424"
    BorderImage {
        id: gstabiBackgroundImage
        width: 1024
        height: 700
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_background.png"
    }
    AppHeader{
        id: header
        anchors.top: gstabiBackgroundImage.top
        anchors.topMargin: 20
        anchors.left: gstabiBackgroundImage.left
        anchors.leftMargin: 30
        implicitHeight: gstabiBackgroundImage.height
        implicitWidth: gstabiBackgroundImage.width
    }


    GDashBoard{
        id: gDashboard
        anchors.horizontalCenterOffset: 15
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: gstabiBackgroundImage.top
        anchors.topMargin: 60
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }


    }
    AnimatedImage{
        id: waitingForConnection
        width: 30
        height: 140
        anchors.left: gstabiBackgroundImage.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/images/qml/gStabiSC/images/animation.gif"
        paused: true

    }
    CommSetting{
        id: comportSettingPanel
        x: 50
        y: mainWindow.height - comportSettingPanel.height - 60
        state: "show"
        height: 200 ; width: 300
        dragMaxX: gstabiBackgroundImage.width - comportSettingPanel.width
        dragMaxY: gstabiBackgroundImage.height - comportSettingPanel.height
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
    }
    Console{
        id: textConsole
        x: gstabiBackgroundImage.x + gstabiBackgroundImage.width - textConsole.width - 10
        y: 400
        opacity: 1
        state: "show"
        height: 200; width:  300
        dragMaxX: gstabiBackgroundImage.width - textConsole.width
        dragMaxY: gstabiBackgroundImage.height - textConsole.height
        msg_history: main_log_msg
    }

    Button{
        id: openSerialSettingButton
        text: "Port"
        anchors.bottom: gstabiBackgroundImage.bottom
        anchors.bottomMargin: 10
        anchors.left: gstabiBackgroundImage.left
        anchors.leftMargin: 50


        style: ButtonStyle{
            background: BorderImage {
                source: control.pressed ? "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_pressed_button.png" : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_released_button.png"
                border.left: 4 ; border.right: 4 ; border.top: 4 ; border.bottom: 4
            }
            label: Text{
                Row {
                    id: row
                    anchors.centerIn: parent
                    spacing: 2
                    Image {
                        source: control.iconSource
                        anchors.verticalCenter: parent.verticalCenter
                        scale: 0.8
                    }
                    Text {
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                        text: control.text
                        color: "white"
                    }
                }
            }
        }

        onClicked: comportSettingPanel.visible == true ? comportSettingPanel.visible = false : comportSettingPanel.visible = true
    }// comport Open/Close
    onMain_log_msgChanged: {
        if(main_log_msg.length >=10000){
            main_log_msg = "Log data cleared "
        }
    }

}
