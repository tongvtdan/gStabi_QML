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
        color: "#09fdb0"
        text: "Status: Standby"
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
        text: _configuration.application_name()+ " " + _configuration.application_version();
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
        text: "COM1: 57600,8,N,1"
        verticalAlignment: Text.AlignVCenter
        style: Text.Raised
        font.pointSize: 10
        font.family: "Terminal"
        horizontalAlignment: Text.AlignRight
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

    }
}
