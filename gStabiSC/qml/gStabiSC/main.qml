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

    property string selected_portname: "COM1"
    property int    selected_port_index: 1
    property string profile_name    : "Profile_Default"

    property int gremsy_product_id: 0
    property bool   speed_mode  : false   // 0: angle mode; 1: speed mode



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
        width: 400; height: 50
        anchors.verticalCenterOffset: -25
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        Item{
            id: buttonsRow
            anchors.fill: parent
            GButton{
                id: writeConfigParamsToMCU
                width: 100; height: 30
                text: "Write"
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    if(_serialLink.isConnected) {
                        _mavlink_manager.write_params_to_board();
                        show_popup_message("Sent parameters to gStabi Controller...Done")
                    }
                    else{
                       show_popup_message("gStabi controller is not connected.\n Check the connection then try again")
                    }
                }
                onEntered: dialog_log("Write parameters to controller board")
            }
            GButton{
                id: readConfigParamsFromMCU
                width: 100; height: 30
                text: "Read"
                anchors.left: writeConfigParamsToMCU.right
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    if(_serialLink.isConnected){
                        _mavlink_manager.request_all_params();
                        show_popup_message("Read parameters from gStabi Controller... Done")
                    }
                    else {
                        show_popup_message("gStabi Controller is disconnected.\nCheck the connection then try again")
                    }
                }
                onEntered: dialog_log("Read parameters from controller board")
            }
            GImageButton{
                id: quickOpenCloseComportButton
                width: 70; height: 50;
                text: ""
                anchors.left: readConfigParamsFromMCU.right
                anchors.leftMargin: 20
//                horizontalCenterOffset_value: 90
                anchors.verticalCenter: parent.verticalCenter
                imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_ports_disconnect.png"
                imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
                imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
                Image{
                    id: connectedImage
                    anchors.fill: parent
                    width: 50; height: 35
                    source: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_run_0_port_connect.png"
                    visible: false
                }
                onEntered: dialog_log("* Open or Close Comport *")
                onClicked: {
                    if(!_serialLink.isConnected){       // if port is being closed, can update port name
                        _serialLink.update_comport_settings(selected_portname);
                    }
                    _serialLink.open_close_comport();
                    if(_serialLink.isConnected) {
                        show_popup_message("Port " + selected_portname + " is Opened \n Connecting to gStabi Controller ...")
                    }
                    else {
                        show_popup_message("Port " + selected_portname + " is Closed.")
                    }
                }
            }
            GTextStyled{
                id: comportButtonLabel
                anchors.verticalCenter: parent.verticalCenter
                text: "Disconnected"
                anchors.left: quickOpenCloseComportButton.right
                anchors.leftMargin: 0
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
                color: "cyan"
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
        }
    }
    GConsole{
        id: systemConsole
        anchors.top: gstabiBackgroundImage.top;   anchors.topMargin: 80
        anchors.left: gstabiBackgroundImage.left; anchors.leftMargin: 50
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
        onMavlink_message_logChanged: {
            show_popup_message(_mavlink_manager.mavlink_message_log)
//            main_log_msg = _mavlink_manager.mavlink_message_log + "\n" + main_log_msg
        }
        onBoard_connection_stateChanged: {
            if(_mavlink_manager.board_connection_state){
                quickOpenCloseComportButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_port_connect.png"
                quickOpenCloseComportButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_port_connect.png"
                quickOpenCloseComportButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_port_connect.png"
                comportButtonLabel.text = "Connected"
                connectedImage.visible = true;
//                popup_msg = "gStabi controller is connected"
            }
            else{
                quickOpenCloseComportButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_ports_disconnect.png"
                quickOpenCloseComportButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
                quickOpenCloseComportButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
                comportButtonLabel.text = "Disconnected"
                connectedImage.visible = false
//                show_popup_message("gStabi controller is disconnected.")
            }
        }
        onHb_pulseChanged: {
            if(_mavlink_manager.hb_pulse)
                connectedImage.source  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_run_0_port_connect.png"
            else connectedImage.source = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_run_1_port_connect.png"
        }
    }

    GTextStyled {
        id: gremsyText
        color: "#04ff00"
        text: qsTr("Developed by Gremsy Co., Ltd")
        anchors.right: gstabiBackgroundImage.right
        anchors.rightMargin: 15
        anchors.bottom: gstabiBackgroundImage.bottom
        anchors.bottomMargin: 15
        font.pixelSize: 12
    }
    Component.onCompleted: {
        Storage.getSettingDatabaseSync();
        Storage.initializeSettings();
        if(Storage.getSetting("Port name") !== "NA"){   // if already exist, get it
            selected_portname = Storage.getSetting("Port name")
        }
        if(Storage.getSetting("Port index") !== "NA"){   // if already exist, get it
            selected_port_index = Storage.getSetting("Port index")
        }
        if(Storage.getSetting("Profile") !== "NA"){   // if already exist, get it
            profile_name = Storage.getSetting("Profile")
        }
        dialog_log("************************************\n")
        dialog_log("Before you can start to control or config your system, please connect your system to PC then open the serial port to establish the communication with controller board on gStabi Systtem \n")
        dialog_log("Welcome to gStabi Station Controller \n")
        dialog_log("************************************\n")
        show_popup_message("Welcome to gStabi Station Controller \n
1. Power on gStabi system \n
2. Open Serial port\n
3. Application is ready to Monitor or Setup gStabi Controller")


    }
    Component.onDestruction: {
        Storage.getSettingDatabaseSync();
        Storage.initializeSettings();
        if(Storage.getSetting("Port name") !== "NA"){ // already in table, do update
            Storage.updateSetting("Port name", selected_portname);
        } else {
            Storage.saveSetting("Port name", selected_portname)
        }

        if(Storage.getSetting("Port index") !== "NA"){ // already in table, do update
            Storage.updateSetting("Port index", selected_port_index);
        } else {
            Storage.saveSetting("Port index", selected_port_index)
        }

        if(Storage.getSetting("Profile") !== "NA"){ // already in table, do update
            Storage.updateSetting("Profile", profile_name);
        } else {        // else do create
            Storage.saveSetting("Profile", profile_name)
        }
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
    function show_popup_message(_message){
        popup_msg = _message;
        popup_show = true;
    }
}
