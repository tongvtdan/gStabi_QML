import QtQuick 2.0
import "../Components"

Item{
    id: dialogContainer


    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10
    property int    motor_dir   : 0
    property int    lpf_value   : 5
    property int    trim_value  : 5
    property string min_label   : "Min"
    property string max_label   : "Max"

    property bool   speed_mode  : false   // 0: angle mode; 1: speed mode

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
        anchors.top: boardNormalImg.top; anchors.topMargin: 40
        anchors.left: boardNormalImg.left ; anchors.leftMargin: 10
        spacing: 5
        GTextStyled{
            id: powerLabel
            width: 55; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Power (%)"
            horizontalAlignment: Text.AlignRight
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
            text_value: power_level.toString()
            onText_valueChanged: power_level = text_value
        }
    }

    Row{
        id: polesRow
        height: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: powerRow.bottom; anchors.topMargin: 30
        spacing: 10
        GTextStyled{
            id: polesLabel
            width: 45; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Poles:"
            anchors.right: polesNumInput.left
            anchors.rightMargin: 5
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GTextInput{
            id: polesNumInput
            anchors.right: parent.right
            anchors.rightMargin: 0
            bottom_value: 0; top_value: 100
            read_only: true
            text_value: poles_num
            onText_valueChanged: poles_num = text_value
        }
    }
    Row{
        id: maxRow
        width: 95; height: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: polesRow.bottom
        anchors.topMargin: 10
        spacing: 5
        GTextStyled{
            width: 40
            height: 20
            color : "#00e3f9"
            text: max_label
            anchors.right: maxLimitInput.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }
        GTextInput{
            id: maxLimitInput
            anchors.right: parent.right
            anchors.rightMargin: 0
            bottom_value: 0; top_value:  180
            text_value: max_value
            onText_valueChanged: max_value = text_value
        }
    }

    Row{
        id: minRow
        width: 95; height: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: maxRow.bottom
        anchors.topMargin: 10
        spacing: 5
        GTextStyled{
            width: 40
            height: 20
            color : "#00e3f9"
            text: min_label
            anchors.right: minLimitInput.left
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
        }
        GTextInput {
            id: minLimitInput
            anchors.right: parent.right
            anchors.rightMargin: 0
            bottom_value: -180; top_value: 0
            text_value: min_value
            onText_valueChanged: min_value = text_value
        }
    }



    GCheckBox{
        id: reversedCheckBox
        checkbox_text: "Reverse Direction"
        anchors.top: modeContainer.bottom; anchors.topMargin: 5
        anchors.left: modeContainer.left;  anchors.leftMargin: 5
        state:  "unchecked"
        onChecked_stateChanged: {
            motor_dir = checked_state;
        }
    }
    Rectangle{
        id: modeContainer
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: powerRow.bottom; anchors.topMargin: 30
        width: Math.max(angleModeChecked.width, velocityModeChecked.width) + 10
        height: (angleModeChecked.height + velocityModeChecked.height + 10)
        color: "transparent"
        radius: 5
        border.color: "cyan"; border.width: 1
        GCheckBox{
            id: angleModeChecked
            height: 30
            checkbox_text: "Angle Mode"
            anchors.top: powerRow.bottom ; anchors.topMargin: 5
            anchors.left: parent.left;  anchors.leftMargin: 5
            checked_state: !speed_mode
            onChecked_stateChanged: {
                speed_mode = !checked_state
            }
        }
        GCheckBox{
            id: velocityModeChecked
            checkbox_text: "Speed Mode"
            anchors.top: angleModeChecked.bottom ; anchors.topMargin: 5
            anchors.left: parent.left;  anchors.leftMargin: 5
            checked_state: speed_mode
            onChecked_stateChanged: {
                speed_mode = checked_state
            }
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

    onSpeed_modeChanged: {
        angleModeChecked.checked_state = !speed_mode
        velocityModeChecked.checked_state = speed_mode
    }

}
