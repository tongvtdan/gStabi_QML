import QtQuick 2.0
import "Components"
GContainer{
    id: mainContainer

    property int  tilt_down_limit: 0
    property int  tilt_up_limit: 0
    property int  pan_cw_limit: 0
    property int  pan_ccw_limit: 0
    property int  roll_up_limit: 0
    property int  roll_down_limit: 0

    hide_scale: 0
    height: 250 ; width: 930
    Row{
        id: motorsParamsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0
    GMotorConfig{
        id: tiltMotorParams
        width: 310; height: 210
//        opacity: 0
        min_limit_label: "Tilt up limit"
        max_limit_label: "Tilt down limit"
        onMax_valueChanged: {
            _mavlink_manager.tilt_down_limit_angle = max_value; // update variable in mavlink, in cpp file
            tilt_down_limit = max_value                         // update to Gauge display
        }
        onMin_valueChanged: {
            _mavlink_manager.tilt_up_limit_angle = min_value;
            tilt_up_limit = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.tilt_power = power_level;
        onPoles_numChanged:     _mavlink_manager.motor_tilt_num_poles = poles_num;
        onMotor_dirChanged:     _mavlink_manager.motor_tilt_dir = motor_dir;

    }
    GMotorConfig{
        id: panMotorParams
        width: 310; height: 210
//        opacity: 0
        min_limit_label: "Pan left limit"
        max_limit_label: "Pan right limit"
        onMax_valueChanged: {
            _mavlink_manager.pan_cw_limit_angle = max_value;
           pan_cw_limit = max_value;
        }
        onMin_valueChanged: {
            _mavlink_manager.pan_ccw_limit_angle = min_value;
            pan_ccw_limit = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.pan_power = power_level;
        onPoles_numChanged:     {_mavlink_manager.motor_pan_num_poles = poles_num; console.log("#Pole Changed")}
        onMotor_dirChanged:     _mavlink_manager.motor_pan_dir = motor_dir;

    }
    GMotorConfig{
        id: rollMotorParams
        width: 310; height: 210
//        opacity: 0
        min_limit_label: "Roll up limit"
        max_limit_label: "Roll down limit"
        onMax_valueChanged: {
            _mavlink_manager.roll_down_limit_angle = max_value;
            roll_down_limit = max_value;
        }
        onMin_valueChanged: {
            _mavlink_manager.roll_up_limit_angle = min_value;
            roll_up_limit = min_value;
        }
        onPower_levelChanged:   _mavlink_manager.roll_power = power_level;
        onPoles_numChanged:     _mavlink_manager.motor_roll_num_poles = poles_num;
        onMotor_dirChanged:     _mavlink_manager.motor_roll_dir = motor_dir;

    }
}
    Connections{
        target: _mavlink_manager

        onTilt_powerChanged:            tiltMotorParams.power_level = _mavlink_manager.tilt_power;
        onMotor_tilt_num_polesChanged:  tiltMotorParams.poles_num   = _mavlink_manager.motor_tilt_num_poles;
        onMotor_tilt_dirChanged:        tiltMotorParams.motor_dir   = _mavlink_manager.motor_tilt_dir;
        onTilt_up_limit_angleChanged:   tiltMotorParams.min_value   = _mavlink_manager.tilt_up_limit_angle;
        onTilt_down_limit_angleChanged: tiltMotorParams.max_value   = _mavlink_manager.tilt_down_limit_angle;

        onPan_powerChanged:             panMotorParams.power_level = _mavlink_manager.pan_power;
        onMotor_pan_num_polesChanged:   panMotorParams.poles_num   = _mavlink_manager.motor_pan_num_poles;
        onMotor_pan_dirChanged:         panMotorParams.motor_dir   = _mavlink_manager.motor_pan_dir;
        onPan_ccw_limit_angleChanged:   panMotorParams.min_value   = _mavlink_manager.pan_ccw_limit_angle;
        onPan_cw_limit_angleChanged:    panMotorParams.max_value   = _mavlink_manager.pan_cw_limit_angle;

        onRoll_powerChanged:            rollMotorParams.power_level = _mavlink_manager.roll_power;
        onMotor_roll_num_polesChanged:  rollMotorParams.poles_num   = _mavlink_manager.motor_roll_num_poles;
        onMotor_roll_dirChanged:        rollMotorParams.motor_dir   = _mavlink_manager.motor_roll_dir;
        onRoll_up_limit_angleChanged:   rollMotorParams.min_value   = _mavlink_manager.roll_up_limit_angle;
        onRoll_down_limit_angleChanged: rollMotorParams.max_value   = _mavlink_manager.roll_down_limit_angle;
    }
}
