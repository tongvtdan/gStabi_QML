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

    property alias  tilt_setpoint_angle : tilt_setpoint_handle.rotation
    property bool   tilt_set_enabled    : false
    property double tilt_angle_delta    : tilt_needle.rotation - tilt_setpoint_handle.rotation
    property int  tilt_control_handler_no_of_clicks: 0

    property alias  roll_setpoint_angle : roll_setpoint_handle.rotation
    property bool   roll_set_enabled    : false
    property double roll_angle_delta    : roll_needle.rotation - roll_setpoint_handle.rotation

    property alias  pan_setpoint_angle : pan_setpoint_handle.rotation
    property bool   pan_set_enabled    : false
    property double pan_angle_delta    : pan_needle.rotation - pan_setpoint_handle.rotation
    property double  pan_offset_display: -90

    property string msg_log: ""
    property int hint_x: 0
    property int hint_y: 0


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
            id: tilt_back

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_back_tilt.png"  // enable for design UI only
        }
        Image {
            id: tilt_needle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_needle_tilt.png" // enable for design UI only
            rotation: tilt_set_enabled ? tilt_setpoint_handle.rotation : _mavlink_manager.tilt_angle
        }
        // text display current angle value, sensor angle value
        Text{
            id: tiltAngleValue
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
            text: tilt_needle.rotation.toFixed(1)
        }
        // display different value from setpoint
        Text{
            id: tiltAngleDelta
            width: 20
            height: 13
            color: "#ff0000"
            font.pixelSize: 12
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: tiltAngleValue.bottom
            anchors.topMargin: 35
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: tilt_angle_delta.toFixed(1)
//                        text: "-180.0"
        }
        Rectangle{
            id: angleDeltaNumDisplay

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
            id: positiveAngleDelta
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
            id: negativeAngleDelta

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
        Image{
            id: tilt_setpoint_handle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
//            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint.png" //enable for design UI only
            Behavior on source{
                SequentialAnimation {
                    NumberAnimation { target: tilt_setpoint_handle; property: "scale"; to: 1; duration: 150 }
                    NumberAnimation { target: tilt_setpoint_handle; property: "scale"; to: 1.2; duration: 150 }
                    NumberAnimation { target: tilt_setpoint_handle; property: "scale"; to: 1.0; duration: 150 }
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
                        tilt_setpoint_handle.rotation = rot;
                        msg_log = "Tilting camera to angle: " + tilt_setpoint_handle.rotation.toFixed(1) + "\n"
                    }
                }
            }
            onHoveredChanged:
            {
                msg_log = "Tilt axis of gStabi \n"
            }
            onClicked: {
                tilt_control_handler_no_of_clicks = tilt_control_handler_no_of_clicks + 1
                if(tilt_control_handler_no_of_clicks == 1){
                    tilt_set_enabled = true;
                    msg_log = "Start to tilt camera \n";
                    tilt_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_active_setpoint.png";
                }
                else if(tilt_control_handler_no_of_clicks == 2){
                    tilt_set_enabled = false;
                    msg_log = " Stop tilting camera \n";
                    tilt_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png";
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
            id: roll_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_roll.png"
        }
        Image {
            id: roll_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_roll.png"
            rotation: roll_set_enabled ? roll_setpoint_handle.rotation : _mavlink_manager.roll_angle
//            rotation: _mavlink_manager.roll_angle
        }
        Text{
            id: rollAngleValue
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
            text: ""+ _mavlink_manager.roll_angle.toFixed(1);
        }
        Text{
            id: rollAngleDelta
            width: 20
            height: 13
            color: "#ff0000"
            font.pixelSize: 12
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rollAngleValue.bottom
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
        Image{
            id: roll_setpoint_handle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
//            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint.png" //enable for design UI only
        }
        MouseArea{
            anchors.fill: parent
            onPositionChanged:
            {
                roll_set_enabled = true;
                roll_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_active_setpoint.png"
                var rot = calc_rotate_angle(mouse.x, mouse.y);
                if(rot !== -360) {
                    if(rot > 180){ rot = rot - 360}
                    roll_setpoint_handle.rotation = rot;
                }
            }
            onReleased: {
                roll_set_enabled = false;
                roll_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
            }
            onClicked:
            {
                msg_log = "Roll Camera \n"
            }
        }

    } // end of Roll Gauge
    // yaw
    Item{
        id:pan_gauge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        width: gauge_width
        height: gauge_height
        Image {
            id: yaw_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_pan.png"
        }
        Image {
            id: pan_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_pan.png"
//            rotation: _mavlink_manager.yaw_angle
            rotation: pan_set_enabled ? pan_setpoint_handle.rotation : _mavlink_manager.yaw_angle

        }
        Text{
            id: panAngleValue
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

            text: ""+ _mavlink_manager.yaw_angle.toFixed(1);

        }
        Text{
            id: panAngleDelta
            width: 20
            height: 13
            color: "#ff0000"
            font.pixelSize: 12
            font.family: "Ubuntu"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: panAngleValue.bottom
            anchors.topMargin: 35
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: pan_angle_delta.toFixed(1)
//                        text: "-180.0"
        }
        Rectangle{
            id: panAngleDeltaNumDisplay
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
        Image{
            id: pan_setpoint_handle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint_pan.png"
//            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint_pan.png" //enable for design UI only
        }
        // Interact with user control
        MouseArea{
            anchors.fill: parent
//            hoverEnabled: true
            onPositionChanged:
            {
                pan_set_enabled = true;
                pan_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_active_setpoint_pan.png"
                var rot = calc_rotate_angle_pan(mouse.x, mouse.y);
                if(rot !== -360) {
                    if(rot > 180){ rot = rot - 360}
                    pan_setpoint_handle.rotation = rot;
                }
            }
            onReleased: {
                pan_set_enabled = false;
                pan_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint_pan.png"
            }
            onEntered:
            {
                msg_log = "Pan Camera \n"
            }
        }

    } // end of Pan Gauge
    states:[
        State {
            name: "start tilt"
            PropertyChanges {target: tilt_setpoint_handle; scale: 1.0; opacity: 1; }

        }
        ,State {
            name: "top tilt"
            PropertyChanges {target: tilt_setpoint_handle; scale: 1.0 ; opacity: 0.5; }
        }

    ]
    transitions: [
        Transition {
//            from: ""
           SequentialAnimation{
           id: setpointEnableAnimation
           NumberAnimation{ target: tilt_setpoint_handle; properties: "scale"; from: 1.5; to: 0.5;easing.type: Easing.InElastic ;duration: 500}
           NumberAnimation{ target: tilt_setpoint_handle; properties: "scale"; from: 0.5; to: 1.5; easing.type: Easing.InElastic ;duration: 500}
        }
        }
    ]


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


}
