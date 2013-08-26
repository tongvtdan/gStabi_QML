import QtQuick 2.0
//import QtQuick.Controls 1.0
//import QtQuick.Controls.Styles 1.0

import "AppHeader"
import "Comm"
import "GDashboard"
import "Components"

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
        onStateChanged: {
            if(gDashboard.state == "Config") comportSettingPanel.state = "hide";
            else comportSettingPanel.state = "show";
        }

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
//        x: 50
        anchors.right: textConsole.left
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
    Item {
        id: buttonsPanel
        width: 150
        height: 70
        anchors.bottom: gstabiBackgroundImage.bottom; anchors.bottomMargin: 0
        anchors.left: gstabiBackgroundImage.left; anchors.leftMargin: 50
        GImageButton{
            id: serialSettingDialog
            anchors.left: parent.left; anchors.leftMargin: 0
            text: "Port"
            onClicked: {
                comportSettingPanel.visible == true ? comportSettingPanel.visible = false : comportSettingPanel.visible = true
            }
        }
        GImageButton{
            id: pidSettingDialog
            text: "PID"
            anchors.left: serialSettingDialog.right; anchors.leftMargin: 20
        }
    }   // end of buttons Panel
    onMain_log_msgChanged: {
        if(main_log_msg.length >=10000){
            main_log_msg = "Log data cleared "
        }
    }

}
