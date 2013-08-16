import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item {
    id: header
    width: 1024
    height: 25
    property bool portIsConnected: _serialLink.isConnected
    property bool linkConnectionLost: _mavlink_manager.board_connection_state
//    BorderImage {
//        id: header
//        source: "images/header.png"
//        width: 1024; height: 25
//    }
//    Image {
//        id: headerImage
//        source: "images/header.png"
//    }
    Label{
        id: systemStatus
        x: 441
        text : _mavlink_manager.board_connection_state ?  "SYSTEM: ONLINE" : "SYSTEM: OFFLINE"
//        text: "SYSTEM: OFFLINE"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: header.horizontalCenter
        anchors.verticalCenterOffset: 0
        font.bold: true
        font.family: "Segoe UI Symbol"
        anchors.verticalCenter: header.verticalCenter
        color: _mavlink_manager.board_connection_state ? "cyan" :  "red"
        y:4
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10

    }
    Label{
        id: applicationName
        y: 4
        color: "cyan"
        text: m_configuration.application_name() + " " + m_configuration.application_version()
//        text: "gStabiSC v. 1.0.0 (alpha-01)"
        anchors.left: header.left
        anchors.leftMargin: 10
        anchors.verticalCenterOffset: 0
        font.bold: true
        font.family: "Segoe UI Symbol"
        horizontalAlignment: Text.AlignLeft
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent.Center
    }

    Label{
        id: comportInfo
        y: 5
        color: "cyan"
        style: Text.Raised
        font.pointSize: 10
        text: " - " + comportSettingPanel.selected_portname
//        text: "COM1"
        font.bold: true
        font.family: "Segoe UI Symbol"
        anchors.rightMargin: 10
        anchors.right: header.right
        anchors.leftMargin: 0
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: header.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Label{
        id: portConnectedLabel
        x: 874
        y: 7
        width: 100
        height: 14
        color: "cyan"
        style: Text.Raised
        font.pointSize: 10
        text: _serialLink.isConnected? "CONNECTED": "DISCONNECTED"
//        text: "Disconnected"
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: "Segoe UI Symbol"
        anchors.right: comportInfo.left
        anchors.rightMargin: 0
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: header.verticalCenter
        horizontalAlignment: Text.AlignRight
    }
    SequentialAnimation{
        id: portConnectionChangeStateAnimation
        running: true
        NumberAnimation{
            target: portConnectedLabel
            property: "y"
            easing.type:  Easing.Bezier
            from: 8 ; to: -20; duration: 250
        }
        NumberAnimation{
            target: portConnectedLabel
            property: "y"
            easing.type:  Easing.Bezier
            from: -20 ; to: 8; duration: 250
        }
    }
    SequentialAnimation{
        id: systemChangeStateAnimation
        running: true
        NumberAnimation{
            target: systemStatus
            property: "y"
            easing.type:  Easing.Bezier
            from: 8 ; to: -20; duration: 250
        }
        NumberAnimation{
            target: systemStatus
            property: "y"
            easing.type:  Easing.Bezier
            from: -20 ; to: 8; duration: 250
        }
    }
    onPortIsConnectedChanged: {
        portConnectionChangeStateAnimation.start();

    }
    onLinkConnectionLostChanged:  {
        systemChangeStateAnimation.start();

    }
}
