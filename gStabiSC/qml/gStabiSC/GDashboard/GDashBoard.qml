import QtQuick 2.0


import "../Components"
/*
  All angles value unit are Degree
  */
Item {
    id: root
    width: 1024
    height: 340
    property int gauge_width: 330
    property int gauge_height: 330
    property string msg_log : "" // log the message to display on Console
    property bool   dashboard_config_mode : false   // if false: dashbord mode; if true: config mode

    state: "Dashboard"

//    BorderImage {
//        id: dashboardPanelImage
//        source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_dashboard_panel.png"
//        opacity: 0.5
//        anchors.fill: parent
//    }
    GGauge{
        id: tiltGauge
        gauge_tilte: "Tilt"
        gauge_type: 1; gauge_offset: 0
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.top: parent.top; anchors.topMargin: 0
        anchors.left: parent.left; anchors.leftMargin: 15
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_green_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_green_handle.png"
        gauge_config_mode: dashboard_config_mode
        gauge_sensor_value: _mavlink_manager.tilt_angle
        onGauge_log_messageChanged: tilt_log(tiltGauge.gauge_log_message)
        onGauge_up_limit_set_angleChanged: tiltConfigDialog.min_value = gauge_up_limit_set_angle;
        onGauge_down_limit_set_angleChanged: tiltConfigDialog.max_value = gauge_down_limit_set_angle;

    }
    GGauge{
        id: panGauge
        gauge_tilte: "Pan"
        gauge_type: 2; gauge_offset: 90
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.top: parent.top; anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_pan.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_pan.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_blue_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_blue_handle.png"
        gauge_config_mode: dashboard_config_mode
        gauge_sensor_value: _mavlink_manager.yaw_angle
        onGauge_log_messageChanged: pan_log(panGauge.gauge_log_message)
        onGauge_down_limit_set_angleChanged: panConfigDialog.max_value = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   panConfigDialog.min_value = gauge_up_limit_set_angle
    }
    GGauge{
        id: rollGauge
        gauge_tilte: "Roll"
        gauge_type: 3; gauge_offset: 0
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.top: parent.top; anchors.topMargin: 0
        anchors.right : parent.right; anchors.rightMargin: 15
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_roll.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_roll.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_cyan_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_cyan_handle.png"
        gauge_config_mode: dashboard_config_mode
        gauge_sensor_value: _mavlink_manager.roll_angle
        onGauge_log_messageChanged: roll_log(rollGauge.gauge_log_message)
        onGauge_down_limit_set_angleChanged: rollConfigDialog.max_value = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   rollConfigDialog.min_value = gauge_up_limit_set_angle
    }
    Item{
        id: configButtonsPanel
        anchors.right: parent.right; anchors.rightMargin: 50
        anchors.top: parent.top; anchors.topMargin: -40
        width: 400; height: 40
        Row{
            id: buttonsRow
            anchors.top: parent.top; anchors.topMargin: 5
            spacing: 5
            GButton{
                id: modeSelectionButton
                width: 120; height: 30
                text: "Config"
                onClicked: {
                    dashboard_config_mode = !dashboard_config_mode;
                    root.state = dashboard_config_mode? "Config" : "Dashboard"
                }
            }
            GButton{
                id: writeConfigParamsToMCU
                width: 100; height: 30
                text: "Write"
            }
            GButton{
                id: readConfigParamsFromMCU
                width: 100; height: 30
                text: "Read"
            }
        }
    }
    GMotorConfig{
        id: tiltConfigDialog
        anchors.horizontalCenter: tiltGauge.horizontalCenter
        anchors.top: tiltGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        onMax_valueChanged: tiltGauge.gauge_down_limit_set_angle = max_value
        onMin_valueChanged: tiltGauge.gauge_up_limit_set_angle = min_value
    }
    GMotorConfig{
        id: panConfigDialog
        anchors.horizontalCenter: panGauge.horizontalCenter
        anchors.top: panGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        onMax_valueChanged: panGauge.gauge_down_limit_set_angle = max_value
        onMin_valueChanged: panGauge.gauge_up_limit_set_angle = min_value
    }
    GMotorConfig{
        id: rollConfigDialog
        anchors.horizontalCenter: rollGauge.horizontalCenter
        anchors.top: rollGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        onMax_valueChanged: rollGauge.gauge_down_limit_set_angle = max_value
        onMin_valueChanged: rollGauge.gauge_up_limit_set_angle = min_value
    }
    states: [
        State {
            name: "Dashboard"
            PropertyChanges { target: modeSelectionButton; text: "Config >>"}
            PropertyChanges { target: writeConfigParamsToMCU; visible: false }
            PropertyChanges { target: readConfigParamsFromMCU; visible: false }
            PropertyChanges { target: tiltConfigDialog; state  : "hideDialog"}
            PropertyChanges { target: panConfigDialog;  state  : "hideDialog"}
            PropertyChanges { target: rollConfigDialog; state  : "hideDialog"}


        },
        State {
            name: "Config"
            PropertyChanges { target: modeSelectionButton; text: "<< Dashboard" }
            PropertyChanges { target: writeConfigParamsToMCU; visible: true }
            PropertyChanges { target: readConfigParamsFromMCU; visible: true }
            PropertyChanges { target: tiltConfigDialog; state: "showDialog"}
            PropertyChanges { target: panConfigDialog;  state: "showDialog"}
            PropertyChanges { target: rollConfigDialog; state: "showDialog"}


        }
    ]
    onStateChanged: {
        if(dashboard_config_mode) {tilt_log("Change to Config Mode")} else {tilt_log("Return to Dashboard mode")}
    }
    /* function tilt_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function tilt_log(_message){
        msg_log = "<font color=\"red\">" + _message+ "</font><br>";
    }
    /* function roll_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function roll_log(_message){
        msg_log = "<font color=\"springgreen\">" + _message+ "</font><br>";
    }
    /* function pan_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function pan_log(_message){
        msg_log = "<font color=\"deepskyblue\">" + _message+ "</font><br>";
    }
}
