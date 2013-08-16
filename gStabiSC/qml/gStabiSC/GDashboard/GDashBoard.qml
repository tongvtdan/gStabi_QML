import QtQuick 2.0

Item {
    id: dashboardRoot

    width: 700
    height: 250
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
            source: "images/back_tilt_gauge.png"
        }
        Image {
            id: tilt_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/needle_tilt_gauge.png"
            rotation: _mavlink_manager.tilt_angle
        }
        Text{
            x: 90
            y: 129
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
            source: "images/back_roll_gauge.png"
        }
        Image {
            id: roll_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/needle_roll_gauge.png"
            rotation: _mavlink_manager.roll_angle
        }
        Text{
            x: 90
            y: 129
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
            source: "images/back_yaw_gauge.png"
        }
        Text{
            x: 85
            y: 129
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

        Image {
            id: yaw_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/needle_yaw_gauge.png"
            rotation: _mavlink_manager.yaw_angle

        }
    }

}
