import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item {
    id: header
    width: 1024
    height: 30
    property bool portIsConnected: _serialLink.isConnected
    property bool heartbeatState: _mavlink_manager.hb_pulse
    Label{
        id: systemStatus
        text :_mavlink_manager.hb_pulse ? "System: Online" : "System: Offline"
        color : _mavlink_manager.hb_pulse ? "cyan" : "red"
        y:8
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        font.family: "Terminal"
        anchors.left: parent.left
        anchors.leftMargin: 10

    }
    Label{
        id: applicationName
        color: "#09fdb0"
        text: m_configuration.application_name() + " " + m_configuration.application_version()
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        font.family: "Terminal"
        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent.Center
    }

    Label{
        id: comportInfo
        color: "#09fdb0"
        style: Text.Raised
        font.pointSize: 10
        font.family: "Terminal"
        text: comportSettingPanel.selected_portname +  ": 57600,8,N,1 - "
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: portConnectedLabel.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
    }

    Label{
        id: portConnectedLabel
        x: 927
        y: 8
        width: 100
        height: 14
        color: "#09fdb0"
        style: Text.Raised
        font.pointSize: 10
        font.family: "Terminal"
        text: _serialLink.isConnected? "Connected": "Disconnected"
        anchors.right: parent.right
        anchors.rightMargin: 10
        horizontalAlignment: Text.AlignLeft
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
        if(!portIsConnected){
            systemStatus.text = "System: Offline"
            systemStatus.color = "red"
        }
        systemChangeStateAnimation.start();
    }
    onHeartbeatStateChanged: {
        systemChangeStateAnimation.start();
        console.log("HB Changed")

    }
}
