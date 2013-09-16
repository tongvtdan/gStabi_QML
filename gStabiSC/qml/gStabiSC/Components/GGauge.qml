import QtQuick 2.0
import Charts 1.0

/*
 Gauge Component
 Usage:
  - Replace image source file accordingly.
  - Set gauge_width, gauge_height if change
  - Change gauge_offset for Gauge type, e.g.: Pan will has gauge_offset = 90 to rotate some visual element
*/
Item{
    id: gaugeContainer
//[!] Variables can be change in using code
//    property string dialog_log_message           : "Gauge Log"
    property int    gauge_width                 : 220
    property int    gauge_height                : 220
//    property bool   gauge_config_mode           : false
    property double gauge_sensor_value          : 0
    property int    gauge_type                  : 1      // 1: Tilt, 2: pan; 3: roll
    property string gauge_tilte                 : "Tilt"
    property int    gauge_offset                : 0
    property string gauge_back                  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
    property string gauge_needle                : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
    property string gauge_handle_normal         : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_green_handle.png"
    property string gauge_handle_pressed        : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_green_handle.png"
    property string down_limit_handle_normal    : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_normal_red_handle.png"
    property string down_limit_handle_pressed   : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_pressed_red_handle.png"
    //[!] Enable these images source for design UI
//        property string gauge_back                  : "../images/gauges/gStabiUI_3.2_back_tilt.png"
//        property string gauge_needle                : "../images/gauges/gStabiUI_3.2_needle_tilt.png"
//        property string gauge_handle_normal         : "../images/gauges/gStabiUI_3.2_normal_green_handle.png"
//        property string gauge_handle_pressed        : "../images/gauges/gStabiUI_3.2_pressed_green_handle.png"
//        property string down_limit_handle_normal    : "../images/gauges/gStabiUI_3.2_normal_red_handle.png"
//        property string down_limit_handle_pressed   : "../images/gauges/gStabiUI_3.2_pressed_red_handle.png"
    //[!]
// [!]
    property double gauge_center_x  : gauge_width/2
    property double gauge_center_y  : gauge_height/2
    property double gauge_radius    : gauge_width - gauge_center_x
    property int    angle_precision : 1        // number after dot

    property double     gauge_setpoint_angle                : 0         // to control the gauge angle of camera
    property double     gauge_down_limit_set_angle          : 15
    property double     gauge_up_limit_set_angle            : -10
    property bool       gauge_down_limit_set_enabled        : false
    property bool       gauge_set_enabled                   : false
    property double     gauge_angle_delta                   : gaugeNeedleImage.rotation - gauge_setpoint_angle
    property int        gauge_control_handler_no_of_clicks  : 0
    property int        gauge_down_limit_handle_no_of_clicks: 0

    property bool  select_handle2: false
    property bool  select_handle1: false

    property bool out_of_range: false
    property double   scale_ratio: 0.8          // use to scale element inside the gauge
    property string  up_limit_pie_color     : "blue"
    property string  down_limit_pie_color   : "cyan"
    property double  range_limit_opacity: 0.2
    property int axis_direcion: 1   // 1: normal, -1 reverse, use with sensor_value
    property bool gauge_handle_enabled: false

    signal clicked
    signal entered
    signal exited
    signal pressed
    signal released

    implicitWidth: gauge_width; implicitHeight: gauge_height
    Image {
        id: gaugeBackImage
        anchors.fill: parent
        source: gauge_back
        asynchronous: true
    }
    Image {
        id: gaugeNeedleImage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: gauge_needle
        asynchronous: true

        rotation: get_rotation_angle();
    }
    GTextStyled{
        id: outOfRangeLabel
        width: 20; height: 13
        color: "#ff0000"

//        font.pixelSize: 20 ; font.family:"Segoe UI" ; font.bold: true
        anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter ; horizontalAlignment: Text.AlignHCenter
//        style: Text.Normal
        text: "Out of range"
        anchors.verticalCenterOffset: -50
        visible: out_of_range
    }

    // text display current angle value, sensor angle value
    GTextStyled{
        id: gaugeAngleValueText
        width: 20; height: 13
        color: "#00ffff"
//        font.pixelSize: 20 ; font.family:"Segoe UI" ; font.bold: true
        anchors.centerIn: parent
        verticalAlignment: Text.AlignVCenter ; horizontalAlignment: Text.AlignHCenter
//        style: Text.Normal
        text: gaugeNeedleImage.rotation.toFixed(angle_precision)
    }
    // display different value from setpoint
    GTextStyled{
        id: gaugeAngleDeltaText
        width: 20; height: 13
        color: "#ff0000"
        font.pixelSize: 12;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: gaugeAngleValueText.bottom; anchors.topMargin: 35
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        text: gauge_angle_delta.toFixed(angle_precision)
    }
    Rectangle{
        id: gaugeAngleDeltaNumDisplay
        color: "#00000000"
        height: 15 ; width: 50; radius: 4
        border.width: 2 ; border.color: "#06f7b3"
        anchors.centerIn: parent ;anchors.verticalCenterOffset: 49
    }
    // Display different from setpoint, positive delta
    Rectangle{
        id: gaugePositiveAngleDelta
        rotation: 0
        transformOrigin: Item.Left
        color: "#6429f704"
        anchors.left: gaugeAngleDeltaNumDisplay.right
        anchors.leftMargin: 0
        anchors.verticalCenter: gaugeAngleDeltaNumDisplay.verticalCenter
        width:  {
            if(gauge_control_enabled) {return gauge_angle_delta >= 0 ? (gauge_angle_delta/5):0}
            else return 0;
        }
        height: 10
    }
    // Display different from setpoint, negative delta
    Rectangle{
        id: gaugeNegativeAngleDelta
        rotation: 0
        transformOrigin: Item.Right
        color: "#6429f704"
        anchors.right: gaugeAngleDeltaNumDisplay.left
        anchors.rightMargin: 0
        anchors.verticalCenter: gaugeAngleDeltaNumDisplay.verticalCenter
        width:  {
            if(gauge_control_enabled) {return gauge_angle_delta <= 0 ? (0-gauge_angle_delta/5):0}
            else return 0;
        }
        height: 10
    }
    Item{
        id: gaugeControlItem
        anchors.fill: parent
        rotation: {
            if(!out_of_range){
                return gauge_config_mode ? gauge_up_limit_set_angle : gauge_setpoint_angle - gauge_offset
            }
        }
        Image {
            id: gaugeHandlePressedImage
            asynchronous: true
            anchors.right: parent.right; anchors.rightMargin: -20
            anchors.verticalCenter: parent.verticalCenter
            source: gauge_handle_pressed
            state: "normal"
            states:[
                State {
                    name: "focus"
                    PropertyChanges {target: gaugeHandlePressedImage; opacity: 1; }
                }
                ,State {
                    name: "normal"
                    PropertyChanges {target: gaugeHandlePressedImage; opacity: 0; }
                }
            ]
            transitions: [ Transition {
                    from: "focus"
                    to:   "normal"
                    ParallelAnimation{
                        NumberAnimation { target: gaugeHandlePressedImage; property: "opacity"; duration: 200;  }
                        SequentialAnimation{
                            NumberAnimation{ target: gaugeHandlePressedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: gaugeHandlePressedImage; properties: "scale"; to: 0.5; duration: 100;}
                        }
                    }
                },
                Transition{
                    from: "normal"
                    to: "focus"
                    ParallelAnimation{
                        NumberAnimation { target: gaugeHandlePressedImage; property: "opacity"; duration: 300;  }
                        SequentialAnimation{
                            NumberAnimation{ target: gaugeHandlePressedImage; properties: "scale"; to: 1.0; duration: 100;}
                            NumberAnimation{ target: gaugeHandlePressedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: gaugeHandlePressedImage; properties: "scale"; to: 1; duration: 100;}

                        }
                    }
                }
            ]
        }
        Image{
            id: gaugeControlHandleImage
            asynchronous: true
            rotation: 0
            anchors.right: parent.right; anchors.rightMargin: -20
            anchors.verticalCenter: parent.verticalCenter
            source: gauge_handle_normal
        }
    }
    // This item will be use to set range limit accompany with gaugeControlItem
    Item{
        id: gaugeDownLimitSetItem
        anchors.fill: parent
        rotation: {if(!out_of_range) return (gauge_down_limit_set_angle - gauge_offset)}
        Image {
            id: gaugeDownRangeHandleSelectedImage
            asynchronous: true
            anchors.right: parent.right
            anchors.rightMargin: -20
            anchors.verticalCenter: parent.verticalCenter
            source: down_limit_handle_pressed
            state: "limit_normal"
            states:[
                State {
                    name: "limit_focus"
                    PropertyChanges {target: gaugeDownRangeHandleSelectedImage; opacity: 1; }
                }
                ,State {
                    name: "limit_normal"
                    PropertyChanges {target: gaugeDownRangeHandleSelectedImage; opacity: 0; }
                }
            ]
            transitions: [ Transition {
                    from: "limit_focus"
                    to:   "limit_normal"
                    ParallelAnimation{
                        NumberAnimation { target: gaugeDownRangeHandleSelectedImage; property: "opacity"; duration: 200;  }
                        SequentialAnimation{
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 0.5; duration: 100;}
                        }
                    }
                },
                Transition{
                    from: "limit_normal"
                    to: "limit_focus"
                    ParallelAnimation{
                        NumberAnimation { target: gaugeDownRangeHandleSelectedImage; property: "opacity"; duration: 300;  }
                        SequentialAnimation{
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 1.0; duration: 100;}
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 1; duration: 100;}

                        }
                    }
                }
            ]
        }
        Image{
            id: gaugeDownRangeSelectHandlerImage
            asynchronous: true
            anchors.right: parent.right
            anchors.rightMargin: -20
            anchors.verticalCenter: parent.verticalCenter
            source: down_limit_handle_normal
        }
    }
    Item {
        id: rangeSelectedPies
        width: scale_ratio*gauge_width; height: scale_ratio*gauge_height; // smaller than parent
        anchors.centerIn: parent
        z:-1
        opacity: range_limit_opacity
        PieSlice {
            id: pieDown
            anchors.fill: parent
            color: down_limit_pie_color
            fromAngle: gauge_offset;
            angleSpan: -gauge_down_limit_set_angle
            onAngleSpanChanged: update()
        }
        PieSlice {
            id: pieUp
            anchors.fill: parent
            color: up_limit_pie_color
            fromAngle: gauge_offset;
            angleSpan: -gauge_up_limit_set_angle
            onAngleSpanChanged: update()

        }
    }
    MouseArea{
        id: gaugeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged:  calc_rotate_angle_gauge(mouse.x, mouse.y)
        onEntered: gaugeContainer.entered()
        onExited: gaugeContainer.exited()
        onPressed: {
            gaugeContainer.pressed()
            if(select_handle1){
                gauge_set_enabled = true;
                gaugeHandlePressedImage.state = "focus"
                if(gauge_config_mode) dialog_log(gauge_tilte + ": Start to set up angle limit for the camera")
                else dialog_log(gauge_tilte + ": Start to move camera")
            } else if(select_handle2){
                gauge_down_limit_set_enabled = true;
                dialog_log(gauge_tilte + ": Start to set down angle limit for the camera")
                gaugeDownRangeHandleSelectedImage.state = "limit_focus"
            }
        } // end of onPressed
        onReleased:{
            gaugeContainer.released()
            if(select_handle1){
                gauge_set_enabled = false;
                gaugeHandlePressedImage.state = "normal"
                if(gauge_config_mode) dialog_log(gauge_tilte + ": Stop setting up angle limit for the camera")
                else dialog_log(gauge_tilte + ": Stop moving camera");
            } else if(select_handle2){
                gauge_down_limit_set_enabled = false;
                dialog_log(gauge_tilte + ": Stop setting down angle limit for the camera");
                gaugeDownRangeHandleSelectedImage.state = "limit_normal"
            }
        }  // end of onReleased
    }
    states: [
        State{
            name: "dash"
            when: !gauge_config_mode && !gauge_control_enabled
            PropertyChanges { target: gaugeDownLimitSetItem; visible: false; enabled: false}
            PropertyChanges {target: gaugeControlItem; visible: false; enabled: false }

        }
        ,State{
            name: "config"
            when: gauge_config_mode
            PropertyChanges { target: gaugeDownLimitSetItem; visible: true; enabled: true}
            PropertyChanges {target: gaugeControlItem; visible: true; enabled: true}
        }
        ,State{
            name: "control"
            when: gauge_control_enabled
            PropertyChanges {target: gaugeControlItem; visible: true; enabled: true}
            PropertyChanges { target: gaugeDownLimitSetItem; visible: false; enabled: false}
        }

    ]

    /* function calc_rotate_angle_gauge(_x, _y)
       @brief: get the angle to rotate the setpoint handler
       @input: (_x, _y) = (mouse.x, mouse.y)
       @output: angle for setpoint handle image to rotate
       @note:   interact area is a donus with inside radius = 0.7 base circle radius, outside radius = base circle radius
      */
    function calc_rotate_angle_gauge(_x, _y){
        var rot_angle_deg;
        var distanceFromCenterToPressedPoint = Math.sqrt((_x - gauge_center_x)*(_x - gauge_center_x) + (_y - gauge_center_y)*(_y - gauge_center_y));
        if((distanceFromCenterToPressedPoint >= 0.7*gauge_radius) && (distanceFromCenterToPressedPoint <= 1.3*gauge_radius))
        {
            var minDistanceFromPress = 32767;
            for(var angle = 0; angle < 360; angle++ ){
                var x_angle = gauge_center_x + gauge_radius*Math.cos(angle*Math.PI/180);
                var y_angle = gauge_center_y + gauge_radius*Math.sin(angle*Math.PI/180);
                var distanceFromPress = Math.sqrt((x_angle - _x)*(x_angle - _x) + (y_angle - _y)*(y_angle - _y));
                if(distanceFromPress < minDistanceFromPress){
                    minDistanceFromPress = distanceFromPress;
                    rot_angle_deg = angle + gauge_offset;      // get a rotation angle
                }
            }
        }
        else {
            rot_angle_deg = -360;
        }
        if(rot_angle_deg > 180){ rot_angle_deg = rot_angle_deg - 360} // convert angle > 180 to negative angle, e.g: 190 --> -10
        if(rot_angle_deg !== -360){
            var diff_angle_1 = Math.abs(gauge_up_limit_set_angle - rot_angle_deg) // calc the different angle between current angle and previous position
            var diff_angle_2 = Math.abs(gauge_down_limit_set_angle - rot_angle_deg)
            if(gauge_config_mode){ // in Config Mode, use both Up (use Control handle) and Down limit
                if(diff_angle_1 <= diff_angle_2) {      // select the handle to interact
                    select_handle1 = true; select_handle2 = false;//console.log("Select 1")
                } else {
                    select_handle2 = true; select_handle1 = false; //console.log("Select 2");
                }
                if(gauge_set_enabled) {
                    gauge_up_limit_set_angle = rot_angle_deg;
                    dialog_log(gauge_tilte + ": Setting up limit to angle: " + gauge_up_limit_set_angle);
                }
                if(gauge_down_limit_set_enabled){
                    gauge_down_limit_set_angle = rot_angle_deg;
                    dialog_log(gauge_tilte + ": Setting down limit to angle: " + gauge_down_limit_set_angle);
                }
            }
            else{       // in Dashboard Mode
                if(gauge_control_enabled){ select_handle1 = true}
                else {select_handle1 = false}
                select_handle2 = false
                if(gauge_set_enabled) {
                    gauge_setpoint_angle = rot_angle_deg;
                    dialog_log("Rotating " + gauge_tilte + " axis of the camera to angle: " + gauge_setpoint_angle);
                }
            }
        }
    } // end of function
    function get_rotation_angle()
    {
        var rot_angle;
        if(gauge_config_mode) // dashboard change to Config mode
        {
//             user change rotate up limit,
//             in Config mode, this handle is up travel limit setting handle
//             in Control mode, this handle is Rotate setpoint
            if(gauge_set_enabled)
            {
                return gauge_up_limit_set_angle;
            } else
            if(gauge_down_limit_set_enabled)      // down limit setting
            {
                return gauge_down_limit_set_angle;
            } else {
                rot_angle = axis_direcion*gauge_sensor_value;      // no travel limit handle change, return the sensor reading value
                check_sensor_value_is_out_of_range(rot_angle);
                return rot_angle;
            }
        } else // in Dashboard mode
        {
            if(!gauge_set_enabled)  // will rotate based on sensor value
            {
                rot_angle = axis_direcion*gauge_sensor_value;
                check_sensor_value_is_out_of_range(rot_angle);
                return rot_angle;
            }else
            {
                rot_angle = gauge_setpoint_angle;
                if(rot_angle >= gauge_down_limit_set_angle) { // check whether the setpoint is in travel range
                    dialog_log(gauge_tilte + ": Reach max travel limit");
                    out_of_range = true;
                    return gauge_down_limit_set_angle;
                } else if(rot_angle <=gauge_up_limit_set_angle){
                    dialog_log(gauge_tilte + ": Reach min travel limit");
                    out_of_range = true;
                    return gauge_up_limit_set_angle;
                } else {                    // the setpoint is in travel limit
                    out_of_range = false;
                    return rot_angle;
                }
            }
        }
    } // end of function
    function check_sensor_value_is_out_of_range(_angle_value)
    {
        if(_angle_value >= gauge_down_limit_set_angle) {
            dialog_log(gauge_tilte + ": Reach max travel limit");
            out_of_range = true;
        } else if(_angle_value <=gauge_up_limit_set_angle){
            dialog_log(gauge_tilte + ": Reach min travel limit");
            out_of_range = true;
        } else {
            out_of_range = false;
        }
    }
//    function dialog_log(_message){
//        dialog_log_message = _message+ "\n";
//    }

}   // end of gauge Gauge
