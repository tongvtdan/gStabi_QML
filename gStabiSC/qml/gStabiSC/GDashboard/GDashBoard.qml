import QtQuick 2.1
//import QtQuick.Controls 1.0

Item {
    id: dashboardRoot

    width: 960
    height: 340

    property int gauge_width: 330
    property int gauge_height: 330
    property double gauge_center_x: gauge_width/2
    property double gauge_center_y: gauge_height/2
    property double gauge_radius: gauge_width - gauge_center_x

    property int    tilt_setpoint_angle     : 0
    property bool   tilt_set_enabled        : false
    property double tilt_angle_delta        : tiltNeedleImage.rotation - tilt_setpoint_angle
    property int    tilt_control_handler_no_of_clicks: 0

    property int    roll_setpoint_angle     : 0
    property bool   roll_set_enabled        : false
    property double roll_angle_delta        : rollNeedleImage.rotation - roll_setpoint_angle
    property int    roll_control_handler_no_of_clicks: 0

    property int    pan_setpoint_angle      : 0
    property bool   pan_set_enabled         : false
    property double pan_angle_delta         : panNeedleImage.rotation - panControlHandleImage.rotation
    property double pan_offset_display      : -90
    property int    pan_control_handler_no_of_clicks: 0

    property string msg_log : "" // log the message to display on Console
    property int    hint_x  : 0
    property int    hint_y  : 0


    // tilt
    Item{
        id: tilt_gauge

        width: gauge_width
        height: gauge_height
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        Image {
            id: tiltBackImage

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_back_tilt.png"  // enable for design UI only
        }
        Image {
            id: tiltNeedleImage

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_needle_tilt.png" // enable for design UI only
            rotation: tilt_set_enabled ? tilt_setpoint_angle : _mavlink_manager.tilt_angle
        }
        // text display current angle value, sensor angle value
        Text{
            id: tiltAngleValueText
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
            text: tiltNeedleImage.rotation.toFixed(1)
        }
        // display different value from setpoint
        Text{
            id: tiltAngleDeltaText
            width: 20
            height: 13
            color: "#ff0000"
            font.pixelSize: 12
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tiltAngleValueText.bottom
            anchors.topMargin: 35
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: tilt_angle_delta.toFixed(1)
//                        text: "-180.0"
        }
        Rectangle{
            id: tiltAngleDeltaNumDisplay

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
            id: tiltPositiveAngleDelta
            anchors.bottom: parent.bottom
            anchors.leftMargin: 190
            anchors.left: parent.left
            rotation: 90
            transformOrigin: Item.BottomLeft
            color: "#6429f704"

            anchors.bottomMargin: 122
            width: 10
//            height: 50
            height:  tilt_angle_delta >= 0 ? tilt_angle_delta:0

        }
        // Display different from setpoint, negative delta
        Rectangle{
            id: tiltNegativeAngleDelta

            anchors.rightMargin: 190
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            rotation: -90
            transformOrigin: Item.BottomRight
            color: "#6429f704"
            anchors.bottomMargin: 122
            width: 10
//            height: 20
            height: tilt_angle_delta <= 0 ? -tilt_angle_delta:0
        }
        Item{
            id: tiltControlItem
            anchors.fill: parent
            rotation: tilt_setpoint_angle
            Image{
                id: tiltControlHandleImage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
//                rotation: tilt_setpoint_angle
                //            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint.png" //enable for design UI only

            }
            Image {
                id: tiltHandleSelectedImage
                anchors.right: tiltControlHandleImage.right
                anchors.rightMargin: 0
                anchors.verticalCenter: tiltControlHandleImage.verticalCenter
                source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_handle_selected.png"
                //            source: "../images/gauges/gStabiUI_3.2_handle_selected.png"
                visible: false
                Behavior on visible{
                    SequentialAnimation {
                        NumberAnimation { target: tiltHandleSelectedImage; property: "scale"; to: 0.5; duration: 150}
                        NumberAnimation { target: tiltHandleSelectedImage; property: "scale"; to: 1.5; duration: 150}
                        NumberAnimation { target: tiltHandleSelectedImage; property: "scale"; to: 1.0; duration: 150}
                    }
                }
            }

        }

        MouseArea{
            id: tiltMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged:
            {
                if(tilt_set_enabled)
                {
                    var rot = calc_rotate_angle(mouse.x, mouse.y);
                    if(rot !== -360) {
                        if(rot > 180){ rot = rot - 360}
                        tilt_setpoint_angle = rot
                        tilt_log("Tilting camera to angle: " + tilt_setpoint_angle)
                    }
                }
            }
            onHoveredChanged:
            {
                tilt_log("Tilt axis of gStabi")
            }
            onClicked: {
                tilt_control_handler_no_of_clicks = tilt_control_handler_no_of_clicks + 1
                if(tilt_control_handler_no_of_clicks == 1){
                    tilt_set_enabled = true;
                    tilt_log("Start to tilt camera")
                    tiltHandleSelectedImage.visible = true
                }
                else if(tilt_control_handler_no_of_clicks == 2){
                    tilt_set_enabled = false;
                    tilt_log(" Stop tilting camera");
                    tiltHandleSelectedImage.visible = false
                    tilt_control_handler_no_of_clicks = 0;
                }
            }
        }


    }   // end of Tilt Gauge

//    Roll
    Item{
        id: roll_gauge
        width: gauge_width
        height: gauge_height
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right : parent.right
        anchors.rightMargin: 20
        Image {
            id: rollBackImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_roll.png"
        }
        Image {
            id: rollNeedleImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_roll.png"
            rotation: roll_set_enabled ? roll_setpoint_angle : _mavlink_manager.roll_angle
//            rotation: _mavlink_manager.roll_angle
        }
        Text{
            id: rollAngleValueText
            width: 20
            height: 13
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
//            style: Text.Raised
            color: "#00ffff"
            font.pixelSize: 20
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            text: rollNeedleImage.rotation.toFixed(1)
        }
        Text{
            id: rollAngleDeltaText
            width: 20
            height: 13
            color: "#ff0000"
            font.pixelSize: 12
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rollAngleValueText.bottom
            anchors.topMargin: 35
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: roll_angle_delta.toFixed(1)
//                        text: "-180.0"
        }
        Rectangle{
            id: rollAngleDeltaNumDisplay
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
            id: rollPositiveAngleDelta
            anchors.bottom: parent.bottom
            anchors.leftMargin: 190
            anchors.left: parent.left
            rotation: 90
            transformOrigin: Item.BottomLeft
            color: "#6429f704"

            anchors.bottomMargin: 122
            width: 10
//            height: 50
            height:  roll_angle_delta >= 0 ? roll_angle_delta:0

        }
        // Display different from setpoint, negative delta
        Rectangle{
            id: rollNegativeAngleDelta

            anchors.rightMargin: 190
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            rotation: -90
            transformOrigin: Item.BottomRight
            color: "#6429f704"
            anchors.bottomMargin: 122
            width: 10
//            height: 20
            height: roll_angle_delta <= 0 ? -roll_angle_delta:0
        }
        Item{
            id: rollControlItem
            anchors.fill: parent
            rotation: roll_setpoint_angle
            Image{
                id: rollControlHandleImage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
    //            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint.png" //enable for design UI only
            }
            Image {
                id: rollHandleSelectedImage
                anchors.right: rollControlHandleImage.right
                anchors.rightMargin: 0
                anchors.verticalCenter: rollControlHandleImage.verticalCenter
                source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_handle_selected.png"
                //            source: "../images/gauges/gStabiUI_3.2_handle_selected.png"
                visible: false
                Behavior on visible{
                    SequentialAnimation {
                        NumberAnimation { target: rollHandleSelectedImage; property: "scale"; to: 0.5; duration: 150}
                        NumberAnimation { target: rollHandleSelectedImage; property: "scale"; to: 1.5; duration: 150}
                        NumberAnimation { target: rollHandleSelectedImage; property: "scale"; to: 1.0; duration: 150}
                    }
                }
            } // end of image
        } // end of item

        MouseArea{
            id: rollMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged:
            {
                if(roll_set_enabled) {
                    var rot = calc_rotate_angle(mouse.x, mouse.y);
                    if(rot !== -360) {
                        if(rot > 180){ rot = rot - 360}
                        roll_setpoint_angle = rot;
                        roll_log("Rolling camera to angle: " + roll_setpoint_angle);
                    }
                }
            }
            onHoveredChanged: {roll_log("Roll axis of gStabi")}
            onClicked:
            {
                roll_control_handler_no_of_clicks = roll_control_handler_no_of_clicks + 1
                if(roll_control_handler_no_of_clicks == 1){
                    roll_set_enabled = true;
                    roll_log("Start to roll camera")
                    rollHandleSelectedImage.visible = true
                }
                else if(roll_control_handler_no_of_clicks == 2){
                    roll_set_enabled = false;
                    roll_log( "Stop rolling camera");
                    rollHandleSelectedImage.visible = false
                    roll_control_handler_no_of_clicks = 0;
                }
            }
        }

    } // end of Roll Gauge
    // Pan
    Item{
        id:pan_gauge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        width: gauge_width
        height: gauge_height
        Image {
            id: panBackImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_pan.png"
        }
        Image {
            id: panNeedleImage
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_pan.png"
//            rotation: _mavlink_manager.yaw_angle
            rotation: pan_set_enabled ? pan_setpoint_angle : _mavlink_manager.yaw_angle

        }
        Text{
            id: panAngleValueText
            width: 30
            height: 13
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: "#00ffff"
            font.pixelSize: 20
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            text: panNeedleImage.rotation.toFixed(1);

        }
        Text{
            id: panAngleDeltaText
            width: 20
            height: 13
            color: "#ff0000"
            font.pixelSize: 12
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: panAngleValueText.bottom
            anchors.topMargin: 35
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: pan_angle_delta.toFixed(1)
//                        text: "-180.0"
        }
        Rectangle{
            id: pantiltAngleDeltaNumDisplay
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
            id: panPositiveAngleDelta
            anchors.bottom: parent.bottom
            anchors.leftMargin: 190
            anchors.left: parent.left
            rotation: 90
            transformOrigin: Item.BottomLeft
            color: "#6429f704"
            anchors.bottomMargin: 122
            width: 10
//            height: 50
            height:  pan_angle_delta >= 0 ? pan_angle_delta:0

        }
        // Display different from setpoint, negative delta
        Rectangle{
            id: panNegativeAngleDelta

            anchors.rightMargin: 190
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            rotation: -90
            transformOrigin: Item.BottomRight
            color: "#6429f704"
            anchors.bottomMargin: 122
            width: 10
//            height: 20
            height: pan_angle_delta <= 0 ? -pan_angle_delta:0
        }
        Item{
            id: panControlItem
            anchors.fill: parent
            rotation: pan_setpoint_angle
            Image{
                id: panControlHandleImage
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint_pan.png"
//                source: "../images/gauges/gStabiUI_3.2_inactive_setpoint_pan.png" //enable for design UI only
            } // end of image
            Image {
                id: panHandleSelectedImage
                anchors.top: parent.top
                anchors.topMargin: 2
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_handle_selected.png"
//                            source: "../images/gauges/gStabiUI_3.2_handle_selected.png"
                visible: false
                Behavior on visible{
                    SequentialAnimation {
                        NumberAnimation { target: panHandleSelectedImage; property: "scale"; to: 0.5; duration: 150}
                        NumberAnimation { target: panHandleSelectedImage; property: "scale"; to: 1.5; duration: 150}
                        NumberAnimation { target: panHandleSelectedImage; property: "scale"; to: 1.0; duration: 150}
                    }
                }
            } // end of image
        } // end of item


        // Interact with user control
        MouseArea{
            id: panMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged:
            {
                if(pan_set_enabled)
                var rot = calc_rotate_angle_pan(mouse.x, mouse.y);
                if(rot !== -360) {
                    if(rot > 180){ rot = rot - 360;}
                    pan_setpoint_angle = rot;
                    pan_log("Panning camera to angle: " + pan_setpoint_angle);
                }
            }
            onHoveredChanged: {pan_log("Pan axis of gStabi")}
            onClicked:
            {
                pan_control_handler_no_of_clicks = pan_control_handler_no_of_clicks + 1
                if(pan_control_handler_no_of_clicks == 1){
                    pan_set_enabled = true;
                    pan_log("Start to pan camera")
                    panHandleSelectedImage.visible = true
                }
                else if(pan_control_handler_no_of_clicks == 2){
                    pan_set_enabled = false;
                    pan_log( "Stop paning camera");
                    panHandleSelectedImage.visible = false
                    pan_control_handler_no_of_clicks = 0;
                }
            }

        } // end of MouseArea

    } // end of Pan Gauge



    /* function calc_rotate_angle(_x, _y)
       @brief: get the angle to rotate the setpoint handler
       @input: (_x, _y) = (mouse.x, mouse.y)
       @output: angle for setpoint handle image to rotate
      */
    function calc_rotate_angle(_x, _y){
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
        return rot_angle_deg;
    } // end of function
    /* function calc_rotate_angle_pan(_x, _y)
       @brief: get the angle to rotate the setpoint handler for pan axis only
       @input: (_x, _y) = (mouse.x, mouse.y)
       @output: angle for setpoint handle image to rotate
      */
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
        return rot_angle_deg;
    } // end of function
    /* function tilt_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function tilt_log(_message){
        msg_log = "<font color=\"cyan\">" + _message+ "</font><br>";
    }
    /* function roll_log(_message)
       @brief: put message to log
       @input: message
       @output: msg_log in HTML format
      */
    function roll_log(_message){
        msg_log = "<font color=\"green\">" + _message+ "</font><br>";
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
