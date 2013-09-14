import QtQuick 2.0

GFrame {
    id: manualControlSettingsContainer

    property int  control_type_selected: 0

    border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_normal_manual_control_frame.png"
    border_hover: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_focus_manual_control_frame.png"

    width: 650

    // Control Type
    GListView{
        id: controlTypeList;
        width: 200; height: 60
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.top: rcSettingRow.bottom; anchors.topMargin: 10
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
        anchors.top: parent.top ; anchors.topMargin: 40
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

    onControl_type_selectedChanged:{
        // reset all variables before they can be set
        motor_control_enabled = false
        popup_show = false

        if(_serialLink.isConnected) {
            _mavlink_manager.control_type = control_type_selected;
            _mavlink_manager.write_params_to_board();

            switch(control_type_selected){
            case 0:   // PWM
                break;
            case 1:   // SBUS
                break;
            case 2:   // gMotion
                popup_msg = "Disconnect system from PC then turn on gMotion System for pairing Bluetooth communication"
                popup_show = true
                break;
            case 3:  // PC
                motor_control_enabled = true
                break;
            }
        } else{
            popup_msg = "Controller board is not connected. Please connect the board to your PC through USB cable then try again"
            popup_show = true;
        }
    }
    Connections{
        target: _mavlink_manager
        onControl_typeChanged: controlTypeList.current_index = _mavlink_manager.control_type

        onTilt_lpfChanged             : tiltRC.lpf_value   = _mavlink_manager.tilt_lpf;
        onTilt_trimChanged            : tiltRC.trim_value  = _mavlink_manager.tilt_trim;

        onPan_lpfChanged             : panRC.lpf_value   = _mavlink_manager.pan_lpf;
        onPan_trimChanged            : panRC.trim_value  = _mavlink_manager.pan_trim;

        onRoll_lpfChanged             : rollRC.lpf_value   = _mavlink_manager.roll_lpf;
        onRoll_trimChanged            : rollRC.trim_value  = _mavlink_manager.roll_trim;



    }

}
