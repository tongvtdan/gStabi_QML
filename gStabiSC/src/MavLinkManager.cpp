#include "MavLinkManager.hpp"
#include <QDebug>


MavLinkManager::MavLinkManager(QObject *parent) :
    QObject(parent)
{
    linkConnectionTimer = new QTimer(this);
    linkConnectionTimer->setSingleShot(true);

    connect(linkConnectionTimer,SIGNAL(timeout()),this, SLOT(connection_timeout()));

    mavlink_init();
    system_msg_log = "";
    debug_enabled = false;  // send/not send debug message to QML
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
                //                setkeycode_request(true);  // simulate the request from MCU
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
                rc_sbus_level[0] = sbus_chan_values.ch1;
                sbus_chan_values.ch2 = mavlink_msg_sbus_chan_values_get_ch2(&message);
                rc_sbus_level[1] = sbus_chan_values.ch2;
                sbus_chan_values.ch3 = mavlink_msg_sbus_chan_values_get_ch3(&message);
                rc_sbus_level[2] = sbus_chan_values.ch3;
                sbus_chan_values.ch4 = mavlink_msg_sbus_chan_values_get_ch4(&message);
                rc_sbus_level[3] = sbus_chan_values.ch4;
                sbus_chan_values.ch5 = mavlink_msg_sbus_chan_values_get_ch5(&message);
                rc_sbus_level[4] = sbus_chan_values.ch5;
                sbus_chan_values.ch6 = mavlink_msg_sbus_chan_values_get_ch6(&message);
                rc_sbus_level[5] = sbus_chan_values.ch6;
                sbus_chan_values.ch7 = mavlink_msg_sbus_chan_values_get_ch7(&message);
                rc_sbus_level[6] = sbus_chan_values.ch7;
                sbus_chan_values.ch8 = mavlink_msg_sbus_chan_values_get_ch8(&message);
                rc_sbus_level[7] = sbus_chan_values.ch8;
                sbus_chan_values.ch9 = mavlink_msg_sbus_chan_values_get_ch9(&message);
                rc_sbus_level[8] = sbus_chan_values.ch9;
                sbus_chan_values.ch10 = mavlink_msg_sbus_chan_values_get_ch10(&message);
                rc_sbus_level[9] = sbus_chan_values.ch10;
                sbus_chan_values.ch11 = mavlink_msg_sbus_chan_values_get_ch11(&message);
                rc_sbus_level[10] = sbus_chan_values.ch11;
                sbus_chan_values.ch12 = mavlink_msg_sbus_chan_values_get_ch12(&message);
                rc_sbus_level[11] = sbus_chan_values.ch12;
                sbus_chan_values.ch13 = mavlink_msg_sbus_chan_values_get_ch13(&message);
                rc_sbus_level[12] = sbus_chan_values.ch13;
                sbus_chan_values.ch14 = mavlink_msg_sbus_chan_values_get_ch14(&message);
                rc_sbus_level[13] = sbus_chan_values.ch14;
                sbus_chan_values.ch15 = mavlink_msg_sbus_chan_values_get_ch15(&message);
                rc_sbus_level[14] = sbus_chan_values.ch15;
                sbus_chan_values.ch16 = mavlink_msg_sbus_chan_values_get_ch16(&message);
                rc_sbus_level[15] = sbus_chan_values.ch16;
                sbus_chan_values.ch17 = mavlink_msg_sbus_chan_values_get_ch17(&message);
                rc_sbus_level[16] = sbus_chan_values.ch17;
                sbus_chan_values.ch18 = mavlink_msg_sbus_chan_values_get_ch18(&message);
                rc_sbus_level[17] = sbus_chan_values.ch18;
                update_rc_sbus_value();
            }
                break;
            case MAVLINK_MSG_ID_PPM_CHAN_VALUES: {  // get value of PWM from RC Remote control
                pwm_values.tilt = mavlink_msg_ppm_chan_values_get_tilt(&message);
                pwm_values.roll = mavlink_msg_ppm_chan_values_get_roll(&message);
                pwm_values.pan  = mavlink_msg_ppm_chan_values_get_pan(&message);
                pwm_values.mode = mavlink_msg_ppm_chan_values_get_mode(&message);
                update_pwm_values();
            }
                break;
            case MAVLINK_MSG_ID_SYSTEM_STATUS:{
                m_g_system_status.battery_voltage = mavlink_msg_system_status_get_battery_voltage(&message);
                setbattery_voltage(m_g_system_status.battery_voltage);
                // IMU Calib
                m_g_system_status.imu_calib = mavlink_msg_system_status_get_imu_calib(&message);
                update_calib_status();
            }
                break;
            case MAVLINK_MSG_ID_DEBUG_VALUES :{
                if(debug_enabled){
                    setmavlink_message_log(QString("*** Debug ***\n- 1: %1\n- 2: %2\n- 3: %3\n- 4: %4\n- 5: %5\n- 6: %6\n- 7: %7\n- 8: %8")
                                           .arg(mavlink_msg_debug_values_get_debug1(&message))
                                           .arg(mavlink_msg_debug_values_get_debug2(&message))
                                           .arg(mavlink_msg_debug_values_get_debug3(&message))
                                           .arg(mavlink_msg_debug_values_get_debug4(&message))
                                           .arg(mavlink_msg_debug_values_get_debug5(&message))
                                           .arg(mavlink_msg_debug_values_get_debug6(&message))
                                           .arg(mavlink_msg_debug_values_get_debug7(&message))
                                           .arg(mavlink_msg_debug_values_get_debug8(&message))
                                           );
                }
            }
                break;
            case MAVLINK_MSG_ID_KEYCODE_REQUEST:{
                if(mavlink_msg_keycode_request_get_device_name3(&message) == GSTABI){
                    setkeycode_request(true);
                }
            }
                break;
            case MAVLINK_MSG_ID_UNIQUE_ID_VALUES:{
                unique_device_id.unique_id_0 = mavlink_msg_unique_id_values_get_unique_id_0(&message);
                unique_device_id.unique_id_1 = mavlink_msg_unique_id_values_get_unique_id_1(&message);
                unique_device_id.unique_id_2 = mavlink_msg_unique_id_values_get_unique_id_2(&message);
                unique_device_id.unique_id_3 = mavlink_msg_unique_id_values_get_unique_id_3(&message);
                unique_device_id.unique_id_4 = mavlink_msg_unique_id_values_get_unique_id_4(&message);
                unique_device_id.unique_id_5 = mavlink_msg_unique_id_values_get_unique_id_5(&message);
                setudid_values(QString("%1 - %2 - %3 - %4 - %5 - %6")
                               .arg(unique_device_id.unique_id_0)
                               .arg(unique_device_id.unique_id_1)
                               .arg(unique_device_id.unique_id_2)
                               .arg(unique_device_id.unique_id_3)
                               .arg(unique_device_id.unique_id_4)
                               .arg(unique_device_id.unique_id_5)
                               );
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
    RestartLinkConnectionTimer(2000);
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
        first_data_pack = true;
    }
}

// Get Paramter to store in current_params_on_board
/**
 * @brief MavLinkManager::update_all_parameters
 *          Called when received a message  contain changes in parameters
 * @param index : the index of parameter
 * @param value : value of parameter
 */
void MavLinkManager::update_all_parameters(uint8_t index, float value)
{

    switch(index)
    {
    case PARAM_VERSION:         current_params_on_board.version = value;
        break;
    case PARAM_SERIAL_NUMBER:   current_params_on_board.serialNumber = value;
        break;
        //   <<< Controller Settings
    case PARAM_PITCH_P:          current_params_on_board.pitchKp = value;
        settilt_kp(current_params_on_board.pitchKp);
        break;
    case PARAM_PITCH_I:        current_params_on_board.pitchKi = value;
        settilt_ki(current_params_on_board.pitchKi);
        break;
    case PARAM_PITCH_D:         current_params_on_board.pitchKd = value;
        settilt_kd(current_params_on_board.pitchKd);
        break;
    case PARAM_ROLL_P:          current_params_on_board.rollKp = value;
        setroll_kp(current_params_on_board.rollKp);
        break;
    case PARAM_ROLL_I:          current_params_on_board.rollKi = value;
        setroll_ki(current_params_on_board.rollKi);
        break;
    case PARAM_ROLL_D:          current_params_on_board.rollKd = value;
        setroll_kd(current_params_on_board.rollKd);
        break;
    case PARAM_YAW_P:           current_params_on_board.yawKp = value;
        setpan_kp(current_params_on_board.yawKp);
        break;
    case PARAM_YAW_I:           current_params_on_board.yawKi = value;
        setpan_ki(current_params_on_board.yawKi);
        break;
    case PARAM_YAW_D:           current_params_on_board.yawKd = value;
        setpan_kd(current_params_on_board.yawKd);
        break;
    case PARAM_PITCH_FOLLOW:    current_params_on_board.pitchFollow = value;
        settilt_follow(current_params_on_board.pitchFollow);
        break;
    case PARAM_ROLL_FOLLOW:     current_params_on_board.rollFollow = value;
        setroll_follow(current_params_on_board.rollFollow);
        break;
    case PARAM_YAW_FOLLOW:      current_params_on_board.yawFollow = value;
        setpan_follow(current_params_on_board.yawFollow);
        break;
    case PARAM_PITCH_FILTER:    current_params_on_board.tiltFilter = value;
        settilt_filter(current_params_on_board.tiltFilter);
        break;
    case PARAM_ROLL_FILTER:     current_params_on_board.rollFilter = value;
        setroll_filter(current_params_on_board.rollFilter);
        break;
    case PARAM_YAW_FILTER:      current_params_on_board.panFilter = value;
        setpan_filter(current_params_on_board.panFilter);
        break;
        //   >>>  Controller Settings End
        //   <<<  Motor Settings
        //**********************
    case PARAM_MOTOR_FREQ:      current_params_on_board.motorFreq = value;
        setmotor_freq(current_params_on_board.motorFreq);
        break;
        //**************************
    case PARAM_PITCH_POWER:     current_params_on_board.pitchPower = value;
        settilt_power(current_params_on_board.pitchPower);
        break;
    case PARAM_ROLL_POWER:      current_params_on_board.rollPower = value;
        setroll_power(current_params_on_board.rollPower);
        break;
    case PARAM_YAW_POWER:       current_params_on_board.yawPower = value;
        setpan_power(current_params_on_board.yawPower);
        break;
    case PARAM_NPOLES_PITCH:    current_params_on_board.nPolesPitch = value;
        setmotor_tilt_num_poles(current_params_on_board.nPolesPitch);
        break;
    case PARAM_NPOLES_ROLL:     current_params_on_board.nPolesRoll= value;
        setmotor_roll_num_poles(current_params_on_board.nPolesRoll);
        break;
    case PARAM_NPOLES_YAW:      current_params_on_board.nPolesYaw = value;
        setmotor_pan_num_poles(current_params_on_board.nPolesYaw);
        break;
    case PARAM_DIR_MOTOR_PITCH: current_params_on_board.dirMotorPitch = value;
        setmotor_tilt_dir(current_params_on_board.dirMotorPitch);
        break;
    case PARAM_DIR_MOTOR_ROLL:  current_params_on_board.dirMotorRoll = value;
        setmotor_roll_dir(current_params_on_board.dirMotorRoll);
        break;
    case PARAM_DIR_MOTOR_YAW:   current_params_on_board.dirMotorYaw = value;
        setmotor_pan_dir(current_params_on_board.dirMotorYaw);
        break;
    case PARAM_TRAVEL_MIN_PITCH:current_params_on_board.travelMinPitch = value;
        settilt_up_limit_angle(current_params_on_board.travelMinPitch);
        break;
    case PARAM_TRAVEL_MAX_PITCH:current_params_on_board.travelMaxPitch = value;
        settilt_down_limit_angle(current_params_on_board.travelMaxPitch);
        break;
    case PARAM_TRAVEL_MIN_ROLL: current_params_on_board.travelMinRoll = value;
        setroll_up_limit_angle(current_params_on_board.travelMinRoll);
        break;
    case PARAM_TRAVEL_MAX_ROLL: current_params_on_board.travelMaxRoll = value;
        setroll_down_limit_angle(current_params_on_board.travelMaxRoll);
        break;
    case PARAM_TRAVEL_MIN_YAW:  current_params_on_board.travelMinYaw = value;
        setpan_ccw_limit_angle(current_params_on_board.travelMinYaw);
        break;
    case PARAM_TRAVEL_MAX_YAW:  current_params_on_board.travelMaxYaw = value;
        setpan_cw_limit_angle(current_params_on_board.travelMaxYaw);
        break;
    case PARAM_RC_PITCH_MODE:   current_params_on_board.rcPitchMode = value;
        settilt_mode(current_params_on_board.rcPitchMode);
        break;
    case PARAM_RC_ROLL_MODE:    current_params_on_board.rcRollMode = value;
        setroll_mode(current_params_on_board.rcRollMode);
        break;
    case PARAM_RC_YAW_MODE:     current_params_on_board.rcYawMode = value;
        setpan_mode(current_params_on_board.rcYawMode);
        break;
        //   >>> Motor Settings End

        //   <<< RC Settings
    case PARAM_RC_PITCH_LPF:    current_params_on_board.rcPitchLPF = value;
        settilt_lpf(current_params_on_board.rcPitchLPF);
        break;
    case PARAM_RC_ROLL_LPF:     current_params_on_board.rcRollLPF = value;
        setroll_lpf(current_params_on_board.rcRollLPF);
        break;
    case PARAM_RC_YAW_LPF:      current_params_on_board.rcYawLPF = value;
        setpan_lpf(current_params_on_board.rcYawLPF);
        break;
    case PARAM_RC_PITCH_TRIM:   current_params_on_board.rcPitchTrim = value;
        settilt_trim(current_params_on_board.rcPitchTrim);
        break;
    case PARAM_RC_ROLL_TRIM:    current_params_on_board.rcRollTrim = value;
        setroll_trim(current_params_on_board.rcRollTrim = value);
        break;
    case PARAM_RC_YAW_TRIM:     current_params_on_board.rcYawTrim = value;
        setpan_trim(current_params_on_board.rcYawTrim);
        break;
        // **** SBUS Channel
    case PARAM_SBUS_PITCH_CHAN: current_params_on_board.sbusPitchChan = value;
        settilt_sbus_chan_num(current_params_on_board.sbusPitchChan + 1); // +1 for display, value of chan: 0 for chan1, 1 for  chan2,...
        break;
    case PARAM_SBUS_ROLL_CHAN:  current_params_on_board.sbusRollChan = value;
        setroll_sbus_chan_num(current_params_on_board.sbusRollChan + 1); // +1 for display, value of chan: 0 for chan1, 1 for  chan2,...
        break;
    case PARAM_SBUS_YAW_CHAN:   current_params_on_board.sbusYawChan = value;
        setpan_sbus_chan_num(current_params_on_board.sbusYawChan + 1); // +1 for display, value of chan: 0 for chan1, 1 for  chan2,...
        break;
    case PARAM_SBUS_MODE_CHAN:  current_params_on_board.sbusModeChan = value;
        setmode_sbus_chan_num(current_params_on_board.sbusModeChan + 1);
        break;
        //   >>> RC Settings End
        //   <<< IMU Settings
    case PARAM_ACCX_OFFSET:     current_params_on_board.accXOffset = value;
        setacc_x_offset(current_params_on_board.accXOffset);
        break;
    case PARAM_ACCY_OFFSET:     current_params_on_board.accYOffset = value;
        setacc_y_offset(current_params_on_board.accYOffset);
        break;
    case PARAM_ACCZ_OFFSET:     current_params_on_board.accZOffset = value;
        setacc_z_offset(current_params_on_board.accZOffset);
        break;
    case PARAM_GYROX_OFFSET:    current_params_on_board.gyroXOffset = value;
        setgyro_x_offset(current_params_on_board.gyroXOffset);
        break;
    case PARAM_GYROY_OFFSET:    current_params_on_board.gyroYOffset = value;
        setgyro_y_offset(current_params_on_board.gyroYOffset);
        break;
    case PARAM_GYROZ_OFFSET:    current_params_on_board.gyroZOffset = value;
        setgyro_z_offset(current_params_on_board.gyroZOffset);
        break;

    case PARAM_SKIP_GYRO_CALIB: current_params_on_board.skipGyroCalib = value;
        setskip_gyro_calib(current_params_on_board.skipGyroCalib);
        break;
    case PARAM_USE_GPS:         current_params_on_board.useGPS = value;
        setuse_gps(current_params_on_board.useGPS);
        break;
    case PARAM_GYRO_TRUST:      current_params_on_board.gyroTrust = value;
        setgyro_trust(current_params_on_board.gyroTrust);
        break;
    case PARAM_GYRO_LPF:        current_params_on_board.gyroLPF = value;
        setgyro_lpf(current_params_on_board.gyroLPF);
        break;
        //  >>> IMU Settings End
        //  <<< Others
    case PARAM_RADIO_TYPE:      current_params_on_board.radioType = value;
        setcontrol_type(current_params_on_board.radioType);
        break;
        //  >>> Others end

    default:
        break;
    }

}

void MavLinkManager::update_rc_sbus_value()
{
    int i;
    for(i = 0; i<18; i++){
        if((mode_sbus_chan_num() - 1) == i){      // mode channel
            setmode_rc_sbus_level(rc_sbus_level[i]);
        }
        if((tilt_sbus_chan_num() - 1) == i){  // tilt channel
            settilt_rc_sbus_level(rc_sbus_level[i]);
        }
        if((pan_sbus_chan_num() - 1) == i){  // pan channel
            setpan_rc_sbus_level(rc_sbus_level[i]);
        }
        if((roll_sbus_chan_num() - 1) == i){  // roll channel
            setroll_rc_sbus_level(rc_sbus_level[i]);
        }

    }
}

void MavLinkManager::update_pwm_values()
{
    setmode_pwm_level(pwm_values.mode);
    settilt_pwm_level(pwm_values.tilt);
    setpan_pwm_level(pwm_values.pan);
    setroll_pwm_level(pwm_values.roll);
}

void MavLinkManager::update_calib_status()
{
    if(calib_type == ACC_CALIB)
    {
        setaccel_calib_steps(m_g_system_status.imu_calib);
        qDebug() << "Calib step: " << accel_calib_steps();
        switch(m_g_system_status.imu_calib)
        {
        case CALIB_FINISH:
            if(calib_finished){
                setmavlink_message_log("Accelerometer sensors calibration completed! \nDon't move sensors until the sensor value in TILT < 1 and ROLL < 1");
                request_all_params();   // then request all parameters from Board
                calib_type = CALIB_NONE;
            }
            else if(calib_mode() == 0) {
                setmavlink_message_log("Accelerometer sensors calibration completed! \nDon't move sensors until the sensor value in TILT < 1 and ROLL < 1");
                request_all_params();   // then request all parameters from Board
                calib_type = CALIB_NONE;
            }
            break;
        case ONE_REMAINING_FACE:
            if(calib_mode() == 0)   // basic mode
            {
                setmavlink_message_log("Calibrating accelerometer sensors ... \nDon't move sensors untill calibration process completed");
            }
            break;
        case TWO_REMAINING_FACES:
            break;
        case THREE_REMAINING_FACES:
            break;
        case FOUR_REMAINING_FACES:
            break;
        case FIVE_REMAINING_FACES:
            break;
        case SIX_REMAINING_FACES:
            calib_finished = true;
            break;
        case CALIB_FAIL:
            setmavlink_message_log("Accelerometer sensors calibration failed!");
            calib_type = CALIB_NONE;
            break;
        default:

            break;
        }
    } else if(calib_type == GYRO_CALIB)
    {
        switch(m_g_system_status.imu_calib){
        case CALIB_FINISH:
            setmavlink_message_log("Gyroscope sensors calibration completed!");
            request_all_params();   // then request all parameters from Board
            calib_type = CALIB_NONE;
            break;
        case CALIB_FAIL:
            setmavlink_message_log("Gyroscope sensors calibration failed!");
            calib_type = CALIB_NONE;
            break;
        default:
            setmavlink_message_log("Calibrating gyroscope sensors ... \nDon't move sensors untill calibration process completed ");
            break;
        }
    }
}


void MavLinkManager::update_all_parameters_to_UI()
{
    //    if(!first_data_pack)    // to ensure all params read
    //    {
    //        setmavlink_message_log("Updating parameters...");
    ////        get_firmware_version();
    ////        get_hardware_serial_number();
    //        // General


    //        setmavlink_message_log("Updating parameters...Done");
    //    }
    //    else setmavlink_message_log("Waiting for reading parameters...");
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
    if(board_connection_state() == ONLINE){
        qDebug("Sending parameters to controller board...");
        setmavlink_message_log("Sending parameters to controller board...");
        // Motor config params
        // General
        if(control_type() != current_params_on_board.radioType){
            current_params_on_board.radioType = control_type();
            write_a_param_to_board("RADIO_TYPE", current_params_on_board.radioType);
        }
        if(skip_gyro_calib() != current_params_on_board.skipGyroCalib){
            current_params_on_board.skipGyroCalib = skip_gyro_calib();
            write_a_param_to_board("SKIP_GYRO_CALIB", current_params_on_board.skipGyroCalib);
        }
        if(use_gps() != current_params_on_board.useGPS){
            current_params_on_board.useGPS = use_gps();
            write_a_param_to_board("USE_GPS", current_params_on_board.useGPS);
        }
        if(gyro_trust() != current_params_on_board.gyroTrust){
            current_params_on_board.gyroTrust = gyro_trust();
            write_a_param_to_board("GYRO_TRUST", current_params_on_board.gyroTrust);
        }
        if(gyro_lpf() != current_params_on_board.gyroLPF){
            current_params_on_board.gyroLPF = gyro_lpf();
            write_a_param_to_board("GYRO_LPF", current_params_on_board.gyroLPF);
        }
        if(motor_freq() != current_params_on_board.motorFreq){
            current_params_on_board.motorFreq = motor_freq();
            write_a_param_to_board("MOTOR_FREQ", current_params_on_board.motorFreq);
        }

        //    [!] *** SBUS Channel ***
        if(mode_sbus_chan_num() != current_params_on_board.sbusModeChan){
            current_params_on_board.sbusModeChan = mode_sbus_chan_num() - 1;
            write_a_param_to_board("SBUS_MODE_CHAN", current_params_on_board.sbusModeChan);
        }
        if(tilt_sbus_chan_num() != current_params_on_board.sbusPitchChan){
            current_params_on_board.sbusPitchChan = tilt_sbus_chan_num() - 1;      // - 1 to get a real value for channel from display value in QML
            write_a_param_to_board("SBUS_PITCH_CHAN", current_params_on_board.sbusPitchChan);
        }
        if(pan_sbus_chan_num() != current_params_on_board.sbusYawChan){
            current_params_on_board.sbusYawChan = pan_sbus_chan_num() - 1;      // - 1 to get a real value for channel from display value in QML
            write_a_param_to_board("SBUS_YAW_CHAN", current_params_on_board.sbusYawChan);
        }
        if(roll_sbus_chan_num() != current_params_on_board.sbusRollChan){
            current_params_on_board.sbusRollChan = roll_sbus_chan_num() - 1;      // - 1 to get a real value for channel from display value in QML
            write_a_param_to_board("SBUS_ROLL_CHAN", current_params_on_board.sbusRollChan);
        }
        //    [!]
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

        if(tilt_lpf() != current_params_on_board.rcPitchLPF){
            current_params_on_board.rcPitchLPF = tilt_lpf();
            write_a_param_to_board("RC_PITCH_LPF", current_params_on_board.rcPitchLPF);
        }
        if(tilt_trim() != current_params_on_board.rcPitchTrim){
            current_params_on_board.rcPitchTrim = tilt_trim();
            write_a_param_to_board("RC_PITCH_TRIM", current_params_on_board.rcPitchTrim);
        }
        if(tilt_mode() != current_params_on_board.rcPitchMode){
            current_params_on_board.rcPitchMode = tilt_mode();
            write_a_param_to_board("RC_PITCH_MODE", current_params_on_board.rcPitchMode);
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
        if(pan_lpf() != current_params_on_board.rcYawLPF){
            current_params_on_board.rcYawLPF = pan_lpf();
            write_a_param_to_board("RC_YAW_LPF", current_params_on_board.rcYawLPF);
        }
        if(pan_trim() != current_params_on_board.rcYawTrim){
            current_params_on_board.rcYawTrim = pan_trim();
            write_a_param_to_board("RC_YAW_TRIM", current_params_on_board.rcYawTrim);
        }
        if(pan_mode() != current_params_on_board.rcYawMode){
            current_params_on_board.rcYawMode = pan_mode();
            write_a_param_to_board("RC_YAW_MODE", current_params_on_board.rcYawMode);
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
        if(roll_lpf() != current_params_on_board.rcRollLPF){
            current_params_on_board.rcRollLPF = roll_lpf();
            write_a_param_to_board("RC_ROLL_LPF", current_params_on_board.rcRollLPF);
        }
        if(roll_trim() != current_params_on_board.rcRollTrim){
            current_params_on_board.rcRollTrim = roll_trim();
            write_a_param_to_board("RC_ROLL_TRIM", current_params_on_board.rcRollTrim);
        }
        if(roll_mode() != current_params_on_board.rcRollMode){
            current_params_on_board.rcRollMode = roll_mode();
            write_a_param_to_board("RC_ROLL_MODE", current_params_on_board.rcRollMode);
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

        qDebug("C++>> Sending parameters to controller board...Done!");
        setmavlink_message_log("Sent parameters to controller board!");
    }
    else {
        qDebug("C++>> Communication error, please check the connection then write parammeters again *");
        setmavlink_message_log("Communication error, please check the connection then write parammeters again");
    }
}

void MavLinkManager::get_mavlink_info()
{
    Configuration m_config;
    setmavlink_message_log(QString("Onboard MAVlink Protocol Ver.: %1").arg(m_mavlink_heartbeat.mavlink_version));
    setmavlink_message_log(QString("Software MAVlink Protocol Ver.: %1").arg(MAVLINK_VERSION));
    setmavlink_message_log(QString("MAVlink Library Ver.: %1").arg(m_config.get_mavlink_lib_version()));
    setmavlink_message_log(QString("MAVlink for gStabi Build date: %1").arg(MAVLINK_BUILD_DATE));

}

float MavLinkManager::get_battery_percent_remain(float _vol)
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
    setkeycode_request(false);
    calib_type = CALIB_NONE;

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
}


void MavLinkManager::send_control_command(int tilt_angle_setpoint, int pan_angle_setpoint, int roll_angle_setpoint)
{
    uint16_t len=0;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];

    mavlink_msg_rc_simulation_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, tilt_angle_setpoint, roll_angle_setpoint, pan_angle_setpoint);
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
}

void MavLinkManager::calib_gyro()
{
    uint16_t len=0;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];
    mavlink_msg_imu_calib_request_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, 1, 0);  // '1' means gyro calib
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
    calib_type = GYRO_CALIB;
}

void MavLinkManager::calib_accel()
{
    uint16_t len=0;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];

    //    if(calib_mode() == 0) {
    //        qDebug("debug >> Calib acc in Basic mode");
    //        setmavlink_message_log("Start to calib Accel in Basic mode");
    //    }
    //    else if(calib_mode() == 1) {
    //        qDebug("debug >> Calib acc in Adv mode");
    //        setmavlink_message_log("Start to calib Accel in Advanced mode\n Calibration process will go through 6 steps for 6 faces.");
    //    }
    mavlink_msg_imu_calib_request_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, 0, calib_mode());  // '0' means acc calib
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
    calib_type = ACC_CALIB;
    calib_finished = false;

}

void MavLinkManager::send_keycode(int _keycode_value)
{
    uint16_t len=0;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];
    mavlink_msg_keycode_value_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, GSTABI, _keycode_value);
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
    qDebug() << "Sent keycode";
}

void MavLinkManager::send_unique_device_id_request()
{
    uint16_t len=0;
    mavlink_message_t msg;
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];
    mavlink_msg_unique_id_request_pack(SYSTEM_ID, MAV_COMP_ID_SERVO1, &msg, GSTABI);
    len = mavlink_msg_to_send_buffer(buf, &msg);
    emit messge_write_to_comport_ready((const char*)buf, len);
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

int MavLinkManager::gremsy_product_id() const
{
    return m_gremsy_product_id;
}

void MavLinkManager::setgremsy_product_id(int _product_id)
{
    m_gremsy_product_id = _product_id;
    emit gremsy_product_idChanged(m_gremsy_product_id);
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

int MavLinkManager::gyro_x_offset() const
{
    return m_gyro_x_offset;
}

void MavLinkManager::setgyro_x_offset(int _xoffset)
{
    m_gyro_x_offset = _xoffset;
    emit gyro_x_offsetChanged(m_gyro_x_offset);
}

int MavLinkManager::gyro_y_offset() const
{
    return m_gyro_y_offset;
}

void MavLinkManager::setgyro_y_offset(int _yoffset)
{
    m_gyro_y_offset = _yoffset;
    emit gyro_y_offsetChanged(m_gyro_y_offset);
}

int MavLinkManager::gyro_z_offset() const
{
    return m_gyro_z_offset;
}

void MavLinkManager::setgyro_z_offset(int _zoffset)
{
    m_gyro_z_offset = _zoffset;
    emit gyro_z_offsetChanged(m_gyro_z_offset);
}

int MavLinkManager::acc_x_offset() const
{
    return m_acc_x_offset;
}

void MavLinkManager::setacc_x_offset(int _xoffset)
{
    m_acc_x_offset = _xoffset;
    emit acc_x_offsetChanged(m_acc_x_offset);
}

int MavLinkManager::acc_y_offset() const
{
    return m_acc_y_offset;
}

void MavLinkManager::setacc_y_offset(int _yoffset)
{
    m_acc_y_offset = _yoffset;
    emit acc_y_offsetChanged(m_acc_y_offset);
}

int MavLinkManager::acc_z_offset() const
{
    return m_acc_z_offset;
}

void MavLinkManager::setacc_z_offset(int _zoffset)
{
    m_acc_z_offset = _zoffset;
    emit acc_z_offsetChanged(m_acc_z_offset);
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

float MavLinkManager::battery_voltage() const
{
    return m_battery_voltage;
}

void MavLinkManager::setbattery_voltage(float _vol)
{
    m_battery_voltage = _vol;
    emit battery_voltageChanged(m_battery_voltage);
}

bool MavLinkManager::use_gps() const
{
    return m_use_gps;
}

void MavLinkManager::setuse_gps(bool _use)
{
    m_use_gps = _use;
    emit use_gpsChanged(m_use_gps);
}

bool MavLinkManager::skip_gyro_calib() const
{
    return m_skip_gyro_calib;
}

void MavLinkManager::setskip_gyro_calib(int _skip)
{
    m_skip_gyro_calib = _skip;
    emit skip_gyro_calibChanged(m_skip_gyro_calib);
}

int MavLinkManager::gyro_trust() const
{
    return m_gyro_trust;
}

void MavLinkManager::setgyro_trust(int _value)
{
    m_gyro_trust = _value;
    emit gyro_trustChanged(m_gyro_trust);
}

int MavLinkManager::gyro_lpf() const
{
    return m_gyro_lpf;
}

void MavLinkManager::setgyro_lpf(int _value)
{
    m_gyro_lpf = _value;
    emit gyro_lpfChanged(m_gyro_lpf);
}

int MavLinkManager::calib_mode() const
{
    return m_calib_mode;

}

void MavLinkManager::setcalib_mode(int _mode)
{
    m_calib_mode = _mode;
    emit calib_modeChanged(m_calib_mode);
}

int MavLinkManager::motor_freq() const
{
    return m_motor_freq;
}

void MavLinkManager::setmotor_freq(int _freq)
{
    m_motor_freq = _freq;
    emit motor_freqChanged(m_motor_freq);
}

bool MavLinkManager::keycode_request() const
{
    return m_keycode_request;
}

void MavLinkManager::setkeycode_request(bool _request)
{
    m_keycode_request = _request;
    emit keycode_requestChanged(m_keycode_request);
}

int MavLinkManager::accel_calib_steps() const
{
    return m_accel_calib_steps;
}

void MavLinkManager::setaccel_calib_steps(int _step)
{
    m_accel_calib_steps = _step;
    emit accel_calib_stepsChanged(m_accel_calib_steps);
}

QString MavLinkManager::udid_values() const
{
    return m_udid_values;
}

void MavLinkManager::setudid_values(QString _udid_str)
{
    m_udid_values = _udid_str;
    emit udid_valuesChanged(m_udid_values);
}

int MavLinkManager::mode_sbus_chan_num() const
{
    return m_mode_sbus_chan_num;
}

void MavLinkManager::setmode_sbus_chan_num(int _chan_num)
{
    m_mode_sbus_chan_num = _chan_num;
    emit mode_sbus_chan_numChanged(m_mode_sbus_chan_num);
}

int MavLinkManager::mode_rc_sbus_level() const
{
    return m_mode_rc_sbus_level;
}

void MavLinkManager::setmode_rc_sbus_level(int _rc_level)
{
    m_mode_rc_sbus_level = _rc_level;
    emit mode_rc_sbus_levelChanged(m_mode_rc_sbus_level);
}

int MavLinkManager::mode_pwm_level() const
{
    return m_mode_pwm_level;
}

void MavLinkManager::setmode_pwm_level(int _pwm_level)
{
    m_mode_pwm_level = _pwm_level;
    emit mode_pwm_levelChanged(m_mode_pwm_level);
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

int MavLinkManager::tilt_sbus_chan_num() const
{
    return m_tilt_sbus_chan_num;
}

void MavLinkManager::settilt_sbus_chan_num(int _chan_num)
{
    m_tilt_sbus_chan_num = _chan_num;
    emit tilt_sbus_chan_numChanged(m_tilt_sbus_chan_num);
}

int MavLinkManager::tilt_rc_sbus_level() const
{
    return m_tilt_rc_sbus_level;
}

void MavLinkManager::settilt_rc_sbus_level(int _rc_level)
{
    m_tilt_rc_sbus_level = _rc_level;
    emit tilt_rc_sbus_levelChanged(m_tilt_rc_sbus_level);
}

int MavLinkManager::tilt_pwm_level() const
{
    return m_tilt_pwm_level;
}

void MavLinkManager::settilt_pwm_level(int _pwm_level)
{
    m_tilt_pwm_level = _pwm_level;
    emit tilt_pwm_levelChanged(m_tilt_pwm_level);
}

int MavLinkManager::pan_sbus_chan_num() const
{
    return m_pan_sbus_chan_num;
}

void MavLinkManager::setpan_sbus_chan_num(int _chan_num)
{
    m_pan_sbus_chan_num = _chan_num;
    emit pan_sbus_chan_numChanged(m_pan_sbus_chan_num);
}

int MavLinkManager::pan_rc_sbus_level() const
{
    return m_pan_rc_sbus_level;
}

void MavLinkManager::setpan_rc_sbus_level(int _rc_level)
{
    m_pan_rc_sbus_level = _rc_level;
    emit pan_rc_sbus_levelChanged(m_pan_rc_sbus_level);
}

int MavLinkManager::pan_pwm_level() const
{
    return m_pan_pwm_level;
}

void MavLinkManager::setpan_pwm_level(int _pwm_level)
{
    m_pan_pwm_level = _pwm_level;
    emit pan_pwm_levelChanged(m_pan_pwm_level);
}

int MavLinkManager::roll_sbus_chan_num() const
{
    return m_roll_sbus_chan_num;
}

void MavLinkManager::setroll_sbus_chan_num(int _chan_num)
{
    m_roll_sbus_chan_num = _chan_num;
    emit roll_sbus_chan_numChanged(m_roll_sbus_chan_num);
}

int MavLinkManager::roll_rc_sbus_level() const
{
    return m_roll_rc_sbus_level;
}

void MavLinkManager::setroll_rc_sbus_level(int _rc_level)
{
    m_roll_rc_sbus_level = _rc_level;
    emit roll_rc_sbus_levelChanged(m_roll_rc_sbus_level);
}

int MavLinkManager::roll_pwm_level() const
{
    return m_roll_pwm_level;
}

void MavLinkManager::setroll_pwm_level(int _pwm_level)
{
    m_roll_pwm_level = _pwm_level;
    emit roll_pwm_levelChanged(m_roll_pwm_level);
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

int MavLinkManager::pan_lpf() const
{
    return m_pan_lpf;
}

void MavLinkManager::setpan_lpf(int _lpf)
{
    m_pan_lpf = _lpf;
    emit pan_lpfChanged(m_pan_lpf);
}

int MavLinkManager::pan_trim() const
{
    return m_pan_trim;
}

void MavLinkManager::setpan_trim(int _trim)
{
    m_pan_trim = _trim;
    emit pan_trimChanged(m_pan_trim);
}

int MavLinkManager::pan_mode() const
{
    return m_pan_mode;
}

void MavLinkManager::setpan_mode(int _mode)
{
    m_pan_mode = _mode;
    emit pan_modeChanged(m_pan_mode);
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

int MavLinkManager::roll_lpf() const
{
    return m_roll_lpf;
}

void MavLinkManager::setroll_lpf(int _lpf)
{
    m_roll_lpf = _lpf;
    emit roll_lpfChanged(m_roll_lpf);
}

int MavLinkManager::roll_trim() const
{
    return m_roll_trim;
}

void MavLinkManager::setroll_trim(int _trim)
{
    m_roll_trim = _trim;
    emit roll_trimChanged(m_roll_trim);
}

int MavLinkManager::roll_mode() const
{
    return m_roll_mode;
}

void MavLinkManager::setroll_mode(int _mode)
{
    m_roll_mode = _mode;
    emit roll_modeChanged(m_roll_mode);
}




