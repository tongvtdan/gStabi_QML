import QtQuick 2.0
import "Components"
Item{
    GMotorConfig{
        id: tiltConfigDialog
        anchors.horizontalCenter: tiltGauge.horizontalCenter
        anchors.top: tiltGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        min_limit_label: "Tilt up limit"
        max_limit_label: "Tilt down limit"
        onMax_valueChanged: {
            _mavlink_manager.tilt_down_limit_angle = max_value;
            tiltGauge.gauge_down_limit_set_angle = max_value
        }
        onMin_valueChanged: {
            _mavlink_manager.tilt_up_limit_angle = min_value;
            tiltGauge.gauge_up_limit_set_angle = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.tilt_power = power_level;
        onPoles_numChanged:     _mavlink_manager.motor_tilt_num_poles = poles_num;
        onMotor_dirChanged:     _mavlink_manager.motor_tilt_dir = motor_dir;

    }
    GMotorConfig{
        id: panConfigDialog
        anchors.horizontalCenter: panGauge.horizontalCenter
        anchors.top: panGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        min_limit_label: "Pan left limit"
        max_limit_label: "Pan right limit"
        onMax_valueChanged: {
            _mavlink_manager.pan_cw_limit_angle = max_value;
            panGauge.gauge_down_limit_set_angle = max_value;
        }
        onMin_valueChanged: {
            _mavlink_manager.pan_ccw_limit_angle = min_value;
            panGauge.gauge_up_limit_set_angle = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.pan_power = power_level;
        onPoles_numChanged:     {_mavlink_manager.motor_pan_num_poles = poles_num; console.log("#Pole Changed")}
        onMotor_dirChanged:     _mavlink_manager.motor_pan_dir = motor_dir;

    }
    GMotorConfig{
        id: rollConfigDialog
        anchors.horizontalCenter: rollGauge.horizontalCenter
        anchors.top: rollGauge.bottom ; anchors.topMargin: -10
        opacity: 0
        min_limit_label: "Roll up limit"
        max_limit_label: "Roll down limit"
        onMax_valueChanged: {
            _mavlink_manager.roll_down_limit_angle = max_value;
            rollGauge.gauge_down_limit_set_angle = max_value;
        }
        onMin_valueChanged: {
            _mavlink_manager.roll_up_limit_angle = min_value;
            rollGauge.gauge_up_limit_set_angle = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.roll_power = power_level;
        onPoles_numChanged:     _mavlink_manager.motor_roll_num_poles = poles_num;
        onMotor_dirChanged:     _mavlink_manager.motor_roll_dir = motor_dir;

    }

}
