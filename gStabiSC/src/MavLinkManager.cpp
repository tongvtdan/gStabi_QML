#include "MavLinkManager.hpp"
#include <QDebug>
#include "configuration.h"

MavLinkManager::MavLinkManager(QObject *parent) :
    QObject(parent)
{
    linkConnectionTimer = new QTimer(this);
    linkConnectionTimer->setSingleShot(true);

    connect(linkConnectionTimer,SIGNAL(timeout()),this, SLOT(connection_timeout()));

    mavlink_init();
    system_msg_log = "";
}

void MavLinkManager::process_mavlink_message(QByteArray data)
{
    mavlink_message_t message;
    mavlink_status_t status;
    unsigned int decodeState;
    uint8_t byte;

    for(int position = 0; position < data.size(); position++)
    {
        byte = data[position];
        decodeState = mavlink_parse_char(MAVLINK_COMM_0,byte, &message, &status);
        if(decodeState) {
            RestartLinkConnectionTimer(1000);   // Connection OK, Restart the connection watchdog timer
            setboard_connection_state(ONLINE);
            if(first_data_pack){    // if it is the first time receive mavlink message
                first_data_pack = false; // From now on, all message is treated as normal.
                request_all_params();   // then request all parameters from Board
            }
            switch (message.msgid)
            {
            case MAVLINK_MSG_ID_HEARTBEAT:{ // get Heartbeat
                mavlink_msg_heartbeat_decode(&message,&m_mavlink_heartbeat);
                if(m_mavlink_heartbeat.mavlink_version == MAVLINK_VERSION ){
                    heartbeat_state = !heartbeat_state;
                    sethb_pulse(heartbeat_state);
                }
                else sethb_pulse(false);
            }
                break;
            case MAVLINK_MSG_ID_RAW_IMU: { // get raw IMU data
                raw_imu.xacc = mavlink_msg_raw_imu_get_xacc(&message);
                raw_imu.yacc = mavlink_msg_raw_imu_get_yacc(&message);
                raw_imu.zacc = mavlink_msg_raw_imu_get_zacc(&message);
                raw_imu.xgyro = mavlink_msg_raw_imu_get_xgyro(&message);
                raw_imu.ygyro = mavlink_msg_raw_imu_get_ygyro(&message);
                raw_imu.zgyro = mavlink_msg_raw_imu_get_zgyro(&message);
            }
                break;
            case MAVLINK_MSG_ID_ATTITUDE: { // get Attitude
                attitude.roll = mavlink_msg_attitude_get_roll(&message);
                attitude_degree.roll = attitude.roll*180/PI;     // convert to deg
                attitude.pitch = mavlink_msg_attitude_get_pitch(&message);
                attitude_degree.pitch = attitude.pitch*180/PI;
                attitude.yaw = mavlink_msg_attitude_get_yaw(&message);
                attitude_degree.yaw = attitude.yaw*180/PI;
                get_attitude_data();
            }
                break;
            case MAVLINK_MSG_ID_PARAM_VALUE: {// get parameters on board
                paramValue.param_index = mavlink_msg_param_value_get_param_index(&message);  // get param index
                paramValue.param_value = mavlink_msg_param_value_get_param_value(&message);  // get param value
                // update Parameters to currnt_params_on_board
                update_all_parameters(paramValue.param_index, paramValue.param_value);
            }
                break;
            case MAVLINK_MSG_ID_SBUS_CHAN_VALUES:{ // get SBUS channel values
                sbus_chan_values.ch1 = mavlink_msg_sbus_chan_values_get_ch1(&message);
                sbus_chan_values.ch2 = mavlink_msg_sbus_chan_values_get_ch2(&message);
                sbus_chan_values.ch3 = mavlink_msg_sbus_chan_values_get_ch3(&message);
                sbus_chan_values.ch4 = mavlink_msg_sbus_chan_values_get_ch4(&message);
                sbus_chan_values.ch5 = mavlink_msg_sbus_chan_values_get_ch5(&message);
                sbus_chan_values.ch6 = mavlink_msg_sbus_chan_values_get_ch6(&message);
                sbus_chan_values.ch7 = mavlink_msg_sbus_chan_values_get_ch7(&message);
                sbus_chan_values.ch8 = mavlink_msg_sbus_chan_values_get_ch8(&message);
                sbus_chan_values.ch9 = mavlink_msg_sbus_chan_values_get_ch9(&message);
                sbus_chan_values.ch10 = mavlink_msg_sbus_chan_values_get_ch10(&message);
                sbus_chan_values.ch11 = mavlink_msg_sbus_chan_values_get_ch11(&message);
                sbus_chan_values.ch12 = mavlink_msg_sbus_chan_values_get_ch12(&message);
                sbus_chan_values.ch13 = mavlink_msg_sbus_chan_values_get_ch13(&message);
                sbus_chan_values.ch14 = mavlink_msg_sbus_chan_values_get_ch14(&message);
                sbus_chan_values.ch15 = mavlink_msg_sbus_chan_values_get_ch15(&message);
                sbus_chan_values.ch16 = mavlink_msg_sbus_chan_values_get_ch16(&message);
                sbus_chan_values.ch17 = mavlink_msg_sbus_chan_values_get_ch17(&message);
                sbus_chan_values.ch18 = mavlink_msg_sbus_chan_values_get_ch18(&message);
            }
            break;
            case MAVLINK_MSG_ID_SYSTEM_STATUS:{
                m_g_system_status.battery_voltage = mavlink_msg_system_status_get_battery_voltage(&message);
                setbattery_voltage(m_g_system_status.battery_voltage);
                qDebug() << "Battery Level: " << m_g_system_status.battery_voltage;
            }
                break;

            default:
            break;
            } // end of switch
        }
    }
}

void MavLinkManager::connection_timeout()
{
    setboard_connection_state(OFFLINE);
    setmavlink_message_log("System does not response.");
    RestartLinkConnectionTimer(1000);
}

void MavLinkManager::link_connection_state_changed(bool connection_state)
{
    isConnected = connection_state;
    if(isConnected){
        linkConnectionTimer->start(5000); // 5s for Controller send the 1st message
    }
    else {
        linkConnectionTimer->stop();
        setboard_connection_state(OFFLINE);
    }
}

// Get Paramter to store in current_params_on_board

void MavLinkManager::update_all_parameters(uint8_t index, float value)
{

    switch(index)
    {
    case PARAM_VERSION:         current_params_on_board.version = value;
        break;
    case PARAM_SERIAL_NUMBER:   current_params_on_board.serialNumber = value;
        break;
    case PARAM_PITCH_P:         current_params_on_board.pitchKp = value;
        break;
    case PARAM_PITCH_I:         current_params_on_board.pitchKi = value;
        break;
    case PARAM_PITCH_D:         current_params_on_board.pitchKd = value;
        break;
    case PARAM_ROLL_P:          current_params_on_board.rollKp = value;
        break;
    case PARAM_ROLL_I:          current_params_on_board.rollKi = value;
        break;
    case PARAM_ROLL_D:          current_params_on_board.rollKd = value;
        break;
    case PARAM_YAW_P:           current_params_on_board.yawKp = value;
        break;
    case PARAM_YAW_I:           current_params_on_board.yawKi = value;
        break;
    case PARAM_YAW_D:           current_params_on_board.yawKd = value;
        break;
    case PARAM_PITCH_POWER:     current_params_on_board.pitchPower = value;
        break;
    case PARAM_ROLL_POWER:      current_params_on_board.rollPower = value;
        break;
    case PARAM_YAW_POWER:       current_params_on_board.yawPower = value;
        break;
    case PARAM_PITCH_FOLLOW:    current_params_on_board.pitchFollow = value;
        break;
    case PARAM_ROLL_FOLLOW:     current_params_on_board.rollFollow = value;
        break;
    case PARAM_YAW_FOLLOW:      current_params_on_board.yawFollow = value;
        break;
    case PARAM_PITCH_FILTER:    current_params_on_board.tiltFilter = value;
        break;
    case PARAM_ROLL_FILTER:     current_params_on_board.rollFilter = value;
        break;
    case PARAM_YAW_FILTER:      current_params_on_board.panFilter = value;
        break;
    case PARAM_GYRO_TRUST:      current_params_on_board.gyroTrust = value;
        break;
    case PARAM_NPOLES_PITCH:    current_params_on_board.nPolesPitch = value;
        break;
    case PARAM_NPOLES_ROLL:     current_params_on_board.nPolesRoll= value;
        break;
    case PARAM_NPOLES_YAW:      current_params_on_board.nPolesYaw = value;
        break;
    case PARAM_DIR_MOTOR_PITCH: current_params_on_board.dirMotorPitch = value;
        break;
    case PARAM_DIR_MOTOR_ROLL:  current_params_on_board.dirMotorRoll = value;
        break;
    case PARAM_DIR_MOTOR_YAW:   current_params_on_board.dirMotorYaw = value;
        break;
    case PARAM_MOTOR_FREQ:      current_params_on_board.motorFreq = value;
        break;
    case PARAM_RADIO_TYPE:      current_params_on_board.radioType = value;
        break;
    case PARAM_GYRO_LPF:        current_params_on_board.gyroLPF = value;
        break;
    case PARAM_TRAVEL_MIN_PITCH:current_params_on_board.travelMinPitch = value;
        break;
    case PARAM_TRAVEL_MAX_PITCH:current_params_on_board.travelMaxPitch = value;
        break;
    case PARAM_TRAVEL_MIN_ROLL: current_params_on_board.travelMinRoll = value;
        break;
    case PARAM_TRAVEL_MAX_ROLL: current_params_on_board.travelMaxRoll = value;
        break;
    case PARAM_TRAVEL_MIN_YAW:  current_params_on_board.travelMinYaw = value;
        break;
    case PARAM_TRAVEL_MAX_YAW:  current_params_on_board.travelMaxYaw = value;
        break;
    case PARAM_RC_PITCH_LPF:    current_params_on_board.rcPitchLPF = value;
        break;
    case PARAM_RC_ROLL_LPF:     current_params_on_board.rcRollLPF = value;
        break;
    case PARAM_RC_YAW_LPF:      current_params_on_board.rcYawLPF = value;
        break;
    case PARAM_SBUS_PITCH_CHAN: current_params_on_board.sbusPitchChan = value;
        break;
    case PARAM_SBUS_ROLL_CHAN:  current_params_on_board.sbusRollChan = value;
        break;
    case PARAM_SBUS_YAW_CHAN:   current_params_on_board.sbusYawChan = value;
        break;
    case PARAM_SBUS_MODE_CHAN:  current_params_on_board.sbusModeChan = value;
        break;
    case PARAM_ACCX_OFFSET:     current_params_on_board.accXOffset = value;
        break;
    case PARAM_ACCY_OFFSET:     current_params_on_board.accYOffset = value;
        break;
    case PARAM_ACCZ_OFFSET:     current_params_on_board.accZOffset = value;
        break;
    case PARAM_USE_GPS:         current_params_on_board.useGPS = value;
        break;
    case PARAM_GYROX_OFFSET:    current_params_on_board.gyroXOffset = value;
        break;
    case PARAM_GYROY_OFFSET:    current_params_on_board.gyroYOffset = value;
        break;
    case PARAM_GYROZ_OFFSET:    current_params_on_board.gyroZOffset = value;
        break;
    case PARAM_SKIP_GYRO_CALIB: current_params_on_board.skipGyroCalib = value;
        break;
    case PARAM_RC_PITCH_TRIM:   current_params_on_board.rcPitchTrim = value;
        break;
    case PARAM_RC_ROLL_TRIM:    current_params_on_board.rcRollTrim = value;
        break;
    case PARAM_RC_YAW_TRIM:     current_params_on_board.rcYawTrim = value;
        break;
    case PARAM_RC_PITCH_MODE:   current_params_on_board.rcPitchMode = value;
        break;
    case PARAM_RC_ROLL_MODE:    current_params_on_board.rcRollMode = value;
        break;
    case PARAM_RC_YAW_MODE:     current_params_on_board.rcYawMode = value;
        update_all_parameters_to_UI();
        break;
    default:
        break;
    }

}


void MavLinkManager::update_all_parameters_to_UI()
{
    if(!first_data_pack)    // to ensure all params read
    {
        setmavlink_message_log("Updating parameters...");
//        get_firmware_version();
//        get_hardware_serial_number();
        // General
        setcontrol_type(current_params_on_board.radioType);
        // Tilt
        settilt_kp(current_params_on_board.pitchKp);
        settilt_ki(current_params_on_board.pitchKi);
        settilt_kd(current_params_on_board.pitchKd);
        settilt_power(current_params_on_board.pitchPower);
        settilt_filter(current_params_on_board.tiltFilter);
        settilt_follow(current_params_on_board.pitchFollow);
        setmotor_tilt_dir(current_params_on_board.dirMotorPitch);
        setmotor_tilt_num_poles(current_params_on_board.nPolesPitch);
        settilt_up_limit_angle(current_params_on_board.travelMinPitch);
        settilt_down_limit_angle(current_params_on_board.travelMaxPitch);

        // Pan
        setpan_kp(current_params_on_board.yawKp);
        setpan_ki(current_params_on_board.yawKi);
        setpan_kd(current_params_on_board.yawKd);
        setpan_power(current_params_on_board.yawPower);
        setpan_filter(current_params_on_board.panFilter);
        setpan_follow(current_params_on_board.yawFollow);
        setmotor_pan_dir(current_params_on_board.dirMotorYaw);
        setmotor_pan_num_poles(current_params_on_board.nPolesYaw);
        setpan_ccw_limit_angle(current_params_on_board.travelMinYaw);
        setpan_cw_limit_angle(current_params_on_board.travelMaxYaw);

        // Roll
        setroll_kp(current_params_on_board.rollKp);
        setroll_ki(current_params_on_board.rollKi);
        setroll_kd(current_params_on_board.rollKd);
        setroll_power(current_params_on_board.rollPower);
        setroll_filter(current_params_on_board.rollFilter);
        setroll_follow(current_params_on_board.rollFollow);
        setmotor_roll_dir(current_params_on_board.dirMotorRoll);
        setmotor_roll_num_poles(current_params_on_board.nPolesRoll);
        setroll_up_limit_angle(current_params_on_board.travelMinRoll);
        setroll_down_limit_angle(current_params_on_board.travelMaxRoll);

        setmavlink_message_log("Updating parameters...Done");
    }
    else setmavlink_message_log("Waiting for reading parameters...");
}

void MavLinkManager::get_firmware_version()
{
    QString version_str;
    uint16_t tram=0, chuc=0, donvi=0, version_value=0;
    version_value = current_params_on_board.version;
    tram = uint16_t(uint16_t(version_value)/100);
    chuc = uint16_t((version_value%100)/10);
    donvi = uint16_t((version_value%100)%10);
    version_str = QString("%1.%2.%3") .arg(tram) .arg(chuc) .arg(donvi);
    setmavlink_message_log("Firmware ver.: " + version_str);
}

void MavLinkManager::get_hardware_serial_number()
{
    QString serial_no_str;
    serial_no_str =QString("%1").arg(current_params_on_board.serialNumber);
    setmavlink_message_log("Serial No.: " + serial_no_str);
}

void MavLinkManager::get_attitude_data()
{
    setroll_angle(attitude_degree.roll); // set value to Q_PROPERTY variables so they can be read from QML
    setpitch_angle(attitude_degree.pitch);           // set value to Q_PROPERTY variables so they can be read from QML
    setyaw_angle(attitude_degree.yaw);              // set value to Q_PROPERTY variables so they can be read from QML

}

void MavLinkManager::write_params_to_board()
{
    setmavlink_message_log("Sending parameters to controller board...");
    // Motor config params
// General
    if(control_type() != current_params_on_board.radioType){
        current_params_on_board.radioType = control_type();
        write_a_param_to_board("RADIO_TYPE", current_params_on_board.radioType);
    }
//    [1] Tilt Motor
    if(tilt_power() != current_params_on_board.pitchPower){  // if power level changed, it will be store in params
        current_params_on_board.pitchPower = tilt_power();   // update current value to params struct
        write_a_param_to_board("PITCH_POWER", current_params_on_board.pitchPower);
    }
    if(motor_tilt_dir() != current_params_on_board.dirMotorPitch){
        current_params_on_board.dirMotorPitch = motor_tilt_dir();   // update current value to params struct
        write_a_param_to_board("DIR_MOTOR_PITCH", current_params_on_board.dirMotorPitch);
    }
    if(motor_tilt_num_poles() != current_params_on_board.nPolesPitch){
        current_params_on_board.nPolesPitch = motor_tilt_num_poles();   // update current value to params struct
        write_a_param_to_board("NPOLES_PITCH", current_params_on_board.nPolesPitch);
    }
    if(tilt_up_limit_angle() != current_params_on_board.travelMinPitch){
        current_params_on_board.travelMinPitch = tilt_up_limit_angle();   // update current value to params struct
        write_a_param_to_board("TRAVEL_MIN_PIT",  current_params_on_board.travelMinPitch);
    }
    if(tilt_down_limit_angle() != current_params_on_board.travelMaxPitch){
        current_params_on_board.travelMaxPitch = tilt_down_limit_angle();   // update current value to params struct
        write_a_param_to_board("TRAVEL_MAX_PIT", current_params_on_board.travelMaxPitch);
    }

//    [2] Pan Motor
    if(pan_power() != current_params_on_board.yawPower){  // if power level changed, it will be store in params
        current_params_on_board.yawPower = pan_power();   // update current value to params struct
        write_a_param_to_board("YAW_POWER", current_params_on_board.yawPower);
    }
    if(motor_pan_dir() != current_params_on_board.dirMotorYaw){
        current_params_on_board.dirMotorYaw = motor_pan_dir();   // update current value to params struct
        write_a_param_to_board("DIR_MOTOR_YAW", current_params_on_board.dirMotorYaw);
    }
    if(motor_pan_num_poles() != current_params_on_board.nPolesYaw){
        current_params_on_board.nPolesYaw = motor_pan_num_poles();   // update current value to params struct
        write_a_param_to_board("NPOLES_YAW", current_params_on_board.nPolesYaw);
    }
    if(pan_ccw_limit_angle() != current_params_on_board.travelMinYaw){
        current_params_on_board.travelMinYaw = pan_ccw_limit_angle();   // update current value to params struct
        write_a_param_to_board("TRAVEL_MIN_YAW",  current_params_on_board.travelMinYaw);
    }
    if(pan_cw_limit_angle() != current_params_on_board.travelMaxYaw){
        current_params_on_board.travelMaxYaw = pan_cw_limit_angle();   // update current value to params struct
        write_a_param_to_board("TRAVEL_MAX_YAW", current_params_on_board.travelMaxYaw);
    }
    //    [3] Roll Motor
    if(roll_power() != current_params_on_board.rollPower){  // if power level changed, it will be store in params
        current_params_on_board.rollPower = roll_power();   // update current value to params struct
        write_a_param_to_board("ROLL_POWER", current_params_on_board.rollPower);
    }
    if(motor_roll_dir() != current_params_on_board.dirMotorRoll){
        current_params_on_board.dirMotorRoll = motor_roll_dir();   // update current value to params struct
        write_a_param_to_board("DIR_MOTOR_ROLL", current_params_on_board.dirMotorRoll);
    }
    if(motor_roll_num_poles() != current_params_on_board.nPolesRoll){
        current_params_on_board.nPolesRoll = motor_roll_num_poles();   // update current value to params struct
        write_a_param_to_board("NPOLES_ROLL", current_params_on_board.nPolesRoll);
    }
    if(roll_up_limit_angle() != current_params_on_board.travelMinRoll){
        current_params_on_board.travelMinRoll = roll_up_limit_angle();   // update current value to params struct
        write_a_param_to_board("TRAVEL_MIN_ROLL",  current_params_on_board.travelMinRoll);
    }
    if(roll_down_limit_angle() != current_params_on_board.travelMaxRoll){
        current_params_on_board.travelMaxRoll = roll_down_limit_angle();   // update current value to params struct
        write_a_param_to_board("TRAVEL_MAX_ROLL", current_params_on_board.travelMaxRoll);
    }

    // Controller Setting Params
//    [1] Tilt Motor
    if(tilt_kp() != current_params_on_board.pitchKp){
        current_params_on_board.pitchKp = tilt_kp();   // update current value to params struct
        write_a_param_to_board("PITCH_P", current_params_on_board.pitchKp);
    }
    if(tilt_ki() != current_params_on_board.pitchKi){
        current_params_on_board.pitchKi = tilt_ki();   // update current value to params struct
        write_a_param_to_board("PITCH_I", current_params_on_board.pitchKi);
    }
    if(tilt_kd() != current_params_on_board.pitchKd){
        current_params_on_board.pitchKd = tilt_kd();   // update current value to params struct
        write_a_param_to_board("PITCH_D", current_params_on_board.pitchKd);
    }
    if(tilt_follow() != current_params_on_board.pitchFollow){
        current_params_on_board.pitchFollow = tilt_follow();   // update current value to params struct
        write_a_param_to_board("PITCH_FOLLOW", current_params_on_board.pitchFollow);
    }
    if(tilt_filter() != current_params_on_board.tiltFilter){
        current_params_on_board.tiltFilter = tilt_filter();   // update current value to params struct
        write_a_param_to_board("PITCH_FILTER", current_params_on_board.tiltFilter);
    }
//    [2] Pan Motor
    if(pan_kp() != current_params_on_board.yawKp){
        current_params_on_board.yawKp = pan_kp();   // update current value to params struct
        write_a_param_to_board("YAW_P", current_params_on_board.yawKp);
    }
    if(pan_ki() != current_params_on_board.yawKi){
        current_params_on_board.yawKi = pan_ki();   // update current value to params struct
        write_a_param_to_board("YAW_I", current_params_on_board.yawKi);
    }
    if(pan_kd() != current_params_on_board.yawKd){
        current_params_on_board.yawKd = pan_kd();   // update current value to params struct
        write_a_param_to_board("YAW_D", current_params_on_board.yawKd);
    }
    if(pan_follow() != current_params_on_board.yawFollow){
        current_params_on_board.yawFollow = pan_follow();   // update current value to params struct
        write_a_param_to_board("YAW_FOLLOW", current_params_on_board.yawFollow);
    }
    if(pan_filter() != current_params_on_board.panFilter){
        current_params_on_board.panFilter = pan_filter();   // update current value to params struct
        write_a_param_to_board("YAW_FILTER", current_params_on_board.panFilter);
    }

//    [3] Roll Motor
    if(roll_kp() != current_params_on_board.rollKp){
        current_params_on_board.rollKp = roll_kp();   // update current value to params struct
        write_a_param_to_board("ROLL_P", current_params_on_board.rollKp);
    }
    if(roll_ki() != current_params_on_board.rollKi){
        current_params_on_board.rollKi = roll_ki();   // update current value to params struct
        write_a_param_to_board("ROLL_I", current_params_on_board.rollKi);
    }
    if(roll_kd() != current_params_on_board.rollKd){
        current_params_on_board.rollKd = roll_kd();   // update current value to params struct
        write_a_param_to_board("ROLL_D", current_params_on_board.rollKd);
    }
    if(roll_follow() != current_params_on_board.rollFollow){
        current_params_on_board.rollFollow = roll_follow();   // update current value to params struct
        write_a_param_to_board("ROLL_FOLLOW", current_params_on_board.rollFollow);
    }
    if(roll_filter() != current_params_on_board.rollFilter){
        current_params_on_board.rollFilter = roll_filter();   // update current value to params struct
        write_a_param_to_board("ROLL_FILTER", current_params_on_board.rollFilter);
    }


    // other params
    setmavlink_message_log("Sending parameters to controller board...Done!");
}

void MavLinkManager::get_mavlink_info()
{
    Configuration m_config;
    setmavlink_message_log(QString("Onboard MAVlink Protocol Ver.: %1").arg(m_mavlink_heartbeat.mavlink_version));
    setmavlink_message_log(QString("Software MAVlink Protocol Ver.: %1").arg(MAVLINK_VERSION));
    setmavlink_message_log(QString("MAVlink Library Ver.: %1").arg(m_config.get_mavlink_lib_version()));
    setmavlink_message_log(QString("MAVlink for gStabi Build date: %1").arg(MAVLINK_BUILD_DATE));

}

double MavLinkManager::get_battery_percent_remain(double _vol)
{
    int batt_cells = 0;
    if(_vol < (BATT_3_CELL*BATT_CELL_MIN - 4)){
        batt_cells = BATT_NO_CELL;
    }
    else if((_vol >= (BATT_3_CELL*BATT_CELL_MIN)) && (_vol <= (BATT_3_CELL*BATT_CELL_MAX))){
        batt_cells = BATT_3_CELL;
    }
    else if((_vol >= (BATT_4_CELL*BATT_CELL_MIN)) && (_vol <= (BATT_4_CELL*BATT_CELL_MAX))){
        batt_cells = BATT_4_CELL;
    }
    else if((_vol >= (BATT_5_CELL*BATT_CELL_MIN)) && (_vol <= (BATT_5_CELL*BATT_CELL_MAX))){
        batt_cells = BATT_5_CELL;
    }
    else if((_vol >= (BATT_6_CELL*BATT_CELL_MIN))){
        batt_cells = BATT_6_CELL;
    }
    if(batt_cells != 2){
        return 100*(_vol - batt_cells*BATT_CELL_MIN)/(batt_cells*(BATT_CELL_MAX - BATT_CELL_MIN));
    }
    else {
        return 100*_vol/5.0;
    }

}

/*
 *gBattery.volCurrent = readAdc()*BATT_VOL_SCALE;

    if(gBattery.volCurrent < (BATT_3_CELL*BATT_CELL_MIN - 4)){
        gBattery.cell = BATT_NO_CELL;
    }
    else if((gBattery.volCurrent >= (BATT_3_CELL*BATT_CELL_MIN)) && (gBattery.volCurrent <= (BATT_3_CELL*BATT_CELL_MAX))){
        gBattery.cell = BATT_3_CELL;
    }
    else if((gBattery.volCurrent >= (BATT_4_CELL*BATT_CELL_MIN)) && (gBattery.volCurrent <= (BATT_4_CELL*BATT_CELL_MAX))){
        gBattery.cell = BATT_4_CELL;
    }
    else if((gBattery.volCurrent >= (BATT_5_CELL*BATT_CELL_MIN)) && (gBattery.volCurrent <= (BATT_5_CELL*BATT_CELL_MAX))){
        gBattery.cell = BATT_5_CELL;
    }
    else if((gBattery.volCurrent >= (BATT_6_CELL*BATT_CELL_MIN))){
        gBattery.cell = BATT_6_CELL;
    }
//					gBattery.percent = 100 - (gBattery.cell*BATT_CELL_MAX - gBattery.volCurrent)*100/(gBattery.cell*(BATT_CELL_MAX - BATT_CELL_MIN));
    if(gBattery.cell != 2){
        if(gBattery.volCurrent <= gBattery.cell*BATT_CELL_ALARM){
            gBattery.update++;
            if(gBattery.update > 10){
                gBattery.update = 11;
                return BATT_ALARM_LOW;
            }
        }
        else{
            gBattery.update = 0;
            return BATT_ALARM_OK;
        }
    }

    return BATT_ALARM_PC;
*/
void MavLinkManager::write_a_param_to_board(const char *param_id, float _value)
{
    uint16_t len;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];

    mavlink_msg_param_set_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, TARGET_SYSTEM_ID, MAV_COMP_ID_IMU, \
                               param_id, _value, MAVLINK_TYPE_INT16_T);
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);      // send signal

}


void MavLinkManager::mavlink_init()
{
    system_type = MAV_TYPE_FIXED_WING;
    autopilot_type = MAV_AUTOPILOT_GENERIC;
    system_mode = MAV_MODE_PREFLIGHT; ///< Booting up
    custom_mode = 0;                 ///< Custom mode, can be defined by user/adopter
    system_state = MAV_STATE_STANDBY; ///< System ready for flight
    first_data_pack = true;           // this will be check when mavlink message was received, to check whether it's 1st time to received the message
    heartbeat_state = false;
}

void MavLinkManager::RestartLinkConnectionTimer(int msec)
{
    linkConnectionTimer->stop();
    linkConnectionTimer->start(msec);
}

void MavLinkManager::request_all_params()
{
    uint16_t len;
    mavlink_message_t msg;

    uint8_t buf[MAVLINK_MAX_PACKET_LEN];
    mavlink_msg_param_request_list_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, TARGET_SYSTEM_ID, MAV_COMP_ID_IMU);
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
    setmavlink_message_log("Requesting parameters on board...");
}


void MavLinkManager::send_control_command(int tilt_angle_setpoint, int pan_angle_setpoint, int roll_angle_setpoint)
{
    uint16_t len=0;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];

//    tilt_temp = ui->pitchSlider->value();  // degree then convert to angle speed
//    roll_temp = ui->rollSlider->value();
//    yaw_temp  = ui->yawknob->value();

    mavlink_msg_rc_simulation_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, tilt_angle_setpoint, roll_angle_setpoint, pan_angle_setpoint);
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
    qDebug()<< QString("C++>>Control angle: %1, %2, %3").arg(tilt_angle_setpoint).arg(pan_angle_setpoint).arg(roll_angle_setpoint);
}



bool MavLinkManager::hb_pulse() const
{
    return m_hb_pulse;
}

void MavLinkManager::sethb_pulse(bool state)
{
    m_hb_pulse = state;
    emit hb_pulseChanged(m_hb_pulse);

}

bool MavLinkManager::board_connection_state() const
{
    return m_board_connection_state;
}

void MavLinkManager::setboard_connection_state(bool _state)
{
    m_board_connection_state = _state;
    emit board_connection_stateChanged(m_board_connection_state);
}

QString MavLinkManager::mavlink_message_log() const
{
    return m_mavlink_message_log;
}

void MavLinkManager::setmavlink_message_log(QString msg_data)
{
    m_mavlink_message_log = msg_data;
    emit mavlink_message_logChanged(m_mavlink_message_log);
}

float MavLinkManager::roll_angle() const
{
    return m_roll_angle;
}

void MavLinkManager::setroll_angle(float _angle)
{
    m_roll_angle = _angle;
    emit roll_angleChanged(m_roll_angle);
}

float MavLinkManager::pitch_angle() const
{
    return m_pitch_angle;
}

void MavLinkManager::setpitch_angle(float _angle)
{
    m_pitch_angle = _angle;
    emit pitch_angleChanged(m_pitch_angle);
}

float MavLinkManager::yaw_angle() const
{
    return m_yaw_angle;
}

void MavLinkManager::setyaw_angle(float _angle)
{
    m_yaw_angle = _angle;
    emit yaw_angleChanged(m_yaw_angle);
}

int MavLinkManager::control_type() const
{
    return m_control_type;
}

void MavLinkManager::setcontrol_type(int _type)
{
    m_control_type = _type;
    emit control_typeChanged(m_control_type);
}

int MavLinkManager::battery_voltage() const
{
    return m_battery_voltage;
}

void MavLinkManager::setbattery_voltage(int _vol)
{
    m_battery_voltage = _vol;
    emit battery_voltageChanged(m_battery_voltage);
}
/**
 * @brief Tilt motor functions to control tilt parameters
 */
float MavLinkManager::tilt_kp() const
{
    return m_tilt_kp;
}

void MavLinkManager::settilt_kp(float _kp)
{
    m_tilt_kp = _kp;
    emit tilt_kpChanged(m_tilt_kp);
}

float MavLinkManager::tilt_ki() const
{
    return m_tilt_ki;
}

void MavLinkManager::settilt_ki(float _ki)
{
    m_tilt_ki = _ki;
    emit tilt_kiChanged(m_tilt_ki);
}

float MavLinkManager::tilt_kd() const
{
    return m_tilt_kd;
}

void MavLinkManager::settilt_kd(float _kd)
{
    m_tilt_kd = _kd;
    emit tilt_kdChanged(m_tilt_kd);
}

float MavLinkManager::tilt_power() const
{
    return m_tilt_power;
}

void MavLinkManager::settilt_power(float _power)
{
    m_tilt_power = _power;
    emit tilt_powerChanged(m_tilt_power);
}

float MavLinkManager::tilt_follow() const
{
    return m_tilt_follow;
}

void MavLinkManager::settilt_follow(float _follow)
{
    m_tilt_follow = _follow;
    emit tilt_followChanged(m_tilt_follow);
}

float MavLinkManager::tilt_filter() const
{
    return m_tilt_filter;
}

void MavLinkManager::settilt_filter(float _filter)
{
    m_tilt_filter = _filter;
    emit tilt_filterChanged(m_tilt_filter);
}

int MavLinkManager::motor_tilt_dir() const
{
    return m_motor_tilt_dir;
}

void MavLinkManager::setmotor_tilt_dir(int _dir)
{
    m_motor_tilt_dir = _dir;
    emit motor_tilt_dirChanged(m_motor_tilt_dir);
}

int MavLinkManager::motor_tilt_num_poles() const
{
    return m_motor_tilt_num_poles;
}

void MavLinkManager::setmotor_tilt_num_poles(int _poles)
{
    m_motor_tilt_num_poles = _poles;
    emit motor_tilt_num_polesChanged(m_motor_tilt_num_poles);
}

int MavLinkManager::tilt_up_limit_angle() const
{
   return m_tilt_up_limit_angle;
}

void MavLinkManager::settilt_up_limit_angle(int _min)
{
    m_tilt_up_limit_angle = _min;
    emit tilt_up_limit_angleChanged(m_tilt_up_limit_angle);
}

int MavLinkManager::tilt_down_limit_angle() const
{
    return m_tilt_down_limit_angle;
}

void MavLinkManager::settilt_down_limit_angle(int _max)
{
    m_tilt_down_limit_angle = _max;
    emit tilt_down_limit_angleChanged(m_tilt_down_limit_angle);
}

int MavLinkManager::tilt_lpf() const
{
    return m_tilt_lpf;
}

void MavLinkManager::settilt_lpf(int _lpf)
{
    m_tilt_lpf = _lpf;
    emit tilt_lpfChanged(m_tilt_lpf);
}

int MavLinkManager::tilt_trim() const
{
    return m_tilt_trim;
}

void MavLinkManager::settilt_trim(int _trim)
{
    m_tilt_trim = _trim;
    emit tilt_trimChanged(m_tilt_trim);
}

int MavLinkManager::tilt_mode() const
{
    return m_tilt_mode;
}

void MavLinkManager::settilt_mode(int _mode)
{
    m_tilt_mode = _mode;
    emit tilt_modeChanged(m_tilt_mode);
}


/**
 * @brief Pan motor functions to control pan parameters
 */
float MavLinkManager::pan_kp() const
{
    return m_pan_kp;
}

void MavLinkManager::setpan_kp(float _kp)
{
    m_pan_kp = _kp;
    emit pan_kpChanged(m_pan_kp);
}

float MavLinkManager::pan_ki() const
{
    return m_pan_ki;
}

void MavLinkManager::setpan_ki(float _ki)
{
    m_pan_ki = _ki;
    emit pan_kiChanged(m_pan_ki);
}

float MavLinkManager::pan_kd() const
{
    return m_pan_kd;
}

void MavLinkManager::setpan_kd(float _kd)
{
    m_pan_kd = _kd;
    emit pan_kdChanged(m_pan_kd);
}

float MavLinkManager::pan_power() const
{
    return m_pan_power;
}

void MavLinkManager::setpan_power(float _power)
{
    m_pan_power = _power;
    emit pan_powerChanged(m_pan_power);
}

float MavLinkManager::pan_follow() const
{
    return m_pan_follow;
}

void MavLinkManager::setpan_follow(float _follow)
{
    m_pan_follow = _follow;
    emit pan_followChanged(m_pan_follow);
}

float MavLinkManager::pan_filter() const
{
    return m_pan_filter;
}

void MavLinkManager::setpan_filter(float _filter)
{
    m_pan_filter = _filter;
    emit pan_filterChanged(m_pan_filter);
}

int MavLinkManager::motor_pan_dir() const
{
    return m_motor_pan_dir;
}

void MavLinkManager::setmotor_pan_dir(int _dir)
{
    m_motor_pan_dir = _dir;
    emit motor_pan_dirChanged(m_motor_pan_dir);
}

int MavLinkManager::motor_pan_num_poles() const
{
    return m_motor_pan_num_poles;
}

void MavLinkManager::setmotor_pan_num_poles(int _poles)
{
    m_motor_pan_num_poles = _poles;
    emit motor_pan_num_polesChanged(m_motor_pan_num_poles);
}

int MavLinkManager::pan_cw_limit_angle() const
{
   return m_pan_cw_limit_angle;
}

void MavLinkManager::setpan_cw_limit_angle(int _min)
{
    m_pan_cw_limit_angle = _min;
    emit pan_cw_limit_angleChanged(m_pan_cw_limit_angle);
}

int MavLinkManager::pan_ccw_limit_angle() const
{
    return m_pan_ccw_limit_angle;
}

void MavLinkManager::setpan_ccw_limit_angle(int _max)
{
    m_pan_ccw_limit_angle = _max;
    emit pan_ccw_limit_angleChanged(m_pan_ccw_limit_angle);
}

/**
 * @brief Roll motor functions to control roll parameters
 */
float MavLinkManager::roll_kp() const
{
    return m_roll_kp;
}

void MavLinkManager::setroll_kp(float _kp)
{
    m_roll_kp = _kp;
    emit roll_kpChanged(m_roll_kp);
}

float MavLinkManager::roll_ki() const
{
    return m_roll_ki;
}

void MavLinkManager::setroll_ki(float _ki)
{
    m_roll_ki = _ki;
    emit roll_kiChanged(m_roll_ki);
}

float MavLinkManager::roll_kd() const
{
    return m_roll_kd;
}

void MavLinkManager::setroll_kd(float _kd)
{
    m_roll_kd = _kd;
    emit roll_kdChanged(m_roll_kd);
}

float MavLinkManager::roll_power() const
{
    return m_roll_power;
}

void MavLinkManager::setroll_power(float _power)
{
    m_roll_power = _power;
    emit roll_powerChanged(m_roll_power);
}

float MavLinkManager::roll_follow() const
{
    return m_roll_follow;
}

void MavLinkManager::setroll_follow(float _follow)
{
    m_roll_follow = _follow;
    emit roll_followChanged(m_roll_follow);
}

float MavLinkManager::roll_filter() const
{
    return m_roll_filter;
}

void MavLinkManager::setroll_filter(float _filter)
{
    m_roll_filter = _filter;
    emit roll_filterChanged(m_roll_filter);
}

int MavLinkManager::motor_roll_dir() const
{
    return m_motor_roll_dir;
}

void MavLinkManager::setmotor_roll_dir(int _dir)
{
    m_motor_roll_dir = _dir;
    emit motor_roll_dirChanged(m_motor_roll_dir);
}

int MavLinkManager::motor_roll_num_poles() const
{
    return m_motor_roll_num_poles;
}

void MavLinkManager::setmotor_roll_num_poles(int _poles)
{
    m_motor_roll_num_poles = _poles;
    emit motor_roll_num_polesChanged(m_motor_roll_num_poles);
}

int MavLinkManager::roll_up_limit_angle() const
{
   return m_roll_up_limit_angle;
}

void MavLinkManager::setroll_up_limit_angle(int _min)
{
    m_roll_up_limit_angle = _min;
    emit roll_up_limit_angleChanged(m_roll_up_limit_angle);
}

int MavLinkManager::roll_down_limit_angle() const
{
    return m_roll_down_limit_angle;
}

void MavLinkManager::setroll_down_limit_angle(int _max)
{
    m_roll_down_limit_angle = _max;
    emit roll_down_limit_angleChanged(m_roll_down_limit_angle);
}


