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
    Q_PROPERTY(QString mavlink_message_log READ mavlink_message_log WRITE setmavlink_message_log NOTIFY mavlink_message_logChanged)
    // IMU data
    Q_PROPERTY(float roll_angle READ roll_angle WRITE setroll_angle NOTIFY roll_angleChanged)
    Q_PROPERTY(float tilt_angle READ tilt_angle WRITE settilt_angle NOTIFY tilt_angleChanged)
    Q_PROPERTY(float yaw_angle READ yaw_angle WRITE setyaw_angle NOTIFY yaw_angleChanged)
    // Parameters data
    Q_PROPERTY(float tiltKp READ tiltKp WRITE settiltKp NOTIFY tiltKpChanged)
    Q_PROPERTY(float tiltKi READ tiltKi WRITE settiltKi NOTIFY tiltKiChanged)
    Q_PROPERTY(float tiltKd READ tiltKd WRITE settiltKd NOTIFY tiltKdChanged)
    Q_PROPERTY(float tiltPower READ tiltPower WRITE settiltPower NOTIFY tiltPowerChanged)
    Q_PROPERTY(float tiltFollow READ tiltFollow WRITE settiltFollow NOTIFY tiltFollowChanged)
    Q_PROPERTY(float tiltFilter READ tiltFilter WRITE settiltFilter NOTIFY tiltFilterChanged)
    Q_PROPERTY(int8_t dirMotortilt READ dirMotortilt WRITE setdirMotortilt NOTIFY dirMotortiltChanged)
    Q_PROPERTY(uint8_t nPolestilt READ nPolestilt WRITE setnPolestilt NOTIFY nPolestiltChanged)





public:
    explicit MavLinkManager(QObject *parent = 0);


    //[!] Q_PROPERTY functions
    bool hb_pulse() const;
    void sethb_pulse(bool state);

    bool board_connection_state() const;
    void setboard_connection_state(bool _state);

    QString mavlink_message_log() const;
    void setmavlink_message_log(QString msg_data);


    //IMU data
    float roll_angle() const;
    void setroll_angle(float _angle);

    float tilt_angle() const;
    void settilt_angle(float _angle);

    float yaw_angle() const;
    void setyaw_angle(float _angle);
    // Parameters on board
    float tiltKp() const;
    void settiltKp(float _kp);

    float tiltKi() const;
    void settiltKi(float _ki);

    float tiltKd() const;
    void settiltKd(float _kd);

    float tiltPower() const;
    void settiltPower(float _power);

    float tiltFollow() const;
    void settiltFollow(float _follow);

    float tiltFilter() const;
    void settiltFilter(float _filter);

    int8_t dirMotortilt() const;
    void setdirMotortilt(int8_t);

    uint8_t nPolestilt() const;
    void setnPolestilt(uint8_t);



    //[!]  Q_PROPERTY

    void update_all_parameters_to_UI();
    void get_firmware_version();
    void get_hardware_serial_number();
    void get_attitude_data();
    
signals:
    void mavlink_data_ready(QByteArray data);

    //[!] Q_PROPERTY
    void hb_pulseChanged(bool);
    void board_connection_stateChanged(bool);
    void mavlink_message_logChanged(QString);
    // IMU data
    void roll_angleChanged(float);
    void tilt_angleChanged(float);
    void yaw_angleChanged(float);

    // Parameters on board;
    void tiltKpChanged(float);
    void tiltKiChanged(float);
    void tiltKdChanged(float);
    void tiltPowerChanged(float);
    void tiltFollowChanged(float);
    void tiltFilterChanged(float);
    void dirMotortiltChanged(int8_t);
    void nPolestiltChanged(uint8_t);


    //[!]
    // signal will trigger a slot in SerialLink, signal-slot connection is created in gLinkManager
    void messge_write_to_comport_ready(const char *_buf, unsigned int _len);

public slots:
    void process_mavlink_message(QByteArray);

    void connection_timeout(); // trigger when lost connection
    void link_connection_state_changed(bool connection_state);
    void update_all_parameters(uint8_t index, float value);

private:
    void mavlink_init();
    void RestartLinkConnectionTimer(int msec);
    void request_all_params();      // function to read parameters from controller board


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
    gConfig_t current_params_on_board;
//    [!] Q_PROPERTY
    bool m_hb_pulse;
    bool m_board_connection_state;
    QString m_mavlink_message_log;

    // IMU data
    float m_roll_angle, m_tilt_angle, m_yaw_angle;

    // Parameters on board
    float m_tiltKp, m_tiltKi, m_tiltKd, m_tiltPower, m_tiltFollow, m_tiltFilter;


//    [1!
    QTimer *linkConnectionTimer; // this timer will monitor message on mavlink, if timer timeout, lost connection.
    bool isConnected;            // use to monitor the status of board's connection to control the timer
    QString system_msg_log;             // system log message

    bool first_data_pack;        // this will be check when mavlink message was received, to check whether it's 1st time to received the message
                                // if true: Request to Read all parameters to display on UI and store in current parameters.
                                // if false: continue to parse message to get data.

};

#endif // MAVLINKMANAGER_HPP
