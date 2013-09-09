import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "../Components"
//import "../../../javascript/storage.js" as Storage
/*
  All angles value unit are Degree
  */
Item {
    id: root
    property int gauge_width: 330
    property int gauge_height: 330
    property string msg_log : "" // log the message to display on Console
    property bool   dashboard_config_mode : false   // if false: dashbord mode; if true: config mode

    implicitWidth: 1024; implicitHeight: 340
    GGauge{
        id: tiltGauge
        width: gauge_width; height: gauge_height
        gauge_tilte: "Tilt"
        gauge_type: 1; gauge_offset: 0 ; axis_direcion: -1
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.top: parent.top; anchors.topMargin: 0
        anchors.left: parent.left; anchors.leftMargin: 15
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_green_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_green_handle.png"
        gauge_config_mode: dashboard_config_mode
        onEntered: tilt_log("Tilt axis of the system")
        onGauge_up_limit_set_angleChanged: tiltConfigDialog.min_value = gauge_up_limit_set_angle;
        onGauge_down_limit_set_angleChanged:  tiltConfigDialog.max_value = gauge_down_limit_set_angle;
        onGauge_setpoint_angleChanged: send_setpoint_control();
        onGauge_log_messageChanged: dialog_log(gauge_log_message)
    }

    GGauge{
        id: panGauge
        width: gauge_width; height: gauge_height
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
//        up_limit_pie_color: "green"
//        down_limit_pie_color: "chartreuse"
        onEntered: pan_log("Pan axis of the system")
        onGauge_down_limit_set_angleChanged: panConfigDialog.max_value = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   panConfigDialog.min_value = gauge_up_limit_set_angle
        onGauge_setpoint_angleChanged: send_setpoint_control();
        onGauge_log_messageChanged: dialog_log(gauge_log_message)
    }
    GGauge{
        id: rollGauge
        width: gauge_width; height: gauge_height
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
        onEntered: roll_log("Roll axis of the system")
        onGauge_down_limit_set_angleChanged: rollConfigDialog.max_value = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   rollConfigDialog.min_value = gauge_up_limit_set_angle
        onGauge_setpoint_angleChanged: send_setpoint_control();
        onGauge_log_messageChanged: dialog_log(gauge_log_message)
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
                width: 150; height: 30
                text: "Config Motor"
                onClicked: {
                    if(root.state === "Config"){
                        root.state = "Dashboard"
                    } else root.state = "Config"
                }
                onEntered: dialog_log("Open Config Motors Panel")

            }
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
                onEntered: dialog_log("Write Motor Config parameters to controller board")
            }
            GButton{
                id: readConfigParamsFromMCU
                width: 100; height: 30
                text: "Read"
                onClicked: {
                    if(_serialLink.isConnected){ _mavlink_manager.request_all_params(); }
                    else {dialog_log("Controller board is not connected. Please connect PC to the board then try again")}
                }
                onEntered: dialog_log("Read Motor Config parameters from controller board")
            }
        }
    }
    GMotorConfig{
        id: tiltConfigDialog
        anchors.horizontalCenter: tiltGauge.horizontalCenter
        anchors.top: tiltGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        min_limit_label: "Tilt up limit"
        max_limit_label: "Tilt down limit"
        onMax_valueChanged: {
            _mavlink_manager.tilt_down_limit_angle = max_value;
            tiltGauge.gauge_down_limit_set_angle = max_value
        }
        onMin_valueChanged: {
            _mavlink_manager.tilt_up_limit_angle = min_value;
            tiltGauge.gauge_up_limit_set_angle = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.tilt_power = power_level;
        onPoles_numChanged:     _mavlink_manager.motor_tilt_num_poles = poles_num;
        onMotor_dirChanged:     _mavlink_manager.motor_tilt_dir = motor_dir;

    }
    GMotorConfig{
        id: panConfigDialog
        anchors.horizontalCenter: panGauge.horizontalCenter
        anchors.top: panGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        min_limit_label: "Pan left limit"
        max_limit_label: "Pan right limit"
        onMax_valueChanged: {
            _mavlink_manager.pan_cw_limit_angle = max_value;
            panGauge.gauge_down_limit_set_angle = max_value;
        }
        onMin_valueChanged: {
            _mavlink_manager.pan_ccw_limit_angle = min_value;
            panGauge.gauge_up_limit_set_angle = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.pan_power = power_level;
        onPoles_numChanged:     {_mavlink_manager.motor_pan_num_poles = poles_num; console.log("#Pole Changed")}
        onMotor_dirChanged:     _mavlink_manager.motor_pan_dir = motor_dir;

    }
    GMotorConfig{
        id: rollConfigDialog
        anchors.horizontalCenter: rollGauge.horizontalCenter
        anchors.top: rollGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        min_limit_label: "Roll up limit"
        max_limit_label: "Roll down limit"
        onMax_valueChanged: {
            _mavlink_manager.roll_down_limit_angle = max_value;
            rollGauge.gauge_down_limit_set_angle = max_value;
        }
        onMin_valueChanged: {
            _mavlink_manager.roll_up_limit_angle = min_value;
            rollGauge.gauge_up_limit_set_angle = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.roll_power = power_level;
        onPoles_numChanged:     _mavlink_manager.motor_roll_num_poles = poles_num;
        onMotor_dirChanged:     _mavlink_manager.motor_roll_dir = motor_dir;

    }

    states: [
        State {
            name: "Dashboard"
            PropertyChanges { target: modeSelectionButton; text: "Config Motor>>"}
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

    Connections{
        target: _mavlink_manager

        onTilt_powerChanged:            tiltConfigDialog.power_level = _mavlink_manager.tilt_power;
        onMotor_tilt_num_polesChanged:  tiltConfigDialog.poles_num   = _mavlink_manager.motor_tilt_num_poles;
        onMotor_tilt_dirChanged:        tiltConfigDialog.motor_dir   = _mavlink_manager.motor_tilt_dir;
        onTilt_up_limit_angleChanged:   tiltConfigDialog.min_value   = _mavlink_manager.tilt_up_limit_angle;
        onTilt_down_limit_angleChanged: tiltConfigDialog.max_value   = _mavlink_manager.tilt_down_limit_angle;
        onPitch_angleChanged:           tiltGauge.gauge_sensor_value = _mavlink_manager.pitch_angle;

        onPan_powerChanged:             panConfigDialog.power_level = _mavlink_manager.pan_power;
        onMotor_pan_num_polesChanged:   panConfigDialog.poles_num   = _mavlink_manager.motor_pan_num_poles;
        onMotor_pan_dirChanged:         panConfigDialog.motor_dir   = _mavlink_manager.motor_pan_dir;
        onPan_ccw_limit_angleChanged:   panConfigDialog.min_value   = _mavlink_manager.pan_ccw_limit_angle;
        onPan_cw_limit_angleChanged:    panConfigDialog.max_value   = _mavlink_manager.pan_cw_limit_angle;
        onYaw_angleChanged:             panGauge.gauge_sensor_value = _mavlink_manager.yaw_angle;

        onRoll_powerChanged:            rollConfigDialog.power_level = _mavlink_manager.roll_power;
        onMotor_roll_num_polesChanged:  rollConfigDialog.poles_num   = _mavlink_manager.motor_roll_num_poles;
        onMotor_roll_dirChanged:        rollConfigDialog.motor_dir   = _mavlink_manager.motor_roll_dir;
        onRoll_up_limit_angleChanged:   rollConfigDialog.min_value   = _mavlink_manager.roll_up_limit_angle;
        onRoll_down_limit_angleChanged: rollConfigDialog.max_value   = _mavlink_manager.roll_down_limit_angle;
        onRoll_angleChanged:            rollGauge.gauge_sensor_value = _mavlink_manager.roll_angle;
    }


    /* function tilt_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function tilt_log(_message){
//        msg_log = "<font color=\"yellow\">" + _message+ "</font><br>";
        msg_log = _message + "\n"
    }
    /* function roll_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function roll_log(_message){
//        msg_log = "<font color=\"springgreen\">" + _message+ "</font><br>";
        msg_log = _message + "\n"
    }
    /* function pan_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function pan_log(_message){
//        msg_log = "<font color=\"deepskyblue\">" + _message+ "</font><br>";
        msg_log = _message + "\n"
    }
    /* function dialog_log(_message)
       @brief: put message to log
       @input: _message
       @output: msg_log in HTML format
      */
    function dialog_log(_message){
//        msg_log = "<font color=\"red\">" + _message+ "</font><br>";
        msg_log = _message + "\n"
    }
    function send_setpoint_control(){
        _mavlink_manager.send_control_command(tiltGauge.gauge_setpoint_angle, panGauge.gauge_setpoint_angle, rollGauge.gauge_setpoint_angle)
    }
}
