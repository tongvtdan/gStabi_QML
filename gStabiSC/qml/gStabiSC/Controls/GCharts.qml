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
        width: 700;height: 250
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.bottom: parent.bottom;  anchors.bottomMargin: 10
    }
}

