import QtQuick 2.0

Rectangle {
    id: rcSettingsContainer
    property string title               : "Tilt"
    property int    lpf_value           : 5
    property int    trim_value          : 5
    property int    rc_channel_num      : 1
    property int    rc_value            : 50
    property int    rc_pwm_level        : 50
    property bool   speed_mode          : false   // 0: angle mode; 1: speed mode



    width: 240;     height: 120
    color: "transparent"
    radius: 5
    border.color: "cyan"; border.width: 1
    state: rc_setting_state
    GTextStyled{
        id: titleText
        text: title;
        anchors.top: parent.top
        anchors.topMargin: -20
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 14; color: "cyan"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

    }
    Row{
        id: lpfRow
        width: 220
        height: 20
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left; anchors.leftMargin: 5
        spacing: 10
        GTextStyled{
            id: lpfLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Smooth"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: lpfSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 120; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: lpf_value
            onValueChanged: lpf_value = lpfSlider.value
        }
        GTextInput{
            id: lpfLevelInput
            bottom_value: 0; top_value: 100
            text_value: lpf_value.toString()
            onText_valueChanged: lpf_value = text_value
        }
    }

    Row{
        id: trimRow
        width: 220
        anchors.top: lpfRow.bottom; anchors.topMargin: 5
        anchors.left: parent.left; anchors.leftMargin: 5
        spacing: 10
        GTextStyled{
            id: trimLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Trim"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: trimSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 120; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: trim_value
            onValueChanged: trim_value = trimSlider.value
        }
        GTextInput{
            id: trimLevelInput
            bottom_value: 0; top_value: 100
            text_value: trim_value.toString()
            onText_valueChanged: trim_value = text_value
        }
    }

    Row{
        id: channeNumlRow
        spacing: 7
        anchors.left: parent.left ;  anchors.leftMargin: 5
        anchors.top: trimRow.bottom ;anchors.topMargin: 10
        GTextStyled{
            text: "Channel"
            anchors.verticalCenter: parent.verticalCenter
            color: "cyan"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 12
        }
        GTextInput{
            id: channelValue
            width: 30
            height: 15
            bottom_value: 1 ;top_value: 18
            text_value: rc_channel_num
            onText_valueChanged: rc_channel_num = text_value
        }
    }

    Item{
        id: rcSBUS_PWM_Level
        width: rcValueChannelIndicator.width; height: rcValueChannelIndicator.height
        anchors.top: channeNumlRow.top;  anchors.topMargin: 0
        anchors.left: channeNumlRow.right ;  anchors.leftMargin: 10
        GSlider{
            id: rcValueChannelIndicator
            display_only: true
            width: 130
            height: 15
            lowerLimit: 0; upperLimit: 1000
            GTextStyled {
                id: rcValueChannelLevelLabel
                width: 10
                color: "#035bf3"
                text: rcValueChannelIndicator.value-500

                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    Item{
        id: modeContainer
        anchors.left: parent.left;   anchors.leftMargin: 5
        anchors.top: rcSBUS_PWM_Level.bottom; anchors.topMargin: 10
        width: 230 ;    height: 30
        GCheckBox{
            id: angleModeChecked
            height: 30
            checked_state: true
            anchors.left: parent.left;       anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            checkbox_text: "Angle Mode"
            state: "checked"
            onChecked_stateChanged: {
                speed_mode = !checked_state
            }
        }
        GCheckBox{
            id: velocityModeChecked
            height: 30
            checked_state: false
            anchors.left: angleModeChecked.right;    anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            checkbox_text: "Speed Mode"
            state: "unchecked"
            onChecked_stateChanged: {
                speed_mode = checked_state
            }
        }
    }
    states: [
        State {
            name: "sbus"
            PropertyChanges {  target: channeNumlRow;    visible: true     }
            PropertyChanges {  target: rcSBUS_PWM_Level;  visible: true   }
        },
        State {
            name: "pwm"
            PropertyChanges {  target: channeNumlRow;    visible: false   }
            PropertyChanges { target: rcValueChannelIndicator ; width: 210 }
            PropertyChanges { target: rcSBUS_PWM_Level ; anchors.leftMargin: -70 }
        },
        State {
            name: "other"
            PropertyChanges {  target: channeNumlRow;    visible: false  }
            PropertyChanges {  target: rcSBUS_PWM_Level;  visible: false }
        }

    ]

    onLpf_valueChanged: {
        lpfLevelInput.text_value = lpf_value
        lpfSlider.value = lpf_value
    }
    onTrim_valueChanged: {
        trimLevelInput.text_value = trim_value
        trimSlider.value = trim_value
    }
    onRc_channel_numChanged: {
        channelValue.text_value = rc_channel_num
    }
    onRc_valueChanged: {
        if(rc_value > 500) rc_value =500;
        if(rc_value < -500) rc_value = -500;
        rcValueChannelIndicator.value = rc_value + 500;
    }
    onRc_pwm_levelChanged: {
        if(rc_pwm_level > 500) rc_pwm_level =500;
        if(rc_pwm_level < -500) rc_pwm_level = -500;
        rcValueChannelIndicator.value = rc_pwm_level + 500;
    }
    onSpeed_modeChanged: {
        angleModeChecked.checked_state = !speed_mode
        velocityModeChecked.checked_state = speed_mode
    }
}
