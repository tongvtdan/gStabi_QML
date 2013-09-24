import QtQuick 2.0

import "../Components"



Item {
    id: chartContainer
    width: 800;   height: 260
//    color: "transparent"
//    border{color: "cyan"; width: 1}
    Column{
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        GCheckBox{
            checkbox_text:  "Tilt"
        }
        GCheckBox{
            checkbox_text:  "Pan"
        }
        GCheckBox{
            checkbox_text:  "Roll"
        }
    }

    GRealtimeChart{
        width: 700;height: 250
        anchors.right: parent.right; anchors.rightMargin: 10
        anchors.bottom: parent.bottom;  anchors.bottomMargin: 10
    }
}

