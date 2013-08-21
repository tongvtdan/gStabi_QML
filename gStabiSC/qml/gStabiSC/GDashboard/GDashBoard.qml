import QtQuick 2.1
import QtQuick.Controls 1.0

Item {
    id: dashboardRoot

    width: 960
    height: 340
    property alias tilt_setpoint_angle: setpoint_handle.rotation
    property int gauge_width: 300
    property int gauge_height: gauge_width
    property double gauge_center_x: gauge_width/2
    property double gauge_center_y: gauge_height/2
    property double gauge_radius: gauge_width - gauge_center_x

    // tilt
    Item{
        id: tilt_gauge

        width: gauge_width
        height: gauge_height
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
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
            rotation: _mavlink_manager.tilt_angle
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
            text: "0.0"
        }
        Image{
            id: setpoint_handle
            x: -24
            y: 127
            rotation: 90

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
//            source: "../images/gauges/gStabiUI_3.2_inactive_setpoint.png"

            MouseArea{
                anchors.fill: parent


               onPositionChanged:
                 {
                   console.log("Center: " + gauge_center_x +", " + gauge_center_y );
                    setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_active_setpoint.png"
                    var rot = cal_rotate_angle(mouse.x, mouse.y);
                    if(rot !== -360) {
                    setpoint_handle.rotation = rot;
                        console.log("Angle: "+rot);
                    }
                }
                onReleased: setpoint_handle.source =  "qrc:/images/qml/gStabiSC/images/gauges/gStabiUI_3.2_inactive_setpoint.png"
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
        if((distanceFromCenterToPressedPoint >= 0.7*gauge_radius) && (distanceFromCenterToPressedPoint <= gauge_radius)){
            console.log("("+ _x +", " + _y + ")" + "Distance: " + distanceFromCenterToPressedPoint)
            rot_angle_deg = 180*Math.acos((_y - gauge_center_y)/distanceFromCenterToPressedPoint)/Math.PI;
            return rot_angle_deg;
            }
        else {
            return -360;
        }
    }


}
