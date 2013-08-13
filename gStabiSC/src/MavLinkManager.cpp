#include "MavLinkManager.hpp"
#include <QDebug>

MavLinkManager::MavLinkManager(QObject *parent) :
    QObject(parent)
{
    linkConnectionTimer = new QTimer(this);
    linkConnectionTimer->setSingleShot(true);

    connect(linkConnectionTimer,SIGNAL(timeout()),this, SLOT(connection_timeout()));

    mavlink_init();
}

void MavLinkManager::process_seriallink_data(QByteArray data)
{
    mavlink_message_t message;
    mavlink_status_t status;
    unsigned int decodeState;
    uint8_t byte;

    for(int position = 0; position < data.size(); position++)
    {
        byte = data[position];
        decodeState = mavlink_parse_char(MAVLINK_COMM_0,byte, &message, &status);
//        Q_UNUSED(decodeState);
        if(decodeState) {
            RestartLinkConnectionTimer(1000);   // Connection OK, Restart the connection watchdog timer
            setboard_connection_state(ONLINE);
        }

        switch (message.msgid)
        {
        case MAVLINK_MSG_ID_HEARTBEAT:
            mavlink_heartbeat_t heartbeat;
            heartbeat.mavlink_version = 0;
            mavlink_msg_heartbeat_decode(&message,&heartbeat);
            if(heartbeat.mavlink_version == MAVLINK_VERSION ){
                sethb_pulse(true);
                qDebug()<< "Received: HB";
                setmsg_received("Received: HB \n");
            }
            else
                sethb_pulse(false);

            break;
        case MAVLINK_MSG_ID_RAW_IMU:
            raw_imu.xacc = mavlink_msg_raw_imu_get_xacc(&message);
            raw_imu.yacc = mavlink_msg_raw_imu_get_yacc(&message);
            raw_imu.zacc = mavlink_msg_raw_imu_get_zacc(&message);
            raw_imu.xgyro = mavlink_msg_raw_imu_get_xgyro(&message);
            raw_imu.ygyro = mavlink_msg_raw_imu_get_ygyro(&message);
            raw_imu.zgyro = mavlink_msg_raw_imu_get_zgyro(&message);
            setmsg_received("Received: raw IMU Data \n");
            qDebug()<< "Received: raw IMU Data";
            break;
        case MAVLINK_MSG_ID_ATTITUDE:
            attitude.roll = mavlink_msg_attitude_get_roll(&message);
            attitude_degree.roll = attitude.roll*180/PI;     // convert to deg
            attitude.pitch = mavlink_msg_attitude_get_pitch(&message);
            attitude_degree.pitch = attitude.pitch*180/PI;
            attitude.yaw = mavlink_msg_attitude_get_yaw(&message);
            attitude_degree.yaw = attitude.yaw*180/PI;
            setmsg_received("Received:  Attitude Data\n");
            qDebug()<< "Received:  Attitude Data";
//            emit attitudeChanged(attitude_degree.pitch, attitude_degree.roll, attitude_degree.yaw);
            break;
        case MAVLINK_MSG_ID_PARAM_VALUE:
            paramValue.param_index = mavlink_msg_param_value_get_param_index(&message);  // get param index
            paramValue.param_value = mavlink_msg_param_value_get_param_value(&message);  // get param value
//            emit paramValueChanged(paramValue.param_index, paramValue.param_value);
            break;
        case MAVLINK_MSG_ID_SBUS_CHAN_VALUES:
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
            setmsg_received("Received: raw SBUS Data \n");
            qDebug()<< "Received: raw SBUS Data";
//            emit updateSbusValues();
            break;

        case MAVLINK_MSG_ID_ACC_CALIB_STATUS:
            acc_calib_sta.acc_calib_status = mavlink_msg_acc_calib_status_get_acc_calib_status(&message);
            setmsg_received("Received:  Acc calib Data \n");
            qDebug()<< "Received:  Acc calib Data";
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
            break;
            */
        case MAVLINK_MSG_ID_GYRO_CALIB_STATUS:
            gyro_calib_sta.status = mavlink_msg_gyro_calib_status_get_status(&message);
            setmsg_received("Received: gyro calib Data\n");
            qDebug()<< "Received: gyro calib Data";
            break;
        default:
            break;
        } // end of switch
    }
}

void MavLinkManager::connection_timeout()
{
    setboard_connection_state(OFFLINE);
    qDebug() << "Lost Connection";
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

QString MavLinkManager::msg_received() const
{
    return m_msg_received;
}

void MavLinkManager::setmsg_received(QString msg_data)
{
    m_msg_received = msg_data;
    emit msg_receivedChanged(m_msg_received);
}

void MavLinkManager::mavlink_init()
{
    system_type = MAV_TYPE_FIXED_WING;
    autopilot_type = MAV_AUTOPILOT_GENERIC;
    system_mode = MAV_MODE_PREFLIGHT; ///< Booting up
    custom_mode = 0;                 ///< Custom mode, can be defined by user/adopter
    system_state = MAV_STATE_STANDBY; ///< System ready for flight
    //    sethb_pulse(false);
}

void MavLinkManager::RestartLinkConnectionTimer(int msec)
{
    linkConnectionTimer->stop();
    linkConnectionTimer->start(msec);

}
