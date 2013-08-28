import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10
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
        width: 300
        anchors.top: dialogImage.top
        anchors.topMargin: 30
        anchors.left: dialogImage.left
        anchors.leftMargin: 5
        spacing: 5
        Text{
            id: powerLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 12
            text: "Power (%)"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: powerSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 180; height: 20
            anchors.verticalCenter: parent.verticalCenter
            value: power_level
            onValueChanged: power_level = powerSlider.value
        }
        Rectangle{
            width: 45;  height: 20
            color: "#00000000"
            smooth: true
            radius: height/2
            border.width: 1;border.color: "cyan"
            anchors.verticalCenter: parent.verticalCenter
            TextInput {
                id: powerLevelInput
                anchors.centerIn: parent
                color : "#00e3f9"
                font.family: "Segoe UI Symbol"
                font.bold: true
                font.pixelSize: 16
                text: power_level
                validator: IntValidator{bottom: 0; top: 100;}
                focus: true
            }
        }
    }
    Row{
        id: polesRow
        anchors.top: powerRow.bottom; anchors.topMargin: 40
        anchors.left: dialogImage.left; anchors.leftMargin: 10
        spacing: 10
        Text{
            id: polesLabel
            width: 45; height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 12
            text: "Poles:"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle{
            width: 45;  height: 20
            color: "#00000000"
            smooth: true;            radius: 6
            border.width: 1;border.color: "cyan"
            anchors.verticalCenter: parent.verticalCenter
            TextInput {
                id: polesNumInput
                anchors.centerIn: parent
                color : "#00e3f9"
                font.family: "Segoe UI Symbol"
                font.bold: true
                font.pixelSize: 16
                validator: IntValidator{bottom: 0; top: 100;}
                text: poles_num

            }
        }
    }
    Column{
        id: maxColumn
        x: 240
        y: 86
        width: 50; height: 45
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 5
        Text{
            width: 40
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 16
            text: "Max"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
        }
        Rectangle{
            width: 45;  height: 20
            color: "#00000000"
            smooth: true
            radius: height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            border.width: 1;border.color: "cyan"
            TextInput {
                anchors.centerIn: parent
                color : "#00e3f9"
                font.family: "Segoe UI Symbol"
                font.bold: true
                font.pixelSize: 16
                text: max_value
                validator: IntValidator{bottom: 0; top: 100;}
                focus: true
            }
        }

    }
    Column{
        id: minColumn
        x: 240
        width: 50; height: 45
        anchors.top: maxColumn.bottom
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 5
        Text{
            width: 40
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 16
            text: "Min"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 0
        }
        Rectangle{
            width: 45;  height: 20
            color: "#00000000"
            smooth: true
            radius: height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            border.width: 1;border.color: "cyan"
            TextInput {
                anchors.centerIn: parent
                color : "#00e3f9"
                font.family: "Segoe UI Symbol"
                font.bold: true
                font.pixelSize: 16
                text: min_value
                validator: IntValidator{bottom: 0; top: 100;}
                focus: true
            }
        }

    }

    GButton{
        id: reverseButton
        text: "Reverse"
        anchors.top: polesRow.bottom ; anchors.topMargin: 0
        anchors.left: polesRow.left;  anchors.leftMargin: 0
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
