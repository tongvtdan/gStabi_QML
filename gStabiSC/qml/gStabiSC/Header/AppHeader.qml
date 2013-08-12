import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item {
    id: header
    width: 1024
    height: 30
    Label{
        id: systemStatus
        text: _mavlink_manager.hb_pulse ? "System: Online" : "System: Offline"
        color: _mavlink_manager.hb_pulse ? "cyan" : "red"

        style: Text.Raised
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        font.family: "Terminal"
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter

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
    RowLayout{
        id: rowlayout1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        Label{
        id: comportInfo
        color: "#09fdb0"
        style: Text.Raised
        font.pointSize: 10
        font.family: "Terminal"
        text: comportSettingPanel.selected_portname +  ": 57600,8,N,1 - "
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: portConnectionState.left

        verticalAlignment: Text.AlignVCenter

        horizontalAlignment: Text.AlignRight
    }
        Label{
            id: portConnectionState
            color: "#09fdb0"
            style: Text.Raised
            font.pointSize: 10
            font.family: "Terminal"
            text: _serialLink.isConnected? "Connected" : "Disconnected"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
