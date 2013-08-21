import QtQuick 2.0

Item {
    id: dashboardRoot

    width: 700
    height: 250
    Item{
        id: tilt_gauge

        width: 200
        height: 200
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 20
        Image {
            id: tilt_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/back_tilt_gauge.png"
        }
        Image {
            id: tilt_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/needle_tilt_gauge.png"
            rotation: _mavlink_manager.tilt_angle
        }
        Text{
            x: 90
            y: 129
            width: 20
            height: 13
            color: "white"
            font.pixelSize: 24
            font.family: "Segoe UI Symbol"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: Text.Normal
            text: ""+ _mavlink_manager.tilt_angle.toFixed(1);
//            text: "18.5"
//            wrapMode: Text.NoWrap
        }
    }

//    Roll
    Item{
        id: roll_gauge
        width: 200
        height: 200
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right : parent.right
        anchors.rightMargin: 44
        Image {
            id: roll_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/GDashboard/images/gStabiUI_3.2_back_roll.png"
        }
        Image {
            id: roll_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/GDashboard/images/gStabiUI_3.2_arrows_roll.png"
            rotation: _mavlink_manager.roll_angle
        }
        Text{
            width: 20
            height: 13
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
//            style: Text.Raised
            color: "#00ffff"
            font.pixelSize: 24
//            font.family: "Segoe UI Symbol"
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
        width: 200
        height: 200
        Image {
            id: yaw_back
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/back_pan_gauge.png"
        }
        Image {
            id: yaw_needle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/qml/gStabiSC/images/gauges/needle_pan_gauge.png"
            rotation: _mavlink_manager.yaw_angle

        }
        Text{
//            x: 85
//            y: 129
            width: 30
            height: 13
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: Text.Raised
            color: "white"
            font.pixelSize: 24
            font.family: "Segoe UI Symbol"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.bold: true

            text: ""+ _mavlink_manager.yaw_angle.toFixed(1);

        }
    }

}
