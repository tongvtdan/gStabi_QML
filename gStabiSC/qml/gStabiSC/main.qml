import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "Components"


//import "../../javascript/storage.js" as Storage

import "qrc:/javascript/storage.js" as Storage


Rectangle {
    id: mainWindow
    property int header_height: 30
    property string main_log_msg: ""
    property string running_image_source: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_run_0_port_connect.png"
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
                    else{  dialog_log("Controller board is not connected. Please connect PC to the board then try again") }
                }
                onEntered: dialog_log("Write parameters to controller board")
            }
            GButton{
                id: readConfigParamsFromMCU
                width: 100; height: 30
                text: "Read"
                onClicked: {
                    if(_serialLink.isConnected){ _mavlink_manager.request_all_params(); }
                    else {dialog_log("Controller board is not connected. Please connect PC to the board then try again")}
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
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        state: "Dashboard"
        onStateChanged: {
            if(gDashboard.state === "Config") {
                dashboard_config_mode = true
                generalSettingsPanel.state = "hide";
                controllerParamsDialog.state = "hide"
                profileDialog.state = "hide"
            }
            else {
                dashboard_config_mode = false
            }
        }
    }
    GMainControlPanel{
//        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter;  anchors.horizontalCenterOffset: 0
        anchors.bottom: gstabiBackgroundImage.bottom; anchors.bottomMargin: 5
        anchors.right: parent.right; anchors.rightMargin: 10

    }
    GConsole{
        id: systemConsole
        anchors.top: gstabiBackgroundImage.top;   anchors.topMargin: 50
        anchors.left: gstabiBackgroundImage.left; anchors.leftMargin: 50
        msg_history: main_log_msg
    }

/*
    GControllerParams{
        id: controllerParamsDialog
        state: "hide"
        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter;  anchors.horizontalCenterOffset: 0
//        y: gstabiBackgroundImage.height - controllerParamsDialog.height - 70
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        onStateChanged: {
            if(state === "show"){
                pidSettingsButton.state = "pressed"
                generalSettingsPanel.state = "hide"
                profileDialog.state = "hide"
                motorsConfigurationPanel.state = "hide"
                gDashboard.state = "Dashboard"
            } else {
                pidSettingsButton.state = "normal"
            }

        }
    }

    GMotorsConfiguration{
        id: motorsConfigurationPanel
        state: "hide"
        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter; anchors.horizontalCenterOffset: 0
//        y: (gstabiBackgroundImage.y + gstabiBackgroundImage.height)/2 - height;
        onStateChanged: {
            if(state === "show"){
                motorsParamsButton.state = "pressed"
                controllerParamsDialog.state = "hide"
                generalSettingsPanel.state = "hide"
                gDashboard.state = "Config"
            } else {
                motorsParamsButton.state = "normal"
                gDashboard.state = "Dashboard"
            }
        }
    }
    GProfile{
        id: profileDialog
        state: "hide";
        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter; anchors.horizontalCenterOffset: 0
        show_state_posY: 400
        save_profile: false
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        onStateChanged: {
            if(state === "show"){
                profileDialogButton.state = "pressed"
                controllerParamsDialog.state = "hide"
                generalSettingsPanel.state = "hide"
                motorsConfigurationPanel.state = "hide"
                gDashboard.state = "Dashboard"
            } else {
                profileDialogButton.state = "normal"
            }
        }
    }



    GGeneralSettings{
        id: generalSettingsPanel
        state: "show"
        anchors.horizontalCenter: gstabiBackgroundImage.horizontalCenter; anchors.horizontalCenterOffset: 0
        show_state_posY: 380
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg }
        onStateChanged: {
            if(state === "show"){
                serialSettingButton.state = "pressed"
                controllerParamsDialog.state = "hide"
                motorsConfigurationPanel.state = "hide"
                gDashboard.state = "Dashboard"
            } else serialSettingButton.state = "normal"
        }
    }

    Row {
        id: buttonsRow
        width: 300; height: 70
        anchors.bottom: gstabiBackgroundImage.bottom; anchors.bottomMargin: 0
        anchors.left: gstabiBackgroundImage.left; anchors.leftMargin: 50
        spacing: 10
        GImageButton{
            id: serialSettingButton
            imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_ports_disconnect.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_ports_disconnect.png"
            imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_ports_disconnect.png"
            text: ""
            Image{
                id: runningImage
                anchors.fill: parent
                source: running_image_source
                visible: false
            }
            onClicked: {
                if(generalSettingsPanel.state === "show"){
                    generalSettingsPanel.state = "hide"
                } else {
                    generalSettingsPanel.state = "show"
                }
            }
            onEntered: dialog_log("Open or Close Serial Port dialog")
        }
        GImageButton{
            id: motorsParamsButton
            text:""
            imageNormal: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_motors.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_motors.png"
            imageHover: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_motors.png"
            onClicked: {
                if(motorsConfigurationPanel.state === "hide") {
                    motorsConfigurationPanel.state = "show" ;
                } else {
                    motorsConfigurationPanel.state = "hide";
                }
            }
        }

        GImageButton{
            id: pidSettingsButton
            text: ""
            imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_pid.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_pid.png"
            imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_pid.png"
            onClicked: {
                if(controllerParamsDialog.state === "hide") {
                    controllerParamsDialog.state = "show" ;
                } else {
                    controllerParamsDialog.state = "hide";
                }
            }
            onEntered: dialog_log("Open or Close Controller Settings dialog")
        }
        GImageButton{
            id: profileDialogButton
            text: ""
            imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_profile.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_profile.png"
            imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_profile.png"
            onClicked: {
                profileDialog.save_profile = false;
                if(profileDialog.state  === "show"){
                    profileDialog.state  = "hide"
                }else {
                    profileDialog.state  = "show";
                }
            }
            onEntered: dialog_log("Open or Close Profile dialog");
        }
        GImageButton{
            id: imuSettingButton
            text:""
            imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_imu.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_imu.png"
            imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_imu.png"
            onEntered: dialog_log("IMU Settings")
        }
        GImageButton{
            id: realtimeChartButton
            text:""
            imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_chart.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_chart.png"
            imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_chart.png"
            onEntered: dialog_log("Realtime data charts")
        }
        GImageButton{
            id: systemInfo
            text: ""
            imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_info.png"
            imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_info.png"
            imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_info.png"
            onEntered: dialog_log("Get Application Information")
            onClicked: _mavlink_manager.get_mavlink_info();
        }

    }   // end of buttons Panel
    */
    onMain_log_msgChanged: {
        if(main_log_msg.length >=1000){
            main_log_msg = ""
            dialog_log("Log data cleared")
        }
    }
    Connections{
        target: _mavlink_manager;
        onMavlink_message_logChanged: {main_log_msg = _mavlink_manager.mavlink_message_log + "\n" + main_log_msg}
//        onBoard_connection_stateChanged: {
//            if(_mavlink_manager.board_connection_state){
////            generalSettingsPanel.state = "hide";
//                serialSettingButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_port_connect.png"
//                serialSettingButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_port_connect.png"
//                serialSettingButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_port_connect.png"
//                runningImage.visible = true;
//            }
//            else{
//                serialSettingButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_ports_disconnect.png"
//                serialSettingButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_ports_disconnect.png"
//                serialSettingButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_ports_disconnect.png"
//                runningImage.visible = false
//            }
//            waitingForConnection.paused = !_mavlink_manager.board_connection_state;

//        }
        onHb_pulseChanged: {
            if(_mavlink_manager.hb_pulse)
            running_image_source =   "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_run_0_port_connect.png"
            else running_image_source = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_run_1_port_connect.png"
        }
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

//        dialog_log("<center>************************************</center>")
//        dialog_log("<center>Before you can start to control or config your system, please connect your system to PC then open the serial port to establish the communication with controller board on gStabi Systtem</center>")
//        dialog_log("<center>Welcome to gStabi Station Controller</center>")
//        dialog_log("<center>************************************</center>")


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
       @output: msg_log in HTML format
      */
    function dialog_log(_message){
//        main_log_msg = "<font color=\"white\">" + _message+ "</font><br>" + main_log_msg;
        main_log_msg =_message+ "\n" + main_log_msg;
    }
}
