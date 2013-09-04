import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10
    property int    motor_dir   : 0
    property int    rc_lpf      : 0
    property string min_limit_label: "Min"
    property string max_limit_label: "Max"


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
//            text_value: power_level
            onText_valueChanged: power_level = text_value
        }

    }
    Row{
        id: polesRow
        height: 20
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
        x: 194
        y: 136
        width: 50; height: 45
        anchors.horizontalCenterOffset: 70
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        Text{
            width: 40
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI"
            font.bold: true
            font.pixelSize: 16
            text: max_limit_label
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        GTextInput{
            id: maxLimitInput
            bottom_value: 0; top_value:  180
            text_value: max_value
            onText_valueChanged: max_value = text_value
        }
    }
    Column{
        id: minColumn
        x: 55
        y: 136
        width: 50; height: 45
        anchors.horizontalCenterOffset: -70
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        Text{
            width: 40
            height: 20
            color : "#00e3f9"
            font.family: "Segoe UI"
            font.bold: true
            font.pixelSize: 16
            text: min_limit_label
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        GTextInput {
            id: minLimitInput
            bottom_value: -180; top_value: 0
            text_value: min_value
            onText_valueChanged: min_value = text_value
        }
    }
    GCheckBox{
        id: reversedCheckBox
        checkbox_text: "Reverse"
        anchors.top: polesRow.top ; anchors.topMargin: -5
        anchors.left: polesRow.right;  anchors.leftMargin: 20
        state:  "unchecked"
        onChecked_stateChanged: {
            motor_dir = checked_state;
        }
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
    onPower_levelChanged: {
        powerLevelInput.text_value = power_level;
        powerSlider.value = power_level;
    }
    onPoles_numChanged: {
        polesNumInput.text_value = poles_num;
    }
    onMotor_dirChanged: reversedCheckBox.checked_state = motor_dir;
}
