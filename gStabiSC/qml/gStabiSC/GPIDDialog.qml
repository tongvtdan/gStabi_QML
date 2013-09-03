import QtQuick 2.0
import "Components"

GSettingDialog{
    id: pidDialog

    property string msg_log: "PID Dialog Log"

    title: "Controller Parameters"
    state:"showDialog"
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
        }
        GParametersContainer{
            id: tiltParameters
            height: 350
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
        }
        GParametersContainer{
            id: panParameters
            height: 350
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 0
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
        }
        GParametersContainer{
            id: rollParameters
            height: 350
            anchors.right: parent.right; anchors.rightMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
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
                onClicked: {pidDialog.state = "hideDialog";}
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
    }
    /* function dialog_log(_message)
       @brief: put message to log
       @input: _message
       @output: msg_log in HTML format
      */
    function dialog_log(_message){
        msg_log = "<font color=\"red\">" + _message+ "</font><br>";
    }

}
