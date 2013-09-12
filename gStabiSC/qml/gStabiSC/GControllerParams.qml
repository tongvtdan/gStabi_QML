import QtQuick 2.0
import "Components"

GContainer{
    id: controllerParamsDialog

    property string msg_log: "PID Dialog Log"

    width: 930; height: 300
    // Tilt Axis Motor
    Item{
        id: tiltItems
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.top: parent.top; anchors.topMargin: 70
        GButton{
            text: "Tilt"
            anchors.left: tiltParameters.left;   anchors.leftMargin: 110
            anchors.bottom: tiltParameters.top; anchors.bottomMargin: 10
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

        GButton{
            text: "Pan"
            anchors.bottom: panParameters.top; anchors.bottomMargin: 10
            anchors.horizontalCenter: panParameters.horizontalCenter
        }
        GParametersContainer{
            id: panParameters
            height: 350
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
        anchors.right: parent.right; anchors.rightMargin: 5
        anchors.top: parent.top; anchors.topMargin: 70

        GButton{
            text: "Roll"
            anchors.right: rollParameters.right;   anchors.rightMargin: 110
            anchors.bottom: rollParameters.top; anchors.bottomMargin: 10
        }
        GParametersContainer{
            id: rollParameters
            height: 350
            anchors.right: parent.right; anchors.rightMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
            onP_valueChanged:       _mavlink_manager.roll_kp     = p_value;
            onI_valueChanged:       _mavlink_manager.roll_ki     = i_value;
            onD_valueChanged:       _mavlink_manager.roll_kd     = d_value;
            onFilter_valueChanged:  _mavlink_manager.roll_filter = filter_value;
            onFollow_valueChanged:  _mavlink_manager.roll_follow = follow_value;

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
