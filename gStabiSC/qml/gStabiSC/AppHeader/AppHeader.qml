import QtQuick 2.1
import QtQuick.Controls 1.0
//import QtQuick.Layouts 1.0
//import QtQuick.Controls.Styles 1.0


Item {
    id: header
    width: 1024
    height: 25
    property bool portIsConnected: _serialLink.isConnected
    property bool linkConnectionLost: _mavlink_manager.board_connection_state
    property int showY: 4
    property int hideY: -25
    Image {
        id: headerImage
        source: "qrc:/images/qml/gStabiSC/AppHeader/images/header.png"
    }
    AnimatedImage{
        width: 25
        height: 25
        anchors.right: systemStatus.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        id: waitingForConnection
        visible: false
        source: "qrc:/images/qml/gStabiSC/images/loading_01.gif"
    }

    Label{
        id: systemStatus
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: header.horizontalCenter
        anchors.verticalCenterOffset: 0
        font.bold: true
        font.family: "Segoe UI Symbol"
        y:4
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        color: _mavlink_manager.board_connection_state ? "cyan" :  "red"
        text : _mavlink_manager.board_connection_state ?  "SYSTEM: ONLINE" : "SYSTEM: OFFLINE"
//        text: "SYSTEM: OFFLINE"


    }
    Label{
        id: applicationName
        color: "cyan"
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
        text: m_configuration.application_name() + " " + m_configuration.application_version()
//        text: "gStabiSC v. 1.0.0 (alpha-01)"

    }

    Label{
        id: comportInfo
        height: 17
        color: "cyan"
        style: Text.Raised
        font.pointSize: 10
        font.bold: true
        font.family: "Segoe UI Symbol"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        text: " - " + comportSettingPanel.selected_portname
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
//        text: "COM1"

    }

    Label{
        id: portConnectedLabel
        y: 4
        width: 100
        height: 17
        color: "cyan"
        style: Text.Raised
        font.pointSize: 10
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.family: "Segoe UI Symbol"
        anchors.right: comportInfo.left
        anchors.rightMargin: 0
        anchors.verticalCenterOffset: 0
        horizontalAlignment: Text.AlignRight
        text: _serialLink.isConnected? "CONNECTED": "DISCONNECTED"
//        text: "Disconnected"

    }
    SequentialAnimation{
        id: portConnectionChangeStateAnimation
        running: true
        NumberAnimation{
            target: portConnectedLabel
            property: "y"
            easing.type:  Easing.Bezier
            from: showY ; to: hideY; duration: 250
        }
        NumberAnimation{
            target: portConnectedLabel
            property: "y"
            easing.type:  Easing.Bezier
            from: hideY ; to: showY; duration: 250
        }
        onStarted: waitingForConnection.visible = true
    }
    SequentialAnimation{
        id: systemChangeStateAnimation
        running: true

        NumberAnimation{
            target: systemStatus
            property: "y"
            easing.type:  Easing.Bezier
            from: showY ; to: hideY; duration: 250
        }
        NumberAnimation{
            target: systemStatus
            property: "y"
            easing.type:  Easing.Bezier
            from: hideY ; to: showY; duration: 250
        }

        onStopped: waitingForConnection.visible = false
    }
    onPortIsConnectedChanged: {
        portConnectionChangeStateAnimation.start();

    }
    onLinkConnectionLostChanged:  {
        systemChangeStateAnimation.start();

    }
}
