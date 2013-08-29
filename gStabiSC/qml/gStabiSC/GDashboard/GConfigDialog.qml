import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10

    //    property string border_normal   : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_parameters_dialog.png"
    //    property string border_hover    : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_hover_parameters_dialog.png"
    property string border_normal   : "../images/gStabiUI_3.2_normal_parameters_dialog.png"
    property string border_hover    : "../images/gStabiUI_3.2_hover_parameters_dialog.png"


    implicitWidth: 310; implicitHeight: 210

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: boarderHoverImg.visible = true
        onExited: boarderHoverImg.visible = false
    }
    BorderImage {
        id: boardNormalImg
        width: parent.width ; height: parent.height
        border.left: 5; border.top: 5 ;border.right: 5; border.bottom: 5
        anchors.top: parent.top;
        source: border_normal
    }
    BorderImage {
        id: boarderHoverImg
        width: parent.width ; height: parent.height
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        anchors.top: parent.top;
        source: border_hover
        visible: false
    }


    Row{
        id: powerRow
        width: 300
        anchors.top: boardNormalImg.top; anchors.topMargin: 40
        anchors.left: boardNormalImg.left ; anchors.leftMargin: 8
        spacing: 5
        Text{
            id: powerLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.family: "Segoe UI Symbol"
            font.bold: true
            font.pixelSize: 12
            text: "Power (%)"
            horizontalAlignment: Text.AlignHCenter
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
                Keys.onPressed: {
                    if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
                                 powerSlider.value = text
                                 event.accepted = true;
                             }
                }
            }
        }
    }
    Row{
        id: polesRow
        anchors.top: powerRow.bottom; anchors.topMargin: 40
        anchors.left: boardNormalImg.left; anchors.leftMargin: 10
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
        anchors.top: polesRow.bottom ; anchors.topMargin: 10
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
                NumberAnimation { target: dialogContainer; property: "opacity";  duration: 500; }
                NumberAnimation { target: dialogContainer; property: "scale"; to: 0.5; duration: 500; easing.type: Easing.Bezier}
            }
        }
        ,Transition {
            from: "hideDialog" ; to: "showDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity"; duration: 1000; }
                NumberAnimation { target: dialogContainer; property: "scale"; to: 1; duration: 1000; easing.type: Easing.OutElastic}
            }

        }
    ]
}
