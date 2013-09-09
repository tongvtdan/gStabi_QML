import QtQuick 2.0
import "Components"

GSettingDialog{
    id: controllerParamsDialog

    property string msg_log: "PID Dialog Log"

    title: "Controller Parameters"
    width: 930; height: 500
    // Tilt Axis Motor
    Item{
        id: tiltItems
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.top: parent.top; anchors.topMargin: 70
        GTextInput{
            width: 140
            read_only: true
            text_value: "Tilt Axis Motor"
            anchors.bottom: tiltParameters.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: tiltParameters.horizontalCenter
            onClicked: tiltParameters.visible = !tiltParameters.visible
        }
        GParametersContainer{
            id: tiltParameters
            height: 350
            visible: false
            anchors.left: parent.left; anchors.leftMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
            onP_valueChanged:       _mavlink_manager.tilt_kp     = p_value;
            onI_valueChanged:       _mavlink_manager.tilt_ki     = i_value;
            onD_valueChanged:       _mavlink_manager.tilt_kd     = d_value;
            onFilter_valueChanged:  _mavlink_manager.tilt_filter = filter_value;
            onFollow_valueChanged:  _mavlink_manager.tilt_follow = follow_value;
        }
    }
    // Pan Axis Motor
    Item{
        id: panItems
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 70

        GTextInput{
            width: 140
            read_only: true
            text_value: "Pan Axis Motor"
            anchors.bottom: panParameters.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: panParameters.horizontalCenter
            onClicked: panParameters.visible = !panParameters.visible

        }
        GParametersContainer{
            id: panParameters
            height: 350
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 0
            onP_valueChanged:       _mavlink_manager.pan_kp     = p_value;
            onI_valueChanged:       _mavlink_manager.pan_ki     = i_value;
            onD_valueChanged:       _mavlink_manager.pan_kd     = d_value;
            onFilter_valueChanged:  _mavlink_manager.pan_filter = filter_value;
            onFollow_valueChanged:  _mavlink_manager.pan_follow = follow_value;

        }
    }
    // Roll Axis Motor
    Item{
        id: rollItems
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.top: parent.top; anchors.topMargin: 70

        GTextInput{
            width: 140
            read_only: true
            text_value: "Roll Axis Motor"
            anchors.bottom: rollParameters.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: rollParameters.horizontalCenter
            onClicked: rollParameters.visible = !rollParameters.visible
        }
        GParametersContainer{
            id: rollParameters
            height: 350
            visible: false
            anchors.right: parent.right; anchors.rightMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
            onP_valueChanged:       _mavlink_manager.roll_kp     = p_value;
            onI_valueChanged:       _mavlink_manager.roll_ki     = i_value;
            onD_valueChanged:       _mavlink_manager.roll_kd     = d_value;
            onFilter_valueChanged:  _mavlink_manager.roll_filter = filter_value;
            onFollow_valueChanged:  _mavlink_manager.roll_follow = follow_value;

        }
    }
    Item{
        id: buttonsItem
        anchors.left: parent.left
        anchors.leftMargin: 200
        anchors.bottom: parent.bottom; anchors.bottomMargin: 60
        Row{
            spacing: 5
            GButton{
                id: readButton
                text: "Read"
                onClicked: {
                    if(_serialLink.isConnected){
                        _mavlink_manager.request_all_params();
                    }
                    else {dialog_log("Controller board is not connected. Please connect PC to the board then try again")}
                }
            }
            GButton{
                id: writeButton
                text: "Write"
                onClicked: {
                    if(_serialLink.isConnected) {
                        _mavlink_manager.write_params_to_board();
                    }
                    else {dialog_log("Controller board is not connected. Please connect PC to the board then try again")}
                }
            }
            GButton {
                id: closeDialogButton
                text: "Close"
                onClicked: {controllerParamsDialog.state = "hide";}
            }
        }
    }
    Connections{
        target: _mavlink_manager
        onTilt_kpChanged: tiltParameters.p_value = _mavlink_manager.tilt_kp
        onTilt_kiChanged: tiltParameters.i_value = _mavlink_manager.tilt_ki
        onTilt_kdChanged: tiltParameters.d_value = _mavlink_manager.tilt_kd
        onTilt_followChanged: tiltParameters.follow_value = _mavlink_manager.tilt_follow
        onTilt_filterChanged: tiltParameters.filter_value = _mavlink_manager.tilt_filter

        onPan_kpChanged: panParameters.p_value = _mavlink_manager.pan_kp
        onPan_kiChanged: panParameters.i_value = _mavlink_manager.pan_ki
        onPan_kdChanged: panParameters.d_value = _mavlink_manager.pan_kd
        onPan_followChanged: panParameters.follow_value = _mavlink_manager.pan_follow
        onPan_filterChanged: panParameters.filter_value = _mavlink_manager.pan_filter

        onRoll_kpChanged: rollParameters.p_value = _mavlink_manager.roll_kp
        onRoll_kiChanged: rollParameters.i_value = _mavlink_manager.roll_ki
        onRoll_kdChanged: rollParameters.d_value = _mavlink_manager.roll_kd
        onRoll_followChanged: rollParameters.follow_value = _mavlink_manager.roll_follow
        onRoll_filterChanged: rollParameters.filter_value = _mavlink_manager.roll_filter
    }
    /* function dialog_log(_message)
       @brief: put message to log
       @input: _message
       @output: msg_log in HTML format/plaintext format
      */
    function dialog_log(_message){
//        msg_log = "<font color=\"red\">" + _message+ "</font><br>";
        msg_log = _message + "\n"
    }


}
