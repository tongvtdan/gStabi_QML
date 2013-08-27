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
            width: 180; height: 20
            anchors.verticalCenter: parent.verticalCenter
            value: 50
        }
        Text {
            id: powerLevelLabel
            width: 45
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr(powerSlider.value.toFixed(0)+ "%")
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
            width: 180; height: 20
            anchors.verticalCenter: parent.verticalCenter
            step: 2
            value: 24
        }
        Text{
            id: polesNumLabel
            width: 45
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
            text: { if((polesSlider.value.toFixed(0) % polesSlider.step) == 0) {return ("#" + polesSlider.value.toFixed(0))}}

        }
    }
    GButton{
        id: reverseButton
        text: "Reverse"
        anchors.top: polesRow.bottom
        anchors.topMargin: 40
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    states:[
        State{
            name: "showDialog"
            PropertyChanges { target: dialogContainer; opacity: 1; }
        }
        ,State {
            name: "hideDialog"
            PropertyChanges {target: dialogContainer; opacity: 0;}
        }

    ]
    transitions: [
        Transition {
            from: "showDialog" ; to:   "hideDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity";  duration: 400;}
                SequentialAnimation{
                    NumberAnimation { target: dialogContainer; property: "scale"; from: 1; to: 1.5; duration: 200; }
                    NumberAnimation { target: dialogContainer; property: "scale"; from: 1.5; to: 0.5; duration: 200; }
                }
            }
        }
        ,Transition {
            from: "hideDialog" ; to: "showDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity"; duration: 600; }
                SequentialAnimation{
                    NumberAnimation { target: dialogContainer; property: "scale"; from: 0.5; to: 1; duration: 200; }
                    NumberAnimation { target: dialogContainer; property: "scale"; from: 1; to: 1.5; duration: 200; }
                    NumberAnimation { target: dialogContainer; property: "scale"; from: 1.5; to: 1; duration: 200;}
                }
            }

        }
    ]

}
