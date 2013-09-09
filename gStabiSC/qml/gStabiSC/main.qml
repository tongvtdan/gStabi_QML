import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import "GDashboard"
import "Components"


//import "../../javascript/storage.js" as Storage

import "qrc:/javascript/storage.js" as Storage


Item {
    id: mainWindow
    property int header_height: 30
    property string main_log_msg: ""
    property string running_image_source: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_run_0_port_connect.png"

    BorderImage {
        id: gstabiBackgroundImage
        asynchronous: true
        width: 1044;  height: 700
        z: -100
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
    // end of dashboard
    GControllerParams{
        id: controllerParamsDialog
        state: "hide"
        dragMaxX: gstabiBackgroundImage.width
        dragMaxY: gstabiBackgroundImage.height
        x: gstabiBackgroundImage.x + gstabiBackgroundImage.width/2 - controllerParamsDialog.width/2;
        show_state_posY: gstabiBackgroundImage.y + gstabiBackgroundImage.height/2 - controllerParamsDialog.height/2;
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        onStateChanged: {
            if(state === "show"){
                pidSettingsButton.state = "pressed"
                comportSettingPanel.state = "hide"
                profileDialog.state = "hide"
                gDashboard.state = "Dashboard"
                systemConsole.y = gstabiBackgroundImage.height - systemConsole.height/2;
            }
            else {
                systemConsole.y = systemConsole.show_state_posY;
                pidSettingsButton.state = "normal"
            }
        }
    }

    GDashBoard{
        id: gDashboard
        width: 1024;     height: 340
        z:0;
        anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: 15
        anchors.top: gstabiBackgroundImage.top; anchors.topMargin: 60
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        state: "Dashboard"
        onStateChanged: {
            if(gDashboard.state === "Config") {
                dashboard_config_mode = true
                dialog_log("Switch to Motor Confid Mode")
                comportSettingPanel.state = "hide";
                controllerParamsDialog.state = "hide"
                profileDialog.state = "hide"
                systemConsole.y = gstabiBackgroundImage.height - systemConsole.height/2;
            }
            else {
                dashboard_config_mode = false
                dialog_log("Switch to Dashboard mode")
                systemConsole.y = systemConsole.show_state_posY;
            }
        }
    }

    GProfile{
        id: profileDialog
        state: "hide";
        x: (gstabiBackgroundImage.x + gstabiBackgroundImage.width)/2 - width/2;
        y: (gstabiBackgroundImage.y + gstabiBackgroundImage.height)/2 - height;
        show_state_posY: gstabiBackgroundImage.height - profileDialog.height - 100
        hide_state_posY: gstabiBackgroundImage.height - profileDialog.height + 100
        dragMaxX: gstabiBackgroundImage.width - profileDialog.width
        dragMaxY: gstabiBackgroundImage.height - profileDialog.height
        save_profile: false
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg  }
        onStateChanged: {
            if(state === "show"){
                profileDialogButton.state = "pressed"
                controllerParamsDialog.state = "hide"
                comportSettingPanel.state = "hide"
                gDashboard.state = "Dashboard"
            } else {
                profileDialogButton.state = "normal"
            }
        }
    }

    GConsole{
        id: systemConsole
        x: gstabiBackgroundImage.x + gstabiBackgroundImage.width - systemConsole.width - 15
        opacity: 1
        hide_scale: 1
        state: "show"
        height: 200; width:  300
        show_state_posY: gstabiBackgroundImage.height - systemConsole.height - 70
        hide_state_posY: gstabiBackgroundImage.height - systemConsole.height + 100
        dragMinX: gstabiBackgroundImage.x; dragMaxX: gstabiBackgroundImage.width - systemConsole.width/2
        dragMaxY: gstabiBackgroundImage.height - systemConsole.height+100
        msg_history: main_log_msg
        Behavior on y {
            NumberAnimation { target: systemConsole; property: "y"; duration: 400; easing.type: Easing.Bezier }
        }

    }

    GSerialSettings{
        id: comportSettingPanel
        state: "show"
        x: gstabiBackgroundImage.x + 50 ;
        y: (gstabiBackgroundImage.y + gstabiBackgroundImage.height)/2 - height/2;
        show_state_posY: gstabiBackgroundImage.height - comportSettingPanel.height - 70
        hide_state_posY: gstabiBackgroundImage.height - comportSettingPanel.height + 100
        dragMinX: 50
        dragMaxX: gstabiBackgroundImage.width - comportSettingPanel.width
        dragMaxY: gstabiBackgroundImage.height - comportSettingPanel.height
        onMsg_logChanged: { main_log_msg = msg_log + main_log_msg }
        onStateChanged: {
            if(state === "show"){
                serialSettingButton.state = "pressed"
                controllerParamsDialog.state = "hide"
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
                if(comportSettingPanel.state === "show"){
                    comportSettingPanel.state = "hide"
                } else {
                    comportSettingPanel.state = "show"
                }
            }
            onEntered: dialog_log("Open or Close Serial Port dialog")
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
    onMain_log_msgChanged: {
        if(main_log_msg.length >=1000){
            main_log_msg = ""
            dialog_log("Log data cleared")
        }
    }
    Connections{
        target: _mavlink_manager;
        onMavlink_message_logChanged: {main_log_msg = _mavlink_manager.mavlink_message_log + "\n" + main_log_msg}
        onBoard_connection_stateChanged: {
            if(_mavlink_manager.board_connection_state){
//            comportSettingPanel.state = "hide";
                serialSettingButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_port_connect.png"
                serialSettingButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_port_connect.png"
                serialSettingButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_port_connect.png"
                runningImage.visible = true;
            }
            else{
                serialSettingButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_normal_ports_disconnect.png"
                serialSettingButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_ports_disconnect.png"
                serialSettingButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_focus_ports_disconnect.png"
                runningImage.visible = false
            }
            waitingForConnection.paused = !_mavlink_manager.board_connection_state;

        }
        onHb_pulseChanged: {
            if(_mavlink_manager.hb_pulse)
            running_image_source =   "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_run_0_port_connect.png"
            else running_image_source = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_run_1_port_connect.png"
        }
    }

    TextStyled {
        id: gremsyText
        color: "#0cf708"
        text: qsTr("Developed by Gremsy Co., Ltd")
        anchors.right: gstabiBackgroundImage.right
        anchors.rightMargin: 20
        anchors.bottom: gstabiBackgroundImage.bottom
        anchors.bottomMargin: 15
        font.pixelSize: 12
    }
    Component.onCompleted: {
        Storage.getSettingDatabaseSync();
        Storage.initializeSettings();
        if(Storage.getSetting("Port name") !== "NA"){   // if already exist, get it
            comportSettingPanel.selected_portname = Storage.getSetting("Port name")
        }
        if(Storage.getSetting("Port index") !== "NA"){   // if already exist, get it
            comportSettingPanel.selected_port_index = Storage.getSetting("Port index")
        }
        if(Storage.getSetting("Profile") !== "NA"){   // if already exist, get it
            profileDialog.profile_name = Storage.getSetting("Profile")
        }
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
        Storage.getSettingDatabaseSync();
        Storage.initializeSettings();
        if(Storage.getSetting("Port name") !== "NA"){ // already in table, do update
            Storage.updateSetting("Port name", comportSettingPanel.selected_portname);
        } else {
            Storage.saveSetting("Port name", comportSettingPanel.selected_portname)
        }

        if(Storage.getSetting("Port index") !== "NA"){ // already in table, do update
            Storage.updateSetting("Port index", comportSettingPanel.selected_port_index);
        } else {
            Storage.saveSetting("Port index", comportSettingPanel.selected_port_index)
        }

        if(Storage.getSetting("Profile") !== "NA"){ // already in table, do update
            Storage.updateSetting("Profile", profileDialog.profile_name);
        } else {        // else do create
            Storage.saveSetting("Profile", profileDialog.profile_name)
        }

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
