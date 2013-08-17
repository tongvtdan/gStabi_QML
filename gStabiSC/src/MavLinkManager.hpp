#ifndef MAVLINKMANAGER_HPP
#define MAVLINKMANAGER_HPP

#include <QObject>
#include <QTimer>
//#include "gremsyBGC/mavlink.h"
//#include "globalData.h"
//#include "gMavlinkV1_0.h"
#include "thirdParty/mavlink/v1.0/gremsyBGC/mavlink.h"
#include "thirdParty/mavlink/v1.0/globalData.h"
#include "thirdParty/mavlink/v1.0/gMavlinkV1_0.h"


#define TARGET_SYSTEM_ID 10
#define ONLINE true
#define OFFLINE false
class MavLinkManager : public QObject
{
    Q_OBJECT
    // interface with QML
    Q_PROPERTY(bool hb_pulse READ hb_pulse WRITE sethb_pulse NOTIFY hb_pulseChanged)
    Q_PROPERTY(bool board_connection_state READ board_connection_state WRITE setboard_connection_state NOTIFY board_connection_stateChanged )
    Q_PROPERTY(QString msg_received READ msg_received WRITE setmsg_received NOTIFY msg_receivedChanged)
    // IMU data
    Q_PROPERTY(float roll_angle READ roll_angle WRITE setroll_angle NOTIFY roll_angleChanged)
    Q_PROPERTY(float tilt_angle READ tilt_angle WRITE settilt_angle NOTIFY tilt_angleChanged)
    Q_PROPERTY(float yaw_angle READ yaw_angle WRITE setyaw_angle NOTIFY yaw_angleChanged)

public:
    explicit MavLinkManager(QObject *parent = 0);


    //[!] Q_PROPERTY functions
    bool hb_pulse() const;
    void sethb_pulse(bool state);

    bool board_connection_state() const;
    void setboard_connection_state(bool _state);

    QString msg_received() const;
    void setmsg_received(QString msg_data);

    // IMU data
    float roll_angle() const;
    void setroll_angle(float _angle);

    float tilt_angle() const;
    void settilt_angle(float _angle);

    float yaw_angle() const;
    void setyaw_angle(float _angle);

    //[!]
    
signals:
    void mavlink_data_ready(QByteArray data);

    //[!] Q_PROPERTY
    void hb_pulseChanged(bool);
    void board_connection_stateChanged(bool);
    void msg_receivedChanged(QString);
    // IMU data
    void roll_angleChanged(float);
    void tilt_angleChanged(float);
    void yaw_angleChanged(float);

    //[!]
public slots:
    void process_seriallink_data(QByteArray);

    void connection_timeout(); // trigger when lost connection
    void link_connection_state_changed(bool connection_state);


private:
    void mavlink_init();
    void RestartLinkConnectionTimer(int msec);

private:
    /// mavlink variables
    mavlink_attitude_t att;
    mavlink_attitude_t attitude_degree;  // to convert rad to deg
    mavlink_system_t mavlink_system;
    // Define the system type, in this case an airplane
    uint8_t system_type ;
    uint8_t autopilot_type ;

    uint8_t system_mode; ///< Booting up
    uint32_t custom_mode;                 ///< Custom mode, can be defined by user/adopter
    uint8_t system_state; ///< System ready for flight

    mavlink_raw_imu_t raw_imu;
    mavlink_attitude_t attitude;
    mavlink_param_request_read_t request_read;
    mavlink_param_value_t paramValue;
    mavlink_sbus_chan_values_t sbus_chan_values;
    mavlink_acc_calib_status_t acc_calib_sta;
    mavlink_gyro_calib_status_t gyro_calib_sta;
    global_struct global_data;
    gConfig_t oldParamConfig;
//    [!] Q_PROPERTY
    bool m_hb_pulse;
    bool m_board_connection_state;
    QString m_msg_received;
    // IMU data
    float m_roll_angle, m_tilt_angle, m_yaw_angle;


//    [1!
    QTimer *linkConnectionTimer; // this timer will monitor message on mavlink, if timer timeout, lost connection.
    bool isConnected;
    QString system_msg_log;             // system log message

};

#endif // MAVLINKMANAGER_HPP
