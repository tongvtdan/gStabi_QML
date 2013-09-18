import QtQuick 2.0

GFrame {
    id: manualControlSettingsContainer

    property int    control_type_selected   : 0
    property int    rc_mode_channel_num     : 1
    property int    rc_mode_level           : 0
    property int    rc_mode_pwm_level       : 0
    property string rc_setting_state        : "pwm"

    border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_normal_manual_control_frame.png"
    border_hover: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_hover_manual_control_frame.png"

    width: 770

    // Control Type
    GListView{
        id: controlTypeList;
        width: 200; height: 60
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.top: parent.top ; anchors.topMargin: 15

        list_header_title: "Control Type"
        orientation: ListView.Horizontal
        onClicked: {
            control_type_selected = item_index
        }
        Component.onCompleted: {
            controlTypeList.list_model.append({"value": "PWM"});
            controlTypeList.list_model.append({"value": "SBUS"});
            controlTypeList.list_model.append({"value": "gMotion"});
            controlTypeList.list_model.append({"value": "PC"});
        }
    }

    Row{
        id: rcSettingRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: controlTypeList.bottom; anchors.topMargin: 20
        spacing: 10
        GRCSettings{
            id: tiltRC
            onLpf_valueChanged          :   _mavlink_manager.tilt_lpf = lpf_value;
            onTrim_valueChanged         :   _mavlink_manager.tilt_trim = trim_value;
            onRc_channel_numChanged     :   _mavlink_manager.tilt_sbus_chan_num = rc_channel_num;

        }
        GRCSettings{
            id: panRC
            title: "Pan"
            onLpf_valueChanged:     _mavlink_manager.pan_lpf = lpf_value;
            onTrim_valueChanged:    _mavlink_manager.pan_trim = trim_value;
        }
        GRCSettings{
            id: rollRC
            title: "Roll"
            onLpf_valueChanged:     _mavlink_manager.roll_lpf = lpf_value;
            onTrim_valueChanged:    _mavlink_manager.roll_trim = trim_value;
        }
    }
    Rectangle{
        id: modeChannelContainer
        state: rc_setting_state
        color: "transparent"
        radius: 5
        anchors.left: controlTypeList.right
        anchors.leftMargin: 120
        anchors.top: parent.top
        anchors.topMargin: 40
        border.color: "cyan"; border.width: 1
        width: 220; height: 30
        visible:(control_type_selected == 0 || control_type_selected == 1)// rc_enabled
        GTextStyled{
            id: titleText
            text: "Mode";
            anchors.top: parent.top
            anchors.topMargin: -20
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 14; color: "cyan"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Row{
            id: modeNumRow
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 7
            GTextStyled{
                text: "Channel"
                anchors.verticalCenter: parent.verticalCenter
                color: "cyan"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 12
            }
            GTextInput{
                id: rcModeChannelNumInput
                width: 30
                height: 15
                bottom_value: 1 ;top_value: 18
                text_value: rc_mode_channel_num
                onText_valueChanged: rc_mode_channel_num = text_value
            }
        }

        Item{
            id: rcModeLevel
            width: rcValueChannelIndicator.width; height: rcValueChannelIndicator.height
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            GSlider{
                id: rcValueChannelIndicator
                display_only: true
                width: 100
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
        states: [
            State {
                name: "sbus"
                PropertyChanges {  target: modeNumRow;    visible: true     }
                PropertyChanges {  target: rcModeLevel;  visible: true   }
            },
            State {
                name: "pwm"
                PropertyChanges { target: modeNumRow;    visible: false   }
                PropertyChanges { target: rcValueChannelIndicator ; width: 170 }
                PropertyChanges { target: rcModeLevel ; anchors.leftMargin: -70 }
            },
            State {
                name: "other"
                PropertyChanges {  target: modeNumRow;    visible: false  }
                PropertyChanges {  target: rcModeLevel;  visible: false }
            }

        ]

    }
    onRc_mode_channel_numChanged: {rcModeChannelNumInput.text_value = rc_mode_channel_num }
    onRc_mode_levelChanged:  {
        if(rc_mode_level > 500) rc_mode_level =500;
        if(rc_mode_level < -500) rc_mode_level = -500;
        rcValueChannelIndicator.value = rc_mode_level + 500;
    }
    onRc_mode_pwm_levelChanged: {
        if(rc_mode_pwm_level > 500) rc_mode_pwm_level =500;
        if(rc_mode_pwm_level < -500) rc_mode_pwm_level = -500;
        rcValueChannelIndicator.value = rc_mode_pwm_level + 500;
    }

    onControl_type_selectedChanged:{
        // reset all variables before they can be set
        motor_control_enabled = false
        popup_show = false
        rc_setting_state = "other"
        // temporary comment for testing function

//        if(_serialLink.isConnected)
//        {
            _mavlink_manager.control_type = control_type_selected;
//            _mavlink_manager.write_params_to_board();

            switch(control_type_selected){
            case 0:   // PWM
                rc_setting_state = "pwm"
                break;
            case 1:   // SBUS
                rc_setting_state = "sbus"
                break;
            case 2:   // gMotion
//                popup_msg = "gMotion was chosen\n
//To activate gMotion:\n
//1/ Press Write button to save parameters to gStabi Controller.\n
//2/ Disconnect PC from gStabi Controller.\n
//3/ Power gMotion."
                popup_msg = "This feature is used with gMotion System"
                popup_show = true
                break;
            case 3:  // PC
                motor_control_enabled = true
                break;
            default:
                break;
            }
//        }
//        else{
//            popup_msg = "Controller board is not connected. Please connect the board to your PC through USB cable then try again"
//            popup_show = true;
//        }
    }
    Connections{
        target: _mavlink_manager
        onControl_typeChanged:{
            control_type_selected  =  _mavlink_manager.control_type
            controlTypeList.current_index = _mavlink_manager.control_type
        }

        onTilt_lpfChanged           : tiltRC.lpf_value        = _mavlink_manager.tilt_lpf;
        onTilt_trimChanged          : tiltRC.trim_value       = _mavlink_manager.tilt_trim;
        onTilt_sbus_chan_numChanged : tiltRC.rc_channel_num   = _mavlink_manager.tilt_sbus_chan_num;
        onTilt_rc_sbus_levelChanged : tiltRC.rc_value         = _mavlink_manager.tilt_rc_sbus_level;
        onTilt_pwm_levelChanged     : tiltRC.rc_pwm_level     = _mavlink_manager.tilt_pwm_level;

        onPan_lpfChanged            : panRC.lpf_value      = _mavlink_manager.pan_lpf;
        onPan_trimChanged           : panRC.trim_value     = _mavlink_manager.pan_trim;
        onPan_sbus_chan_numChanged  : panRC.rc_channel_num = _mavlink_manager.pan_sbus_chan_num;
        onPan_rc_sbus_levelChanged  : panRC.rc_value       = _mavlink_manager.pan_rc_sbus_level;
        onPan_pwm_levelChanged      : panRC.rc_pwm_level   = _mavlink_manager.pan_pwm_level;

        onRoll_lpfChanged           : rollRC.lpf_value        = _mavlink_manager.roll_lpf;
        onRoll_trimChanged          : rollRC.trim_value       = _mavlink_manager.roll_trim;
        onRoll_sbus_chan_numChanged : rollRC.rc_channel_num   = _mavlink_manager.roll_sbus_chan_num;
        onRoll_rc_sbus_levelChanged : rollRC.rc_value         = _mavlink_manager.roll_rc_sbus_level;
        onRoll_pwm_levelChanged     : rollRC.rc_pwm_level     = _mavlink_manager.roll_pwm_level;

        onMode_sbus_chan_numChanged : rc_mode_channel_num     = _mavlink_manager.mode_sbus_chan_num;
        onMode_rc_sbus_levelChanged : rc_mode_level           = _mavlink_manager.mode_rc_sbus_level;
        onMode_pwm_levelChanged     : rc_mode_pwm_level       = _mavlink_manager.mode_pwm_level;
    }

}
