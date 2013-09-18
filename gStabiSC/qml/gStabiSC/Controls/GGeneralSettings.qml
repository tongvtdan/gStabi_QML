import QtQuick 2.0
import "../Components"

Item{
    id: generalSettings
     width: 930; height: 250

    GSerialSettings{
        id: serialPortSettings
        width: 200;
        anchors.left: parent.left; anchors.leftMargin: 0
        anchors.top:    parent.top; anchors.topMargin: 0

    }
    GManualControl{
        width: 640
        anchors.left: serialPortSettings.right; anchors.leftMargin: 5
        anchors.top: parent.top; anchors.topMargin: 0
    }
}
