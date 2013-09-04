import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "GDashboard"
import "Components"

import "../../javascript/storage.js" as Storage




Item {
    id: mainWindow
    property int header_height: 30
    property string main_log_msg: ""
    property string table_name: "gStabi"

//    color: "#242424"
    BorderImage {
        id: gstabiBackgroundImage
        width: 1044;  height: 700
        anchors.centerIn: parent
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_background.png"
    }
    GAppHeader{
        id: header
        anchors.top: gstabiBackgroundImage.top ; anchors.topMargin: 20
        anchors.left: gstabiBackgroundImage.left ; anchors.leftMargin: 30
        implicitHeight: gstabiBackgroundImage.height ; implicitWidth: gstabiBackgroundImage.width
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
    GDashBoard{
        id: gDashboard
        anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: 15
        anchors.top: gstabiBackgroundImage.top; anchors.topMargin: 60
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        onStateChanged: {
            if(gDashboard.state === "Config") {
                textConsole.state = "smaller"
                comportSettingPanel.state = "smaller";
            }
            else {
                textConsole.state = "focus"
            }
        }
    } // end of dashboard
    GSerialSettings{
        id: comportSettingPanel
        state: "focus"
        x: gstabiBackgroundImage.x + 50 ;
        y: (gstabiBackgroundImage.y + gstabiBackgroundImage.height)/2 - height/2;
        focus_state_posY: gstabiBackgroundImage.height - comportSettingPanel.height - 70
        unfocus_state_posY: gstabiBackgroundImage.height - comportSettingPanel.height + 100
        dragMinX: 50
        dragMaxX: gstabiBackgroundImage.width - comportSettingPanel.width
        dragMaxY: gstabiBackgroundImage.height - comportSettingPanel.height
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
    }
    GConsole{
        id: textConsole
        x: 400
        opacity: 1
        state: "focus"
        height: 200; width:  300
        focus_state_posY: gstabiBackgroundImage.height - textConsole.height - 70
        unfocus_state_posY: gstabiBackgroundImage.height - textConsole.height + 100
        dragMaxX: gstabiBackgroundImage.width - textConsole.width
        dragMaxY: gstabiBackgroundImage.height - textConsole.height+100
        msg_history: main_log_msg
    }
    GPIDDialog{
        id: pidSettingDialog
        z: -1
        state: "hideDialog"
        dragMaxX: gstabiBackgroundImage.width - pidSettingDialog.width
        dragMaxY: gstabiBackgroundImage.height - pidSettingDialog.height
        x: (gstabiBackgroundImage.x + gstabiBackgroundImage.width)/2 - width/2;
        y: (gstabiBackgroundImage.y + gstabiBackgroundImage.height)/2 - height/2;
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
    }
    GProfile{
        id: saveProfileDialog
        state: "smaller";
        x: (gstabiBackgroundImage.x + gstabiBackgroundImage.width)/2 - width/2;
        y: (gstabiBackgroundImage.y + gstabiBackgroundImage.height)/2 - height;
        focus_state_posY: gstabiBackgroundImage.height - saveProfileDialog.height - 100
        unfocus_state_posY: gstabiBackgroundImage.height - saveProfileDialog.height + 100
        dragMaxX: gstabiBackgroundImage.width - saveProfileDialog.width
        dragMaxY: gstabiBackgroundImage.height - saveProfileDialog.height
        save_profile: false
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
    }

    Item {
        id: buttonsPanel
        width: 150; height: 70
        anchors.bottom: gstabiBackgroundImage.bottom; anchors.bottomMargin: 0
        anchors.left: gstabiBackgroundImage.left; anchors.leftMargin: 50
        GImageButton{
            id: serialSettingDialog
            anchors.left: parent.left; anchors.leftMargin: 0
            text: "Port"
            onClicked: {
                if(comportSettingPanel.state === "focus"){
                    comportSettingPanel.state = "smaller"
                } else {
                    comportSettingPanel.state = "focus"
                    state = "pressed"
                }
            }
            onVisibleChanged: visible? serialSettingDialog.state = "pressed" : serialSettingDialog.state = "normal"
        }
        GImageButton{
            id: pidSettingsButton
            text: "PID"
            anchors.left: serialSettingDialog.right; anchors.leftMargin: 20
            onClicked: {
                if(pidSettingDialog.state === "hideDialog") {
                    pidSettingDialog.state = "showDialog" ;
                } else {
                    pidSettingDialog.state = "hideDialog";
                }
            }
        }
        GImageButton{
            id: systemInfo
            text: "Info"
            anchors.left: pidSettingsButton.right; anchors.leftMargin: 20
            onClicked: _mavlink_manager.get_mavlink_info();
        }
        GImageButton{
            id: saveSettingToPC
            text: "Profile"
            anchors.left: systemInfo.right; anchors.leftMargin: 20
            onClicked: {
                saveProfileDialog.save_profile = false;
                if(saveProfileDialog.state  === "focus"){
                    saveProfileDialog.state  = "smaller"
                    textConsole.state = "focus"
                }else {
                    saveProfileDialog.state  = "focus";
                    textConsole.state = "smaller"
                }
            }
        }
    }   // end of buttons Panel
    onMain_log_msgChanged: {
        if(main_log_msg.length >=10000){
            main_log_msg = "Log data cleared"
        }
    }
    Connections{
        target: _mavlink_manager;
        onMavlink_message_logChanged: {main_log_msg = _mavlink_manager.mavlink_message_log + "<br>" + main_log_msg}
        onBoard_connection_stateChanged: {
            if(_mavlink_manager.board_connection_state){
            comportSettingPanel.state = "smaller";
            }
            waitingForConnection.paused = !_mavlink_manager.board_connection_state;
        }
    }

    Text {
        id: gremsyText
        x: 342
        y: 324
        color: "#0cf708"
        text: qsTr("Developed by Gremsy Co., Ltd")
        anchors.right: gstabiBackgroundImage.right
        anchors.rightMargin: 20
        anchors.bottom: gstabiBackgroundImage.bottom
        anchors.bottomMargin: 15
        font.bold: true
        font.family: "Segoe UI"
        font.pixelSize: 12
    }
    Component.onCompleted: {
    }
}
