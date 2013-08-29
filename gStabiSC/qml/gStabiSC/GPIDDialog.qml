import QtQuick 2.0
import "Components"

GSettingDialog{
    id: pidDialog
    title: "PID Settings"
    state:"showDialog"
    ParametersContainer{
        id: tiltParameters
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.top: parent.top; anchors.topMargin: 50
    }
}
