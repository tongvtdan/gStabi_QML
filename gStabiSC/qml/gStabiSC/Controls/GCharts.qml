import QtQuick 2.0

import "../Components"
Rectangle {
    id: chartContainer
    width: 800;   height: 260
    color: "transparent"
    border{color: "cyan"; width: 1}
    Column{

    }

    GRealtimeChart{
        width: parent.width - 100;height: 250
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }
}

