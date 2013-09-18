import QtQuick 2.0
import "../Components"

Item{
    id: generalSettings
     width: 950; height: 250

    GSerialSettings{
        id: serialPortSettings
        width: 200;
        anchors.left: parent.left;
        anchors.top:  parent.top;

    }
    GManualControl{
        width: 770
        anchors.left: serialPortSettings.right; anchors.leftMargin: 0
        anchors.top: parent.top;
    }
}
