import QtQuick 2.0

Item {
    id: dashboardRoot

    width: 600
    height: 200
    Item{
        id: tilt_gauge
        anchors.left: parent.left
        anchors.top: parent.top
        width: 200
        height: 200
        anchors.topMargin: 20
        anchors.leftMargin: 44
        Image {
            id: tilt_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_back.png"
            scale: 0.5
        }
        Image {
            id: tilt_needle_shadow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle_shadow.png"
            scale: 0.8
            rotation: tilt_needle.rotation
        }
        Image {
            id: tilt_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle.png"
            scale: 0.8
            rotation: 90+_mavlink_manager.tilt_angle
        }
        Image {
            id: tilt_needle_top
            scale: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle_top.png"
        }
        Image {
            id: tilt_needle_glare
            scale: 0.5
            anchors.verticalCenterOffset: -18
            anchors.horizontalCenterOffset: -1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_glare.png"
            opacity: 0.12
        }
        Text{
            x: 89
            y: 118
            width: 20
            height: 13
            color: "#06e5f9"
            text: ""+ _mavlink_manager.tilt_angle.toFixed(1);
            font.bold: true
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: Text.Raised
        }
    }

//    Roll
    Item{
        id: roll_gauge
        anchors.right : parent.right
        anchors.top: parent.top
        width: 200
        height: 200
        anchors.topMargin: 20
        anchors.rightMargin: 44
        Image {
            id: roll_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_back.png"
            scale: 0.5
        }
        Image {
            id: roll_needle_shadow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle_shadow.png"
            scale: 0.8
            rotation: roll_needle.rotation
        }
        Image {
            id: roll_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle.png"
            scale: 0.8
            rotation: 90+_mavlink_manager.roll_angle
        }
        Image {
            id: roll_needle_top
            scale: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle_top.png"
        }
        Image {
            id: roll_needle_glare
            scale: 0.5
            anchors.verticalCenterOffset: -18
            anchors.horizontalCenterOffset: -1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_glare.png"
            opacity: 0.12
        }
        Text{
            x: 89
            y: 118
            width: 20
            height: 13
            color: "#06e5f9"
            text: ""+ _mavlink_manager.roll_angle.toFixed(1);
            font.bold: true
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: Text.Raised
        }
    }
    // yaw
    Item{
        id:yaw_gauge
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: 200
        height: 200
        Image {
            id: yaw_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_back.png"
            scale: 0.6
        }
        Image {
            id: yaw_needle_shadow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle_shadow.png"
            scale: 0.8
            rotation: yaw_needle.rotation
        }
        Image {
            id: yaw_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle.png"
            scale: 0.8
            rotation: _mavlink_manager.yaw_angle
        }
        Image {
            id: yaw_needle_top
            scale: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_needle_top.png"
        }
        Image {
            id: yaw_needle_glare
            scale: 0.6
            anchors.verticalCenterOffset: -22
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/altitude_glare.png"
            opacity: 0.12
        }
        Text{
            x: 41
            y: 93
            width: 30
            height: 13
            color: "#06e5f9"
            text: ""+ _mavlink_manager.yaw_angle.toFixed(1);
            styleColor: "#12e675"
            font.bold: true
            font.pointSize: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: Text.Sunken
        }
    }

}
