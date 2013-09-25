import QtQuick 2.0
import "../Components"

Item{
    id: controllerParamsDialog

    width: 960; height: 280
    // Tilt Axis Motor
    Item{
        id: tiltItems
        anchors.left: parent.left; anchors.leftMargin: 0
        anchors.top: parent.top; anchors.topMargin: 20
        GParametersContainer{
            id: tiltParameters
            anchors.left: parent.left; anchors.leftMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
            title: "TILT"
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
        anchors.top: parent.top; anchors.topMargin: 20
        GParametersContainer{
            id: panParameters
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 0
            title: "PAN"
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
        anchors.right: parent.right; anchors.rightMargin: 0
        anchors.top: parent.top; anchors.topMargin: 20
        GParametersContainer{
            id: rollParameters
            anchors.right: parent.right; anchors.rightMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
            title: "ROLL"
            onP_valueChanged:       _mavlink_manager.roll_kp     = p_value;
            onI_valueChanged:       _mavlink_manager.roll_ki     = i_value;
            onD_valueChanged:       _mavlink_manager.roll_kd     = d_value;
            onFilter_valueChanged:  {_mavlink_manager.roll_filter = filter_value; }
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

}
