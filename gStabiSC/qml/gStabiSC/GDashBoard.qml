import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "Components"
//import "../../../javascript/storage.js" as Storage
/*
  All angles value unit are Degree
  */
Item {
    id: root
    property int gauge_width: 310
    property int gauge_height: 310
    property string msg_log : "" // log the message to display on Console
    property bool   dashboard_config_mode : false   // if false: dashbord mode; if true: config mode

    implicitWidth: 930; implicitHeight: 310
    GGauge{
        id: tiltGauge
        width: gauge_width; height: gauge_height
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        gauge_tilte: "Tilt"
        gauge_type: 1; gauge_offset: 0 ; axis_direcion: -1
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_green_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_green_handle.png"
        gauge_config_mode: dashboard_config_mode
        onEntered: tilt_log("Tilt axis of the system")
        onGauge_up_limit_set_angleChanged: _mavlink_manager.tilt_up_limit_angle = gauge_up_limit_set_angle;
        onGauge_down_limit_set_angleChanged:  _mavlink_manager.tilt_down_limit_angle = gauge_down_limit_set_angle;
        onGauge_setpoint_angleChanged: send_setpoint_control();
        onGauge_log_messageChanged: dialog_log(gauge_log_message)
    }
    GGauge{
        id: panGauge
        width: gauge_width; height: gauge_height
        anchors.verticalCenter: parent.verticalCenter
        gauge_tilte: "Pan"
        gauge_type: 2; gauge_offset: 90
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.horizontalCenter: parent.horizontalCenter
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_pan.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_pan.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_blue_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_blue_handle.png"
        gauge_config_mode: dashboard_config_mode
//        up_limit_pie_color: "green"
//        down_limit_pie_color: "chartreuse"
        onEntered: pan_log("Pan axis of the system")
        onGauge_down_limit_set_angleChanged: _mavlink_manager.pan_cw_limit_angle = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   _mavlink_manager.pan_ccw_limit_angle = gauge_up_limit_set_angle
        onGauge_setpoint_angleChanged: send_setpoint_control();
        onGauge_log_messageChanged: dialog_log(gauge_log_message)
    }
    GGauge{
        id: rollGauge
        width: gauge_width; height: gauge_height
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        gauge_tilte: "Roll"
        gauge_type: 3; gauge_offset: 0
//        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_roll.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_roll.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_cyan_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_cyan_handle.png"
        gauge_config_mode: dashboard_config_mode
        onEntered: roll_log("Roll axis of the system")
        onGauge_down_limit_set_angleChanged: _mavlink_manager.roll_down_limit_angle = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   _mavlink_manager.roll_up_limit_angle = gauge_up_limit_set_angle
        onGauge_setpoint_angleChanged: send_setpoint_control();
        onGauge_log_messageChanged: dialog_log(gauge_log_message)
    }
    states: [
        State {name: "Dashboard" },
        State {name: "Config"    }
    ]

    Connections{
        target: _mavlink_manager

        onTilt_up_limit_angleChanged:   tiltGauge.gauge_up_limit_set_angle   = _mavlink_manager.tilt_up_limit_angle;
        onTilt_down_limit_angleChanged: tiltGauge.gauge_down_limit_set_angle = _mavlink_manager.tilt_down_limit_angle;
        onPitch_angleChanged:           tiltGauge.gauge_sensor_value         = _mavlink_manager.pitch_angle;

        onPan_ccw_limit_angleChanged:   panGauge.gauge_up_limit_set_angle   = _mavlink_manager.pan_ccw_limit_angle;
        onPan_cw_limit_angleChanged:    panGauge.gauge_down_limit_set_angle = _mavlink_manager.pan_cw_limit_angle;
        onYaw_angleChanged:             panGauge.gauge_sensor_value         = _mavlink_manager.yaw_angle;

        onRoll_up_limit_angleChanged:   rollGauge.gauge_up_limit_set_angle   = _mavlink_manager.roll_up_limit_angle;
        onRoll_down_limit_angleChanged: rollGauge.gauge_down_limit_set_angle = _mavlink_manager.roll_down_limit_angle;
        onRoll_angleChanged:            rollGauge.gauge_sensor_value         = _mavlink_manager.roll_angle;
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
