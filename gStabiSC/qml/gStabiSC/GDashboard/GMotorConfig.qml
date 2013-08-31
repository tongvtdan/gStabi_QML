import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10

    property string border_normal   : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_parameters_dialog.png"
    property string border_hover    : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_hover_parameters_dialog.png"
//    property string border_normal   : "../images/gStabiUI_3.2_normal_parameters_dialog.png"
//    property string border_hover    : "../images/gStabiUI_3.2_hover_parameters_dialog.png"


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
            font.family: "Segoe UI"
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
        GTextInput{
            id: powerLevelInput
            bottom_value: 0; top_value: 100
            text_value: power_level
            onText_valueChanged: power_level = text_value
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
            font.family: "Segoe UI"
            font.bold: true
            font.pixelSize: 16
            text: "Poles:"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GTextInput{
            id: polesNumInput
            bottom_value: 0; top_value: 100
            text_value: poles_num
            onText_valueChanged: poles_num = text_value
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
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: parent.top
//            anchors.topMargin: 0
        }
        GTextInput{
            id: maxLimitInput
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 0
            bottom_value: 0; top_value:  180
            text_value: max_value
            onText_valueChanged: max_value = text_value
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
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: parent.top
//            anchors.topMargin: 0
        }
        GTextInput {
            id: minLimitInput
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 0
            bottom_value: -180; top_value: 0
            text_value: min_value
            onText_valueChanged: min_value = text_value
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
            PropertyChanges { target: dialogContainer; opacity: 1; scale: 1 }
        }
        ,State {
            name: "hideDialog"
            PropertyChanges {target: dialogContainer; opacity: 0; scale: 0.5}
        }

    ]
    transitions: [
        Transition {
            from: "showDialog" ; to:   "hideDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity";  duration: 500; }
                NumberAnimation { target: dialogContainer; property: "scale"; duration: 500; easing.type: Easing.Bezier}
            }
        }
        ,Transition {
            from: "hideDialog" ; to: "showDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity"; duration: 1000; }
                NumberAnimation { target: dialogContainer; property: "scale"; duration: 1000; easing.type: Easing.OutElastic}
            }

        }
    ]
}
