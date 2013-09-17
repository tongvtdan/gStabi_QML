import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "Components"
//import "../../../javascript/storage.js" as Storage
/*
  All angles value unit are Degree
  */
Item {
    id: root
    property int    gauge_width     : 220
    property int    gauge_height    : 220
    property double gauge_center_x  : gauge_width/2
    property double gauge_center_y  : gauge_height/2
    property double gauge_radius    : gauge_width - gauge_center_x
    property int    angle_precision : 1        // number after dot

    property bool   gauge_config_mode    : false   // to display control handle
    property bool   gauge_control_enabled: false

    width: 700; height: 220
    GGauge{
        id: tiltGauge
        gauge_tilte: "Tilt"
        gauge_type: 1; gauge_offset: 0 ; axis_direcion: 1

        anchors.left: parent.left; anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.3_back_tilt.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.3_needle_tilt.png"
        gauge_handle_normal:  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_green_handle.png"
        gauge_handle_pressed:  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_green_handle.png"

        onEntered: dialog_log("Tilt axis of the system")
        onGauge_up_limit_set_angleChanged: _mavlink_manager.tilt_up_limit_angle = gauge_up_limit_set_angle;
        onGauge_down_limit_set_angleChanged:  _mavlink_manager.tilt_down_limit_angle = gauge_down_limit_set_angle;
        onGauge_setpoint_angleChanged: send_setpoint_control();
    }
    GGauge{
        id: panGauge
        gauge_tilte: "Pan"
        gauge_type: 2; gauge_offset: 90

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.3_back_pan.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.3_needle_pan.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_blue_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_blue_handle.png"

        onEntered: dialog_log("Pan axis of the system")
        onGauge_down_limit_set_angleChanged: _mavlink_manager.pan_cw_limit_angle = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   _mavlink_manager.pan_ccw_limit_angle = gauge_up_limit_set_angle
        onGauge_setpoint_angleChanged: send_setpoint_control();
    }
    GGauge{
        id: rollGauge
        gauge_tilte: "Roll"
        gauge_type: 3; gauge_offset: 0

        anchors.right: parent.right;     anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.3_back_roll.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.3_needle_roll.png"
        gauge_handle_normal: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_cyan_handle.png"
        gauge_handle_pressed: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_cyan_handle.png"

        onEntered: dialog_log("Roll axis of the system")
        onGauge_down_limit_set_angleChanged: _mavlink_manager.roll_down_limit_angle = gauge_down_limit_set_angle
        onGauge_up_limit_set_angleChanged:   _mavlink_manager.roll_up_limit_angle = gauge_up_limit_set_angle
        onGauge_setpoint_angleChanged: send_setpoint_control();
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



    function send_setpoint_control(){
        _mavlink_manager.send_control_command(tiltGauge.gauge_setpoint_angle, panGauge.gauge_setpoint_angle, rollGauge.gauge_setpoint_angle)
    }
}
