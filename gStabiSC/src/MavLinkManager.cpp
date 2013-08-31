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
                mavlink_heartbeat_t heartbeat;
                heartbeat.mavlink_version = 0;
                mavlink_msg_heartbeat_decode(&message,&heartbeat);
                if(heartbeat.mavlink_version == MAVLINK_VERSION ){
                    sethb_pulse(true);
                }
                else
                    sethb_pulse(false);
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
            case MAVLINK_MSG_ID_ACC_CALIB_STATUS: { // get acc calib data
                acc_calib_sta.acc_calib_status = mavlink_msg_acc_calib_status_get_acc_calib_status(&message);
                /*
            switch(acc_calib_sta.acc_calib_status)
            {
                case ACC_CALIB_FINISH:
                    ui->acc_calib_label->setText("Acc calib finished!");
                break;
                case ONE_REMAINING_FACE:
                    ui->acc_calib_label->setText("One remaining face");
                break;
                case TWO_REMAINING_FACES:
                    ui->acc_calib_label->setText("Two remaining faces");
                break;
                case THREE_REMAINING_FACES:
                    ui->acc_calib_label->setText("Three remaining faces");
                break;
                case FOUR_REMAINING_FACES:
                    ui->acc_calib_label->setText("Four remaining faces");
                break;
                case FIVE_REMAINING_FACES:
                    ui->acc_calib_label->setText("Five remaining faces");
                break;
                case SIX_REMAINING_FACES:
                    ui->acc_calib_label->setText("Six remaining faces");
                break;
                case ACC_CALIB_FAIL:
                    ui->acc_calib_label->setText("Acc calib failed!");
                break;
            }
            */
            }
                break;

            case MAVLINK_MSG_ID_GYRO_CALIB_STATUS:  { // get gyro calib data
                gyro_calib_sta.status = mavlink_msg_gyro_calib_status_get_status(&message);
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

    //    ui->information_box->clear();
    //    ui->information_box->setPlainText("Read Parameters completed.");
    //    ui->readParam->setEnabled(true);

}


void MavLinkManager::update_all_parameters_to_UI()
{
    if(!first_data_pack)    // to ensure all params read
    {
        get_firmware_version();
        get_hardware_serial_number();
        settiltKp(current_params_on_board.pitchKp);
        settiltKi(current_params_on_board.pitchKi);
        settiltKd(current_params_on_board.pitchKd);
        setmavlink_message_log(QString("Tilt(Kp,Ki,Kid): %1, %2, %3").arg(current_params_on_board.pitchKp).arg(current_params_on_board.pitchKi).arg(current_params_on_board.pitchKd));
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
    settilt_angle(attitude_degree.pitch);           // set value to Q_PROPERTY variables so they can be read from QML
    setyaw_angle(attitude_degree.yaw);              // set value to Q_PROPERTY variables so they can be read from QML

}

void MavLinkManager::mavlink_init()
{
    system_type = MAV_TYPE_FIXED_WING;
    autopilot_type = MAV_AUTOPILOT_GENERIC;
    system_mode = MAV_MODE_PREFLIGHT; ///< Booting up
    custom_mode = 0;                 ///< Custom mode, can be defined by user/adopter
    system_state = MAV_STATE_STANDBY; ///< System ready for flight
    first_data_pack = true;           // this will be check when mavlink message was received, to check whether it's 1st time to received the message
    //    sethb_pulse(false);
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
    setmavlink_message_log("Requesting all parameters on board...");
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
//    return system_msg_log;
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

float MavLinkManager::tilt_angle() const
{
    return m_tilt_angle;
}

void MavLinkManager::settilt_angle(float _angle)
{
    m_tilt_angle = _angle;
    emit tilt_angleChanged(m_tilt_angle);
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

float MavLinkManager::tiltKp() const
{
    return m_tiltKp;
}

void MavLinkManager::settiltKp(float _kp)
{
    m_tiltKp = _kp;
    emit tiltKpChanged(m_tiltKp);
}

float MavLinkManager::tiltKi() const
{
    return m_tiltKi;
}

void MavLinkManager::settiltKi(float _ki)
{
    m_tiltKi = _ki;
    emit tiltKiChanged(m_tiltKi);
}

float MavLinkManager::tiltKd() const
{
    return m_tiltKd;
}

void MavLinkManager::settiltKd(float _kd)
{
    m_tiltKd = _kd;
    emit tiltKdChanged(m_tiltKd);
}
