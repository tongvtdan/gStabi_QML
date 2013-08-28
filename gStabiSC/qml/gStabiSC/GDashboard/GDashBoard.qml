import QtQuick 2.0
//import QtQuick.Controls 1.0
//import QtQuick.Controls.Styles 1.0


import "../Components"
/*
  All angles value unit are Degree
  */
Item {
    id: root

    width: 990
    height: 340

    property int gauge_width: 330
    property int gauge_height: 330
    property double gauge_center_x: gauge_width/2
    property double gauge_center_y: gauge_height/2
    property double gauge_radius: gauge_width - gauge_center_x
    property int  angle_precision: 1        // number after dot

//    property double     tilt_setpoint_angle         : 0         // to control the tilt angle of camera
//    property double     tilt_down_limit_set_angle   : 30
//    property double     tilt_up_limit_set_angle     : -10
//    property bool       tilt_down_limit_set_enabled : false
//    property bool       tilt_set_enabled            : false
//    property double tilt_angle_delta        : tiltNeedleImage.rotation - tilt_setpoint_angle
//    property double tilt_old_angle_value    : 0
//    property int    tilt_control_handler_no_of_clicks: 0

    property double roll_setpoint_angle     : 0
    property bool   roll_set_enabled        : false
    property double roll_angle_delta        : rollNeedleImage.rotation - roll_setpoint_angle
    property int    roll_control_handler_no_of_clicks: 0

//    property double pan_setpoint_angle      : 0
//    property bool   pan_set_enabled         : false
//    property double pan_angle_delta         : panNeedleImage.rotation - panControlHandleImage.rotation
//    property double pan_offset_display      : -90
//    property int    pan_control_handler_no_of_clicks: 0

    property string msg_log : "" // log the message to display on Console
    property bool   dashboard_config_mode : false   // if false: dashbord mode; if true: config mode

    state: "Dashboard"

    BorderImage {
        id: dashboardPanelImage
        source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_dashboard_panel.png"
        opacity: 0.5
        anchors.fill: parent
    }
    GGauge{
        id: tiltGauge
        gauge_type: 1
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.left: parent.left; anchors.leftMargin: 0
        anchors.top: parent.top; anchors.topMargin: 0
        gauge_config_mode: dashboard_config_mode
        gauge_offset: 0
        gauge_sensor_value: _mavlink_manager.tilt_angle
        onGauge_log_messageChanged: tilt_log(gauge_log_message)
    }
    GGauge{
        id: panGauge
        gauge_type: 2; gauge_offset: 90
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.top: parent.top; anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_pan.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_pan.png"
        gauge_config_mode: dashboard_config_mode
        gauge_sensor_value: _mavlink_manager.yaw_angle
        onGauge_log_messageChanged: pan_log(gauge_log_message)
    }
    GGauge{
        id: rollGauge
        gauge_type: 3; gauge_offset: 0
        gauge_width: root.gauge_width; gauge_height:root.gauge_height
        anchors.top: parent.top; anchors.topMargin: 0
        anchors.right : parent.right; anchors.rightMargin: 0
        gauge_back  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_roll.png"
        gauge_needle: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_roll.png"
        gauge_config_mode: dashboard_config_mode
        gauge_sensor_value: _mavlink_manager.roll_angle
        onGauge_log_messageChanged: roll_log(gauge_log_message)

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
    GConfigDialog{
        id: tiltConfigDialog
        anchors.horizontalCenter: tiltGauge.horizontalCenter
        anchors.top: tiltGauge.bottom ; anchors.topMargin: -20
        opacity: 0
    }
    GConfigDialog{
        id: panConfigDialog
        anchors.horizontalCenter: panGauge.horizontalCenter
        anchors.top: panGauge.bottom ; anchors.topMargin: -20
        opacity: 0
    }
    GConfigDialog{
        id: rollConfigDialog
        anchors.horizontalCenter: rollGauge.horizontalCenter
        anchors.top: rollGauge.bottom ; anchors.topMargin: -20
        opacity: 0
    }

    states: [
        State {
            name: "Dashboard"
            PropertyChanges { target: modeSelectionButton; text: "Config >>"}
            PropertyChanges { target: writeConfigParamsToMCU; visible: false }
            PropertyChanges { target: readConfigParamsFromMCU; visible: false }
//            PropertyChanges { target: tiltDownLimitSetMouseArea; visible: false}
//            PropertyChanges { target: tiltDownLimitSetItem; visible: false}
            PropertyChanges { target: tiltConfigDialog; state  : "hideDialog"}
            PropertyChanges { target: panConfigDialog;  state  : "hideDialog"}
            PropertyChanges { target: rollConfigDialog; state  : "hideDialog"}

        },
        State {
            name: "Config"
            PropertyChanges { target: modeSelectionButton; text: "<< Dashboard" }
            PropertyChanges { target: writeConfigParamsToMCU; visible: true }
            PropertyChanges { target: readConfigParamsFromMCU; visible: true }
//            PropertyChanges { target: tiltDownLimitSetMouseArea; visible: true}

//            PropertyChanges { target: tiltGauge; gauge_control_area_height: 165 ;  }
//            PropertyChanges { target: tiltDownLimitSetMouseArea; width: 330; height: 165 ; anchors.bottomMargin: 0 }
//            PropertyChanges { target: tiltDownLimitSetItem; visible: true}
            PropertyChanges { target: tiltConfigDialog; state: "showDialog"}
            PropertyChanges { target: panConfigDialog;  state: "showDialog"}
            PropertyChanges { target: rollConfigDialog; state: "showDialog"}
        }
    ]
    onStateChanged: {
        if(dashboard_config_mode) {tilt_log("Change to Config Mode")} else {tilt_log("Return to Dashboard mode")}
    }


    /* function calc_rotate_angle_roll(_x, _y)
       @brief: get the angle to rotate the setpoint handler
       @input: (_x, _y) = (mouse.x, mouse.y)
       @output: angle for setpoint handle image to rotate
      */
    function calc_rotate_angle_roll(_x, _y){
        var rot_angle_deg;
        var distanceFromCenterToPressedPoint = Math.sqrt((_x - gauge_center_x)*(_x - gauge_center_x) + (_y - gauge_center_y)*(_y - gauge_center_y));
        if((distanceFromCenterToPressedPoint >= 0.7*gauge_radius) && (distanceFromCenterToPressedPoint <= gauge_radius))
        {
            var minDistanceFromPress = 32767;
            for(var angle = 0; angle < 360; angle++ ){
                var x_angle = gauge_center_x + gauge_radius*Math.cos(angle*Math.PI/180);
                var y_angle = gauge_center_y + gauge_radius*Math.sin(angle*Math.PI/180);
                var distanceFromPress = Math.sqrt((x_angle - _x)*(x_angle - _x) + (y_angle - _y)*(y_angle - _y));
                if(distanceFromPress < minDistanceFromPress){
                    minDistanceFromPress = distanceFromPress;
                    rot_angle_deg = angle;
                }
            }
        }
        else {
            rot_angle_deg = -360;
        }
        if(roll_set_enabled) {
            if(rot_angle_deg !== -360) {
                if(rot_angle_deg > 180){ rot_angle_deg = rot_angle_deg - 360}
                roll_setpoint_angle = rot_angle_deg;
                roll_log("Rolling camera to angle: " + roll_setpoint_angle);
            }
        }
    } // end of function
    /* function calc_rotate_angle_pan(_x, _y)
       @brief: get the angle to rotate the setpoint handler for pan axis only
       @input: (_x, _y) = (mouse.x, mouse.y)
       @output: angle for setpoint handle image to rotate
      */
    /*
    function calc_rotate_angle_pan(_x, _y){
        var rot_angle_deg;
        var distanceFromCenterToPressedPoint = Math.sqrt((_x - gauge_center_x)*(_x - gauge_center_x) + (_y - gauge_center_y)*(_y - gauge_center_y));
        if((distanceFromCenterToPressedPoint >= 0.7*gauge_radius) && (distanceFromCenterToPressedPoint <= gauge_radius))
        {
            var minDistanceFromPress = 32767;
            for(var angle = 0; angle < 360; angle++ ){
                var x_angle = gauge_center_x + gauge_radius*Math.cos(angle*Math.PI/180);
                var y_angle = gauge_center_y + gauge_radius*Math.sin(angle*Math.PI/180);
                var distanceFromPress = Math.sqrt((x_angle - _x)*(x_angle - _x) + (y_angle - _y)*(y_angle - _y));
                if(distanceFromPress < minDistanceFromPress){
                    minDistanceFromPress = distanceFromPress;
                    rot_angle_deg = angle+90;
                }
            }
        }
        else {
            rot_angle_deg = -360;
        }
//        return rot_angle_deg;
        if(pan_set_enabled)
//        var rot = calc_rotate_angle_pan(mouse.x, mouse.y);
        if(rot_angle_deg !== -360) {
            if(rot_angle_deg > 180){ rot_angle_deg = rot_angle_deg - 360;}
            pan_setpoint_angle = rot_angle_deg;
            pan_log("Panning camera to angle: " + pan_setpoint_angle);
        }
    } // end of function
    */
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
