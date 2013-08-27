import QtQuick 2.0

// gauge
Item{
    id: gauge_container

    property int    gauge_width     : 330
    property int    gauge_height    : 330
    property double gauge_center_x  : gauge_width/2
    property double gauge_center_y  : gauge_height/2
    property double gauge_radius    : gauge_width - gauge_center_x
    property int    angle_precision : 1        // number after dot

    property double     gauge_setpoint_angle                : 0         // to control the gauge angle of camera
    property double     gauge_down_limit_set_angle          : 30
    property double     gauge_up_limit_set_angle            : -10
    property bool       gauge_down_limit_set_enabled        : false
    property bool       gauge_set_enabled                   : false
    property double     gauge_angle_delta                   : gaugeNeedleImage.rotation - gauge_setpoint_angle
    property double     gauge_old_angle_value               : 0
    property int        gauge_control_handler_no_of_clicks  : 0
    property bool       gauge_config_mode: false

    property string gauge_back                  : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
    property string gauge_needle                : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
    property string gauge_handle_pressed        : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_tilt_handle_selected.png"
    property string gauge_handle_normal         : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_tilt_setpoint_handle.png"
    property string down_limit_handle_normal    : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_roll_setpoint_handle.png"
    property string down_limit_handle_pressed   : "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_roll_handle_selected.png"

    property string  gauge_log_message: "Gauge Log"

    implicitWidth: gauge_width; implicitHeight: gauge_height
    anchors.left: parent.left; anchors.leftMargin: 0
    anchors.top: parent.top; anchors.topMargin: 0

    Image {
        id: gaugeBackImage
        anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter
        source: gauge_back
//        source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_back_tilt.png"  // enable for design UI only
    }
    Image {
        id: gaugeNeedleImage

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: gauge_needle
//        source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_needle_tilt.png" // enable for design UI only
        rotation: {
            if(gauge_config_mode == false){
                if(gauge_set_enabled) { return gauge_setpoint_angle;}
                else return _mavlink_manager.gauge_angle;
            } else if(gauge_set_enabled == true)
                    {return gauge_up_limit_set_angle;}
                else if(gauge_down_limit_set_enabled == true)
                        {return gauge_down_limit_set_angle;}
                    else {return _mavlink_manager.gauge_angle;}
        }
    }
    // text display current angle value, sensor angle value
    Text{
        id: gaugeAngleValueText
        width: 20
        height: 13
        color: "#00ffff"
        font.pixelSize: 20
        font.family: "Ubuntu"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        style: Text.Normal
        text: gaugeNeedleImage.rotation.toFixed(angle_precision)
    }
    // display different value from setpoint
    Text{
        id: gaugeAngleDeltaText
        width: 20
        height: 13
        color: "#ff0000"
        font.pixelSize: 12
        font.family: "Segoe UI Symbol"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: gaugeAngleValueText.bottom
        anchors.topMargin: 35
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: gauge_angle_delta.toFixed(angle_precision)
//                        text: "-180.0"
    }
    Rectangle{
        id: gaugeAngleDeltaNumDisplay
        color: "#00000000"
        height: 15
        width: 50
        radius: 4
        border.width: 2
        border.color: "#06f7b3"
        anchors.verticalCenterOffset: 49
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    // Display different from setpoint, positive delta
    Rectangle{
        id: gaugePositiveAngleDelta
        anchors.bottom: parent.bottom
        anchors.leftMargin: 190
        anchors.left: parent.left
        rotation: 90
        transformOrigin: Item.BottomLeft
        color: "#6429f704"

        anchors.bottomMargin: 122
        width: 10
//            height: 50
        height:  gauge_angle_delta >= 0 ? gauge_angle_delta:0

    }
    // Display different from setpoint, negative delta
    Rectangle{
        id: gaugeNegativeAngleDelta

        anchors.rightMargin: 190
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        rotation: -90
        transformOrigin: Item.BottomRight
        color: "#6429f704"
        anchors.bottomMargin: 122
        width: 10
//            height: 20
        height: gauge_angle_delta <= 0 ? -gauge_angle_delta:0
    }
    Item{
        id: gaugeControlItem
        anchors.fill: parent
        rotation: gauge_config_mode? gauge_up_limit_set_angle : gauge_setpoint_angle
        Image {
            id: gaugeHandlePressedImage
            anchors.right: gaugeControlHandleImage.right
            anchors.rightMargin: 2
            anchors.verticalCenter: gaugeControlHandleImage.verticalCenter
            source: gauge_handle_pressed
//            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_tilt_handle_selected.png"
//                            source: "../images/gauges/gStabiUI_3.2_tilt_handle_selected.png"
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: gauge_handle_normal
//            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_tilt_setpoint_handle.png"
//                            source: "../images/gauges/gStabiUI_3.2_tilt_setpoint_handle.png" //enable for design UI only

        }
    }
    // This item will be use to set range limit accompany with gaugeControlItem
    Item{
        id: gaugeDownLimitSetItem
        width: 330; height: 165
        anchors.horizontalCenter: parent.horizontalCenter
        transformOrigin: Item.Top
        anchors.bottom: parent.bottom; anchors.bottomMargin: 0
        rotation: gauge_down_limit_set_angle
        Image {
            id: gaugeDownRangeHandleSelectedImage
            anchors.verticalCenter: gaugeDownRangeSelectHandlerImage.verticalCenter
            anchors.right: gaugeDownRangeSelectHandlerImage.right
            source: down_limit_handle_pressed
//            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_roll_handle_selected.png"  // to get different color from roll
//                            source: "../images/gauges/gStabiUI_3.2_roll_handle_selected.png"
            state: "normal"
            states:[
                State {
                    name: "focus"
                    PropertyChanges {target: gaugeDownRangeHandleSelectedImage; opacity: 1; }
                }
                ,State {
                    name: "normal"
                    PropertyChanges {target: gaugeDownRangeHandleSelectedImage; opacity: 0; }
                }
            ]
            transitions: [ Transition {
                    from: "focus"
                    to:   "normal"
                    ParallelAnimation{
                        NumberAnimation { target: gaugeDownRangeHandleSelectedImage; property: "opacity"; duration: 200;  }
                        SequentialAnimation{
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: gaugeDownRangeHandleSelectedImage; properties: "scale"; to: 0.5; duration: 100;}
                        }
                    }
                },
                Transition{
                    from: "normal"
                    to: "focus"
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
            anchors.horizontalCenterOffset: 0
            anchors.top: parent.top
            anchors.topMargin: -20
            anchors.horizontalCenter: parent.horizontalCenter
            source: down_limit_handle_normal
//            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_roll_setpoint_handle.png"
//                            source: "../images/gauges/gStabiUI_3.2_roll_setpoint_handle.png" //enable for design UI only

        }
    }
    MouseArea{
        id: gaugeDownLimitSetMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged:
        {
            calc_rotate_angle_gauge(mouse.x, mouse.y)
        }
        onEntered:
        {
            gauge_log_message = ("<b><i>gauge axis of gStabi</i></b>")
        }
        onClicked: {
            gauge_control_handler_no_of_clicks = gauge_control_handler_no_of_clicks + 1
            if(gauge_control_handler_no_of_clicks == 1){
                gauge_down_limit_set_enabled = true;
                gauge_log_message = ("<b>Start to set gauge down angle limit for the camera</b>")
//                    gaugeDownRangeHandleSelectedImage.visible = true
                gaugeDownRangeHandleSelectedImage.state = "focus"
            }
            else if(gauge_control_handler_no_of_clicks == 2){
                gauge_down_limit_set_enabled = false;
                gauge_log("<b>Stop setting gauge down angle limit for the camera</b>");
//                    gaugeDownRangeHandleSelectedImage.visible = false
                gaugeDownRangeHandleSelectedImage.state = "normal"
                gauge_control_handler_no_of_clicks = 0;
            }
        }
    }
    MouseArea{
        id: gaugeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged:
        {
            calc_rotate_angle_gauge(mouse.x, mouse.y)
        }
        onEntered:
        {
            gauge_log_message = ("<b><i>gauge axis of gStabi</i></b>")
        }
        onClicked: {
            gauge_control_handler_no_of_clicks = gauge_control_handler_no_of_clicks + 1
            if(gauge_control_handler_no_of_clicks == 1){
                gauge_set_enabled = true;
//                    gaugeHandlePressedImage.visible = true
                gaugeHandlePressedImage.state = "focus"
                if(gauge_config_mode) gauge_log_message = ("<b>Start to set gauge up angle limit for the camera</b>")
                else gauge_log_message = ("<b>Start to gauge camera</b>")

            }
            else if(gauge_control_handler_no_of_clicks == 2){
                gauge_set_enabled = false;
//                    gaugeHandlePressedImage.visible = false
                gaugeHandlePressedImage.state = "normal"
                gauge_control_handler_no_of_clicks = 0;
                if(gauge_config_mode) gauge_log_message = ("<b>Stop setting gauge up angle limit for the camera</b>")
                else gauge_log_message = ("<b>Stop gaugeing camera</b>");
            }
        }
    }
}   // end of gauge Gauge
