import QtQuick 2.1
import QtQuick.Controls 1.0

Item {
    id: dashboardRoot

    width: 960
    height: 340
    property alias tilt_setpoint_angle: tilt_setpoint_handle.rotation
    property int gauge_width: 330
    property int gauge_height: 330
    property double gauge_center_x: gauge_width/2
    property double gauge_center_y: gauge_height/2
    property double gauge_radius: gauge_width - gauge_center_x

    property bool tilt_set_enabled: false

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
//            source: "../images/gauges/gStabiUI_3.2_back_tilt.png"
        }
        Image {
            id: tilt_needle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_tilt.png"
//            source: "../images/gauges/gStabiUI_3.2_needle_tilt.png"
            rotation: tilt_set_enabled ? tilt_setpoint_handle.rotation : _mavlink_manager.tilt_angle
        }
        Text{
            x: 90
            y: 129
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
//            text: ""+ _mavlink_manager.tilt_angle.toFixed(1);
            text: tilt_needle.rotation.toFixed(1)
        }
        Image{
            id: tilt_setpoint_handle
//            rotation: 90

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
//            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint.png"
        }
        MouseArea{
            anchors.fill: parent
            onPositionChanged:
            {
                console.log("Pos: " + mouse.x +", " + mouse.y);
                tilt_set_enabled = true;
                tilt_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_active_setpoint.png"
                var rot = cal_rotate_angle(mouse.x, mouse.y);
                if(rot !== -360) {
                    if(rot > 180){ rot = rot - 360}
                    tilt_setpoint_handle.rotation = rot;
//                    tilt_needle.rotation = rot;
//                    console.log("Angle: "+rot);
                }
            }
            onReleased: {
//                tilt_needle.rotation =  _mavlink_manager.tilt_angle
                tilt_set_enabled = false;
                tilt_setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
            }
        }
    }

//    Roll
    Item{
        id: roll_gauge
        width: 300
        height: 300
        anchors.top: parent.top
        anchors.topMargin: 20
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
            rotation: _mavlink_manager.roll_angle
        }
        Text{
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
    }
    // yaw
    Item{
        id:yaw_gauge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        width: 300
        height: 300
        Image {
            id: yaw_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_back_pan.png"
        }
        Image {
            id: yaw_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_needle_pan.png"
            rotation: _mavlink_manager.yaw_angle

        }
        Text{
//            x: 85
//            y: 129
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
    }


    function cal_rotate_angle(_x, _y){
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
    }


}
