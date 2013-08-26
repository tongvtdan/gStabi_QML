import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property double  value: 50.0
    implicitWidth: 300; implicitHeight: 200
    Row{
        id: powerRow
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 10
        Text{
            id: powerLabel
            text: "Power"
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: powerSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 200; height: 20
            anchors.verticalCenter: parent.verticalCenter
            value: value
        }
    }
    Row{
        id: polesRow
        anchors.top: powerRow.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 10
        Text{
            id: polesLabel
            text: "Poles: "
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: polesSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 200; height: 20
            anchors.verticalCenter: parent.verticalCenter
            value: value
        }
    }
}
