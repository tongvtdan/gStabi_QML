import QtQuick 2.0

GFrame {
    id: manualControlSettingsContainer

    property int  control_type_selected: -1
    property bool   rc_enabled: false
    property bool   m_read_only : false
    property string rc_label       : "Channel"
    property int  mode_channel_num: 1

    border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_normal_manual_control_frame.png"
    border_hover: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_focus_manual_control_frame.png"

    width: 650

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
        anchors.top: controlTypeList.bottom; anchors.topMargin: 20
        anchors.left: parent.left; anchors.leftMargin: 10
        spacing: 5
        GRCSettings{
            id: tiltRC
            onLpf_valueChanged:     _mavlink_manager.tilt_lpf = lpf_value;
            onTrim_valueChanged:    _mavlink_manager.tilt_trim = trim_value;
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
        color: "transparent"
        radius: 5
        anchors.left: controlTypeList.right
        anchors.leftMargin: 120
        anchors.top: parent.top
        anchors.topMargin: 40
        border.color: "cyan"; border.width: 1
        width: 100; height: 30
        visible: rc_enabled

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
            id: modeChannelRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 7
            GTextStyled{
                text: rc_label
                color: "cyan"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 12
            }
            GTextInput{
                id: modeChannelValue
                width: 30
                top_value: 18
                text_value: mode_channel_num.toString()
                read_only: m_read_only

            }
        }
    }
    onControl_type_selectedChanged:{
        // reset all variables before they can be set
        motor_control_enabled = false
        popup_show = false
        rc_enabled = false
        m_read_only = false

        // temporary comment for testing function

//        if(_serialLink.isConnected)
        {
//            _mavlink_manager.control_type = control_type_selected;
//            _mavlink_manager.write_params_to_board();

            switch(control_type_selected){
            case 0:   // PWM
                rc_enabled = true
                m_read_only = true
                rc_label = "Value"
                break;
            case 1:   // SBUS
                rc_enabled = true
                rc_label = "Channel"
                break;
            case 2:   // gMotion
                popup_msg = "Disconnect system from PC then turn on gMotion System for pairing Bluetooth communication"
                popup_show = true
                break;
            case 3:  // PC
                motor_control_enabled = true
                break;
            default:
                break;
            }
        }
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


        onTilt_lpfChanged             : tiltRC.lpf_value   = _mavlink_manager.tilt_lpf;
        onTilt_trimChanged            : tiltRC.trim_value  = _mavlink_manager.tilt_trim;

        onPan_lpfChanged             : panRC.lpf_value   = _mavlink_manager.pan_lpf;
        onPan_trimChanged            : panRC.trim_value  = _mavlink_manager.pan_trim;

        onRoll_lpfChanged             : rollRC.lpf_value   = _mavlink_manager.roll_lpf;
        onRoll_trimChanged            : rollRC.trim_value  = _mavlink_manager.roll_trim;



    }

}
