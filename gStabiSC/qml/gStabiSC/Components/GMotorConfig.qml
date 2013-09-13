import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer

    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10
    property int    motor_dir   : 0
    property int    lpf_value   : 0
    property int    trim_value  : 0
    property int   angle_mode   : 0

    property string border_normal   : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_tilt_normal_frame.png"
    property string border_hover    : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_hover_frame.png"
//    property string border_normal   : "../images/gStabiUI_3.2_normal_parameters_dialog.png"
//    property string border_hover    : "../images/gStabiUI_3.2_hover_parameters_dialog.png"


    width: 310; height:  230

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: boarderHoverImg.visible = true
        onExited: boarderHoverImg.visible = false
    }
    BorderImage {
        id: boardNormalImg
        asynchronous: true
        width: parent.width ; height: parent.height
        border.left: 5; border.top: 5 ;border.right: 5; border.bottom: 5
        anchors.top: parent.top;
        source: border_normal
    }
    BorderImage {
        id: boarderHoverImg
        asynchronous: true
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
        anchors.top: boardNormalImg.top; anchors.topMargin: 30
        anchors.left: boardNormalImg.left ; anchors.leftMargin: 8
        spacing: 5
        GTextStyled{
            id: powerLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Power (%)"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: powerSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 180; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: power_level
            onValueChanged: power_level = powerSlider.value
        }
        GTextInput{
            id: powerLevelInput
            bottom_value: 0; top_value: 100
            onText_valueChanged: power_level = text_value
        }
    }
    Row{
        id: polesRow
        height: 20
        anchors.top: powerRow.bottom; anchors.topMargin: 10
        anchors.left: boardNormalImg.left; anchors.leftMargin: 15
        spacing: 10
        GTextStyled{
            id: polesLabel
            width: 45; height: 20
            color : "#00e3f9"
            font.pixelSize: 16
            text: "Poles:"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GTextInput{
            id: polesNumInput
            bottom_value: 0; top_value: 100
            read_only: true
            text_value: poles_num
            onText_valueChanged: poles_num = text_value
        }
    }
    Row{
        id: minRow
        width: 100; height: 20
        anchors.top: polesRow.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 30
        spacing: 5
        GTextStyled{
            width: 40
            height: 20
            color : "#00e3f9"
            text: "Min:"
            font.pixelSize: 16
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

    Row{
        id: maxRow
        width: 100; height: 20
        anchors.top: minRow.top
        anchors.topMargin: 0
        anchors.left: minRow.right
        anchors.leftMargin: 20
        spacing: 5
        GTextStyled{
            width: 40
            height: 20
            color : "#00e3f9"
            text: "Max:"
            font.pixelSize: 16
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
    Row{
        id: lpfRow
        width: 300
        anchors.top: minRow.bottom; anchors.topMargin: 15
        anchors.left: parent.left; anchors.leftMargin: 10
        spacing: 5
        GTextStyled{
            id: lpfLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "LPF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: lpfSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 180; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: lpf_value
            onValueChanged: lpf_value = lpfSlider.value
        }
        GTextInput{
            id: lpfLevelInput
            bottom_value: 0; top_value: 100
            onText_valueChanged: lpf_value = text_value
        }
    }
    Row{
        id: trimRow
        width: 300
        anchors.top: lpfRow.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.leftMargin: 10
        spacing: 5
        GTextStyled{
            id: trimLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "TRIM"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: trimSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 180; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: trim_value
            onValueChanged: trim_value = trimSlider.value
        }
        GTextInput{
            id: trimLevelInput
            bottom_value: 0; top_value: 100
            onText_valueChanged: trim_value = text_value
        }
    }

    GCheckBox{
        id: angleModeChecked
        checkbox_text: "Angle"
        anchors.top: trimRow.bottom ; anchors.topMargin: 10
        anchors.left: parent.left;  anchors.leftMargin: 20
        state:  "unchecked"
        onChecked_stateChanged: {
            angle_mode = 0  // angle mode
            velocityModeChecked.checked_state = !checked_state
        }

    }
    GCheckBox{
        id: velocityModeChecked
        checkbox_text: "Velocity"
        anchors.top: angleModeChecked.top ; anchors.topMargin: 0
        anchors.left: angleModeChecked.right;  anchors.leftMargin: 20
        state:  "unchecked"
        onChecked_stateChanged: {
            angle_mode = 1  // velocity mode
            angleModeChecked.checked_state = !checked_state

        }

    }

    onPower_levelChanged: {
        powerLevelInput.text_value = power_level;
        powerSlider.value = power_level;
    }
    onPoles_numChanged: {
        polesNumInput.text_value = poles_num;
    }
    onMotor_dirChanged: reversedCheckBox.checked_state = motor_dir;
    onLpf_valueChanged: {
        lpfLevelInput.text_value = lpf_value
        lpfSlider.value = lpf_value
    }
    onTrim_valueChanged: {
        trimLevelInput.text_value = trim_value
        trimSlider.value = trim_value
    }

}
