import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "Components"


//import "../../javascript/storage.js" as Storage

import "qrc:/javascript/storage.js" as Storage


Rectangle {
    id: mainWindow
    property int header_height: 30
    property string main_log_msg: ""
    property string popup_msg: ""
    property bool popup_show: false
    width:1024; height: 700
    color: "transparent"
    BorderImage {
        id: gstabiBackgroundImage
        asynchronous: true
        anchors.fill: parent
        z: -100
        anchors.centerIn: parent
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_background.png"
    }
    GAppHeader{
        id: header
        width: 500
        anchors.top: gstabiBackgroundImage.top ; anchors.topMargin: 20
        anchors.left: gstabiBackgroundImage.left ; anchors.leftMargin: 30
        implicitHeight: gstabiBackgroundImage.height ; implicitWidth: gstabiBackgroundImage.width
    }
    GBattery{
        anchors.left: gstabiBackgroundImage.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
    }

    Item{
        id: buttonsPanel
        width: 210; height: 40
        anchors.verticalCenterOffset: -20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Row{

            anchors.top: parent.top; anchors.topMargin: 5
            spacing: 5
            GButton{
                id: writeConfigParamsToMCU
                width: 100; height: 30
                text: "Write"
                onClicked: {
                    if(_serialLink.isConnected) {
                        _mavlink_manager.write_params_to_board();
                    }
                    else{
                        popup_msg = ("Controller board is not connected. Please connect the board to your PC through USB cable then try again")
                        popup_show = true;
                    }
                }
                onEntered: dialog_log("Write parameters to controller board")
            }
            GButton{
                id: readConfigParamsFromMCU
                width: 100; height: 30
                text: "Read"
                onClicked: {
                    if(_serialLink.isConnected){ _mavlink_manager.request_all_params(); }
                    else {
                        popup_msg = "Controller board is not connected. Please connect the board to your PC through USB cable then try again"
                        popup_show = true;
                    }
                }
                onEntered: dialog_log("Read parameters from controller board")
            }
        }
    }
    GDashBoard{
        id: gDashboard
        width: 700;     height: 250
        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter; anchors.horizontalCenterOffset: 120
        anchors.top: gstabiBackgroundImage.top; anchors.topMargin: 40
    }
    GMainControlPanel{
        anchors.bottom: gstabiBackgroundImage.bottom; anchors.bottomMargin: 5
        anchors.right: parent.right; anchors.rightMargin: 10
        onMotor_config_enabledChanged: gDashboard.gauge_config_mode = motor_config_enabled
        onMotor_control_enabledChanged: {
            gDashboard.gauge_control_enabled = motor_control_enabled;
            console.log( gDashboard.gauge_control_enabled)
        }
    }
    GConsole{
        id: systemConsole
        anchors.top: gstabiBackgroundImage.top;   anchors.topMargin: 80
        anchors.left: gstabiBackgroundImage.left; anchors.leftMargin: 50
        msg_history: main_log_msg
    }
    GPopupMessage{
        id: popupDialog
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: gstabiBackgroundImage.Center;
    }

    onMain_log_msgChanged: {
        if(main_log_msg.length >=5000){
            main_log_msg = ""
            dialog_log("************************")
            dialog_log("*** Log data cleared ***")
            dialog_log("************************")
        }
    }
    Connections{
        target: _mavlink_manager;
        onMavlink_message_logChanged: {main_log_msg = _mavlink_manager.mavlink_message_log + "\n" + main_log_msg}

    }

    GTextStyled {
        id: gremsyText
        color: "#0cf708"
        text: qsTr("Developed by Gremsy Co., Ltd")
        anchors.right: gstabiBackgroundImage.right
        anchors.rightMargin: 15
        anchors.bottom: gstabiBackgroundImage.bottom
        anchors.bottomMargin: 15
        font.pixelSize: 12
    }
    Component.onCompleted: {
//        Storage.getSettingDatabaseSync();
//        Storage.initializeSettings();
//        if(Storage.getSetting("Port name") !== "NA"){   // if already exist, get it
//            generalSettingsPanel.selected_portname = Storage.getSetting("Port name")
//        }
//        if(Storage.getSetting("Port index") !== "NA"){   // if already exist, get it
//            generalSettingsPanel.selected_port_index = Storage.getSetting("Port index")
//        }
//        if(Storage.getSetting("Profile") !== "NA"){   // if already exist, get it
//            profileDialog.profile_name = Storage.getSetting("Profile")
//        }
        dialog_log("************************************\n")
        dialog_log("Before you can start to control or config your system, please connect your system to PC then open the serial port to establish the communication with controller board on gStabi Systtem \n")
        dialog_log("Welcome to gStabi Station Controller \n")
        dialog_log("************************************\n")



    }
    Component.onDestruction: {
//        Storage.getSettingDatabaseSync();
//        Storage.initializeSettings();
//        if(Storage.getSetting("Port name") !== "NA"){ // already in table, do update
//            Storage.updateSetting("Port name", generalSettingsPanel.selected_portname);
//        } else {
//            Storage.saveSetting("Port name", generalSettingsPanel.selected_portname)
//        }

//        if(Storage.getSetting("Port index") !== "NA"){ // already in table, do update
//            Storage.updateSetting("Port index", generalSettingsPanel.selected_port_index);
//        } else {
//            Storage.saveSetting("Port index", generalSettingsPanel.selected_port_index)
//        }

//        if(Storage.getSetting("Profile") !== "NA"){ // already in table, do update
//            Storage.updateSetting("Profile", profileDialog.profile_name);
//        } else {        // else do create
//            Storage.saveSetting("Profile", profileDialog.profile_name)
//        }

    }
    /* function dialog_log(_message)
       @brief: put message to log
       @input: _message
       @output: msg_log to display in console
      */
    function dialog_log(_message){
//        main_log_msg = "<font color=\"white\">" + _message+ "</font><br>" + main_log_msg;
        main_log_msg ="- "+_message + "\n" + main_log_msg;
    }
}
