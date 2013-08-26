import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property double  value: 50.0
    implicitWidth: 300; implicitHeight: 200
    BorderImage {
        id: dialogImage
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_tilt_config_dialog.png"
//        source: "../images/gStabiUI_3.2_tilt_config_dialog.png"
        width: parent.width ; height: parent.height
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        anchors.top: parent.top;
    }


    Row{
        id: powerRow
        anchors.top: dialogImage.top
        anchors.topMargin: 30
        anchors.left: dialogImage.left
        anchors.leftMargin: 10
        spacing: 10
        Text{
            id: powerLabel
            width: 45
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 16
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
        anchors.topMargin: 40
        anchors.left: dialogImage.left
        anchors.leftMargin: 10
        spacing: 10
        Text{
            id: polesLabel
            width: 45
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 16
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
