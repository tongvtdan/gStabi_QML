#ifndef MAVLINKMANAGER_HPP
#define MAVLINKMANAGER_HPP

#include <QObject>
#include <QTimer>


#include "thirdParty/mavlink/v1.0/gremsyBGC/mavlink.h"
#include "thirdParty/mavlink/v1.0/globalData.h"
#include "thirdParty/mavlink/v1.0/gMavlinkV1_0.h"
/*
 * Some names are equal:
 *  Pitch   = Tilt
 *  Yaw     = Pan
 */

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
    Q_PROPERTY(float roll_angle  READ roll_angle    WRITE setroll_angle     NOTIFY roll_angleChanged)
    Q_PROPERTY(float pitch_angle READ pitch_angle   WRITE setpitch_angle    NOTIFY pitch_angleChanged)
    Q_PROPERTY(float yaw_angle   READ yaw_angle     WRITE setyaw_angle      NOTIFY yaw_angleChanged)
    //General
//    Q_PROPERTY(int motorFreq READ motorFreq WRITE setmotorFreq NOTIFY motorFreqChanged)

    // Parameters data
    //Pitch axis, Tilt Motor
        // use in QML, PIDConfigDialog
    Q_PROPERTY(float tilt_kp        READ tilt_kp     WRITE settilt_kp     NOTIFY tilt_kpChanged)
    Q_PROPERTY(float tilt_ki        READ tilt_ki     WRITE settilt_ki     NOTIFY tilt_kiChanged)
    Q_PROPERTY(float tilt_kd        READ tilt_kd     WRITE settilt_kd     NOTIFY tilt_kdChanged)
    Q_PROPERTY(float tilt_follow    READ tilt_follow WRITE settilt_follow NOTIFY tilt_followChanged)
    Q_PROPERTY(float tilt_filter    READ tilt_filter WRITE settilt_filter NOTIFY tilt_filterChanged)
        // use in QML, MotorConfigDialog
    Q_PROPERTY(float tilt_power         READ tilt_power             WRITE settilt_power             NOTIFY tilt_powerChanged)
    Q_PROPERTY(int motor_tilt_dir       READ motor_tilt_dir         WRITE setmotor_tilt_dir         NOTIFY motor_tilt_dirChanged)
    Q_PROPERTY(int motor_tilt_num_poles READ motor_tilt_num_poles   WRITE setmotor_tilt_num_poles   NOTIFY motor_tilt_num_polesChanged)
    Q_PROPERTY(int tilt_up_limit_angle  READ tilt_up_limit_angle    WRITE settilt_up_limit_angle    NOTIFY tilt_up_limit_angleChanged)
    Q_PROPERTY(int tilt_down_limit_angle READ tilt_down_limit_angle WRITE settilt_down_limit_angle  NOTIFY tilt_down_limit_angleChanged)
        // use in QML, others dialog
//    Q_PROPERTY(int  tilt_rc_lpf     READ tilt_rc_lpf    WRITE settilt_rc_lpf    NOTIFY tilt_rc_lpfChanged)
//    Q_PROPERTY(int  tilt_rc_trim    READ tilt_rc_trim   WRITE settilt_rc_trim   NOTIFY tilt_rc_trimChanged)
//    Q_PROPERTY(int  tilt_rc_mode    READ tilt_rc_mode   WRITE settilt_rc_mode   NOTIFY tilt_rc_modeChanged)
//    Q_PROPERTY(int  tilt_sbus_chan  READ tilt_sbus_chan WRITE settilt_sbus_chan NOTIFY tilt_sbus_chanChanged)

    //Yaw axis, Pan Motor
        // use in QML, PIDConfigDialog
//    Q_PROPERTY(float pan_kp        READ pan_kp     WRITE setpan_kp     NOTIFY pan_kpChanged)
//    Q_PROPERTY(float pan_ki        READ pan_ki     WRITE setpan_ki     NOTIFY pan_kiChanged)
//    Q_PROPERTY(float pan_kd        READ pan_kd     WRITE setpan_kd     NOTIFY pan_kdChanged)
//    Q_PROPERTY(float pan_follow    READ pan_follow WRITE setpan_follow NOTIFY pan_followChanged)
//    Q_PROPERTY(float pan_filter    READ pan_filter WRITE setpan_filter NOTIFY pan_filterChanged)
//        // use in QML, MotorConfigDialog
//    Q_PROPERTY(float pan_power         READ pan_power             WRITE setpan_power             NOTIFY pan_powerChanged)
//    Q_PROPERTY(int motor_pan_dir       READ motor_pan_dir         WRITE setmotor_pan_dir         NOTIFY motor_pan_dirChanged)
//    Q_PROPERTY(int motor_pan_num_poles READ motor_pan_num_poles   WRITE setmotor_pan_num_poles   NOTIFY motor_pan_num_polesChanged)
//    Q_PROPERTY(int pan_cw_limit_angle  READ pan_cw_limit_angle    WRITE setpan_cw_limit_angle    NOTIFY pan_cw_limit_angleChanged)
//    Q_PROPERTY(int pan_ccw_limit_angle READ pan_ccw_limit_angle   WRITE setpan_down_limit_angle  NOTIFY pan_ccw_limit_angleChanged)
        // use in QML, others dialog
//    Q_PROPERTY(int  pan_rc_lpf     READ pan_rc_lpf    WRITE setpan_rc_lpf    NOTIFY pan_rc_lpfChanged)
//    Q_PROPERTY(int  pan_rc_trim    READ pan_rc_trim   WRITE setpan_rc_trim   NOTIFY pan_rc_trimChanged)
//    Q_PROPERTY(int  pan_rc_mode    READ pan_rc_mode   WRITE setpan_rc_mode   NOTIFY pan_rc_modeChanged)
//    Q_PROPERTY(int  pan_sbus_chan  READ pan_sbus_chan WRITE setpan_sbus_chan NOTIFY pan_sbus_chanChanged)




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

    float pitch_angle() const;
    void setpitch_angle(float _angle);

    float yaw_angle() const;
    void setyaw_angle(float _angle);
    // Parameters on board
    float tilt_kp() const;
    void settilt_kp(float _kp);

    float tilt_ki() const;
    void settilt_ki(float _ki);

    float tilt_kd() const;
    void settilt_kd(float _kd);

    float tilt_power() const;
    void settilt_power(float _power);

    float tilt_follow() const;
    void settilt_follow(float _follow);

    float tilt_filter() const;
    void settilt_filter(float _filter);

    int motor_tilt_dir() const;
    void setmotor_tilt_dir(int _dir);

    int motor_tilt_num_poles() const;
    void setmotor_tilt_num_poles(int _poles);

    int tilt_up_limit_angle() const;
    void settilt_up_limit_angle(int _min);

    int tilt_down_limit_angle() const;
    void settilt_down_limit_angle(int _max);


    //[!]  Q_PROPERTY

    void update_all_parameters_to_UI();
    void get_firmware_version();
    void get_hardware_serial_number();
    void get_attitude_data();

// function can be called form QML
    Q_INVOKABLE void write_params_to_board();
    Q_INVOKABLE void get_mavlink_info();
    Q_INVOKABLE void request_all_params();      // function to read parameters from controller board

signals:
    void mavlink_data_ready(QByteArray data);

    //[!] Q_PROPERTY
    void hb_pulseChanged(bool);
    void board_connection_stateChanged(bool);
    void mavlink_message_logChanged(QString);
    // IMU data
    void roll_angleChanged(float);
    void pitch_angleChanged(float);
    void yaw_angleChanged(float);

    // Parameters on board;
    void tilt_kpChanged(float);
    void tilt_kiChanged(float);
    void tilt_kdChanged(float);
    void tilt_powerChanged(float);
    void tilt_followChanged(float);
    void tilt_filterChanged(float);
    void motor_tilt_dirChanged(int8_t);
    void motor_tilt_num_polesChanged(uint8_t);
    void tilt_up_limit_angleChanged(int);
    void tilt_down_limit_angleChanged(int);



    //[!]
    // signal will trigger a slot in SerialLink, signal-slot connection is created in gLinkManager
    void messge_write_to_comport_ready(const char *_buf, unsigned int _len);

public slots:
    void process_mavlink_message(QByteArray);

    void connection_timeout(); // trigger when lost connection
    void link_connection_state_changed(bool connection_state);


private:
    void mavlink_init();
    void RestartLinkConnectionTimer(int msec);
    void write_a_param_to_board(const char *param_id, float _value);
    void update_all_parameters(uint8_t index, float value);


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
    mavlink_heartbeat_t m_mavlink_heartbeat;
//    [!] Q_PROPERTY
    bool m_hb_pulse;
    bool m_board_connection_state;
    QString m_mavlink_message_log;

    // IMU data
    float m_roll_angle, m_pitch_angle, m_yaw_angle;

    // Parameters on board
    float m_tilt_kp, m_tilt_ki, m_tilt_kd, m_tilt_power, m_tilt_follow, m_tilt_filter;
    int m_dirMotortilt, m_tilt_up_limit_angle, m_tilt_down_limit_angle, m_motor_tilt_num_poles;

//    [1!
    QTimer *linkConnectionTimer; // this timer will monitor message on mavlink, if timer timeout, lost connection.
    bool isConnected;            // use to monitor the status of board's connection to control the timer
    QString system_msg_log;             // system log message

    bool first_data_pack;        // this will be check when mavlink message was received, to check whether it's 1st time to received the message
                                // if true: Request to Read all parameters to display on UI and store in current parameters.
                                // if false: continue to parse message to get data.

};

#endif // MAVLINKMANAGER_HPP
