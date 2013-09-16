#ifndef MAVLINKMANAGER_HPP
#define MAVLINKMANAGER_HPP

#include <QObject>
#include <QTimer>


#include "thirdParty/mavlink/v1.0/gremsyBGC/mavlink.h"
#include "thirdParty/mavlink/v1.0/globalData.h"

/*
 * Some names are equal:
 *  Pitch   = Tilt
 *  Yaw     = Pan
 */

#define TARGET_SYSTEM_ID 10

#define ONLINE true
#define OFFLINE false

#define BATT_CELL_MIN		3.5
#define BATT_CELL_MAX 	4.2
#define BATT_CELL_ALARM	3.6

#define BATT_ALARM_OK		1
#define BATT_ALARM_LOW      2
#define BATT_ALARM_PC		3

#define BATT_NO_CELL		2
#define BATT_3_CELL			3
#define BATT_4_CELL			4
#define BATT_5_CELL			5
#define BATT_6_CELL			6

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
    Q_PROPERTY(int control_type READ control_type WRITE setcontrol_type NOTIFY control_typeChanged)
    Q_PROPERTY(float battery_voltage READ battery_voltage WRITE setbattery_voltage NOTIFY battery_voltageChanged)

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
    Q_PROPERTY(int  tilt_lpf     READ tilt_lpf    WRITE settilt_lpf    NOTIFY tilt_lpfChanged)
    Q_PROPERTY(int  tilt_trim    READ tilt_trim   WRITE settilt_trim   NOTIFY tilt_trimChanged)
    Q_PROPERTY(int  tilt_mode    READ tilt_mode   WRITE settilt_mode   NOTIFY tilt_modeChanged)
    Q_PROPERTY(int  tilt_sbus_chan_num  READ tilt_sbus_chan_num WRITE settilt_sbus_chan_num NOTIFY tilt_sbus_chan_numChanged)
    Q_PROPERTY(int  tilt_rc_sbus_level READ tilt_rc_sbus_level WRITE settilt_rc_sbus_level NOTIFY tilt_rc_sbus_levelChanged)
    Q_PROPERTY(int  tilt_pwm_level READ tilt_pwm_level WRITE settilt_pwm_level NOTIFY tilt_pwm_levelChanged)



    //Yaw axis, Pan Motor
        // use in QML, PIDConfigDialog
    Q_PROPERTY(float pan_kp        READ pan_kp     WRITE setpan_kp     NOTIFY pan_kpChanged)
    Q_PROPERTY(float pan_ki        READ pan_ki     WRITE setpan_ki     NOTIFY pan_kiChanged)
    Q_PROPERTY(float pan_kd        READ pan_kd     WRITE setpan_kd     NOTIFY pan_kdChanged)
    Q_PROPERTY(float pan_follow    READ pan_follow WRITE setpan_follow NOTIFY pan_followChanged)
    Q_PROPERTY(float pan_filter    READ pan_filter WRITE setpan_filter NOTIFY pan_filterChanged)
        // use in QML, MotorConfigDialog
    Q_PROPERTY(float pan_power         READ pan_power             WRITE setpan_power             NOTIFY pan_powerChanged)
    Q_PROPERTY(int motor_pan_dir       READ motor_pan_dir         WRITE setmotor_pan_dir         NOTIFY motor_pan_dirChanged)
    Q_PROPERTY(int motor_pan_num_poles READ motor_pan_num_poles   WRITE setmotor_pan_num_poles   NOTIFY motor_pan_num_polesChanged)
    Q_PROPERTY(int pan_cw_limit_angle  READ pan_cw_limit_angle    WRITE setpan_cw_limit_angle    NOTIFY pan_cw_limit_angleChanged)
    Q_PROPERTY(int pan_ccw_limit_angle READ pan_ccw_limit_angle   WRITE setpan_ccw_limit_angle  NOTIFY pan_ccw_limit_angleChanged)
        // use in QML, others dialog
    Q_PROPERTY(int  pan_lpf     READ pan_lpf    WRITE setpan_lpf    NOTIFY pan_lpfChanged)
    Q_PROPERTY(int  pan_trim    READ pan_trim   WRITE setpan_trim   NOTIFY pan_trimChanged)
    Q_PROPERTY(int  pan_mode    READ pan_mode   WRITE setpan_mode   NOTIFY pan_modeChanged)
//    Q_PROPERTY(int  pan_sbus_chan  READ pan_sbus_chan WRITE setpan_sbus_chan NOTIFY pan_sbus_chanChanged)

    //Roll axis, Roll Motor
        // use in QML, PIDConfigDialog
    Q_PROPERTY(float roll_kp        READ roll_kp     WRITE setroll_kp     NOTIFY roll_kpChanged)
    Q_PROPERTY(float roll_ki        READ roll_ki     WRITE setroll_ki     NOTIFY roll_kiChanged)
    Q_PROPERTY(float roll_kd        READ roll_kd     WRITE setroll_kd     NOTIFY roll_kdChanged)
    Q_PROPERTY(float roll_follow    READ roll_follow WRITE setroll_follow NOTIFY roll_followChanged)
    Q_PROPERTY(float roll_filter    READ roll_filter WRITE setroll_filter NOTIFY roll_filterChanged)
        // use in QML, MotorConfigDialog
    Q_PROPERTY(float roll_power         READ roll_power             WRITE setroll_power             NOTIFY roll_powerChanged)
    Q_PROPERTY(int motor_roll_dir       READ motor_roll_dir         WRITE setmotor_roll_dir         NOTIFY motor_roll_dirChanged)
    Q_PROPERTY(int motor_roll_num_poles READ motor_roll_num_poles   WRITE setmotor_roll_num_poles   NOTIFY motor_roll_num_polesChanged)
    Q_PROPERTY(int roll_up_limit_angle  READ roll_up_limit_angle    WRITE setroll_up_limit_angle    NOTIFY roll_up_limit_angleChanged)
    Q_PROPERTY(int roll_down_limit_angle READ roll_down_limit_angle WRITE setroll_down_limit_angle  NOTIFY roll_down_limit_angleChanged)
        // use in QML, others dialog
    Q_PROPERTY(int  roll_lpf     READ roll_lpf    WRITE setroll_lpf    NOTIFY roll_lpfChanged)
    Q_PROPERTY(int  roll_trim    READ roll_trim   WRITE setroll_trim   NOTIFY roll_trimChanged)
    Q_PROPERTY(int  roll_mode    READ roll_mode   WRITE setroll_mode   NOTIFY roll_modeChanged)
//    Q_PROPERTY(int  roll_sbus_chan  READ roll_sbus_chan WRITE setroll_sbus_chan NOTIFY roll_sbus_chanChanged)



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
    // General
    int control_type() const;
    void setcontrol_type(int _type);

    float battery_voltage() const;
    void setbattery_voltage(float _vol);


    // Parameters on board
    //[1] Tilt Motor
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

    int tilt_lpf() const;
    void settilt_lpf(int _lpf);

    int tilt_trim() const;
    void settilt_trim(int _trim);

    int tilt_mode() const;
    void settilt_mode(int _mode);

    int tilt_sbus_chan_num() const;
    void settilt_sbus_chan_num(int _chan_num);

    int tilt_rc_sbus_level() const;
    void settilt_rc_sbus_level(int _rc_level);

    int tilt_pwm_level() const;
    void settilt_pwm_level(int _pwm_level);



//    [1]
//    [2] Pan Motor
    float pan_kp() const;
    void setpan_kp(float _kp);

    float pan_ki() const;
    void setpan_ki(float _ki);

    float pan_kd() const;
    void setpan_kd(float _kd);

    float pan_power() const;
    void setpan_power(float _power);

    float pan_follow() const;
    void setpan_follow(float _follow);

    float pan_filter() const;
    void setpan_filter(float _filter);

    int motor_pan_dir() const;
    void setmotor_pan_dir(int _dir);

    int motor_pan_num_poles() const;
    void setmotor_pan_num_poles(int _poles);

    int pan_cw_limit_angle() const;
    void setpan_cw_limit_angle(int _min);

    int pan_ccw_limit_angle() const;
    void setpan_ccw_limit_angle(int _max);

    int pan_lpf() const;
    void setpan_lpf(int _lpf);

    int pan_trim() const;
    void setpan_trim(int _trim);

    int pan_mode() const;
    void setpan_mode(int _mode);
//    [2]
    //[3] Roll Motor
    float roll_kp() const;
    void setroll_kp(float _kp);

    float roll_ki() const;
    void setroll_ki(float _ki);

    float roll_kd() const;
    void setroll_kd(float _kd);

    float roll_power() const;
    void setroll_power(float _power);

    float roll_follow() const;
    void setroll_follow(float _follow);

    float roll_filter() const;
    void setroll_filter(float _filter);

    int motor_roll_dir() const;
    void setmotor_roll_dir(int _dir);

    int motor_roll_num_poles() const;
    void setmotor_roll_num_poles(int _poles);

    int roll_up_limit_angle() const;
    void setroll_up_limit_angle(int _min);

    int roll_down_limit_angle() const;
    void setroll_down_limit_angle(int _max);

    int roll_lpf() const;
    void setroll_lpf(int _lpf);

    int roll_trim() const;
    void setroll_trim(int _trim);

    int roll_mode() const;
    void setroll_mode(int _mode);
//    [3]


    //[!]  Q_PROPERTY

    void update_all_parameters_to_UI();
    void get_firmware_version();
    void get_hardware_serial_number();
    void get_attitude_data();

// function can be called form QML
    Q_INVOKABLE void write_params_to_board();
    Q_INVOKABLE void get_mavlink_info();
    Q_INVOKABLE float get_battery_percent_remain(float _vol);
    Q_INVOKABLE void request_all_params();      // function to read parameters from controller board
    Q_INVOKABLE void send_control_command(int tilt_angle_setpoint, int pan_angle_setpoint, int roll_angle_setpoint);


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
// General
    void control_typeChanged(int);
    void battery_voltageChanged(float);
    // Parameters on board;
//    [1] Tilt Motor
    void tilt_kpChanged(float);
    void tilt_kiChanged(float);
    void tilt_kdChanged(float);
    void tilt_powerChanged(float);
    void tilt_followChanged(float);
    void tilt_filterChanged(float);
    void motor_tilt_dirChanged(int);
    void motor_tilt_num_polesChanged(int);
    void tilt_up_limit_angleChanged(int);
    void tilt_down_limit_angleChanged(int);
    void tilt_lpfChanged(int);
    void tilt_trimChanged(int);
    void tilt_modeChanged(int);
    void tilt_sbus_chan_numChanged(int);
    void tilt_rc_sbus_levelChanged(int);
    void tilt_pwm_levelChanged(int);

//    [1]
//    [2] pan Motor
    void pan_kpChanged(float);
    void pan_kiChanged(float);
    void pan_kdChanged(float);
    void pan_powerChanged(float);
    void pan_followChanged(float);
    void pan_filterChanged(float);
    void motor_pan_dirChanged(int);
    void motor_pan_num_polesChanged(int);
    void pan_cw_limit_angleChanged(int);
    void pan_ccw_limit_angleChanged(int);
    void pan_lpfChanged(int);
    void pan_trimChanged(int);
    void pan_modeChanged(int);
//    [2]
//    [3] Roll Motor
    void roll_kpChanged(float);
    void roll_kiChanged(float);
    void roll_kdChanged(float);
    void roll_powerChanged(float);
    void roll_followChanged(float);
    void roll_filterChanged(float);
    void motor_roll_dirChanged(int);
    void motor_roll_num_polesChanged(int);
    void roll_up_limit_angleChanged(int);
    void roll_down_limit_angleChanged(int);
    void roll_lpfChanged(int);
    void roll_trimChanged(int);
    void roll_modeChanged(int);
//    [3]



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
    void update_rc_sbus_value();
    void update_pwm_values();


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
    mavlink_ppm_chan_values_t pwm_values;
    global_struct global_data;
    gConfig_t current_params_on_board;
    mavlink_heartbeat_t m_mavlink_heartbeat;
    mavlink_system_status_t m_g_system_status;
    int rc_sbus_level[18];

//    [!] Q_PROPERTY

    bool m_hb_pulse;
    bool m_board_connection_state;
    QString m_mavlink_message_log;

    // IMU data
    float m_roll_angle, m_pitch_angle, m_yaw_angle;
    // General
    int m_control_type;
    float m_battery_voltage;
    // Parameters on board
//    [1] Tilt Motor
    float m_tilt_kp, m_tilt_ki, m_tilt_kd, m_tilt_power, m_tilt_follow, m_tilt_filter;
    int m_motor_tilt_dir, m_tilt_up_limit_angle, m_tilt_down_limit_angle, m_motor_tilt_num_poles;
    int m_tilt_lpf, m_tilt_trim, m_tilt_mode, m_tilt_sbus_chan_num, m_tilt_rc_sbus_level, m_tilt_pwm_level;
//    [2] Pan Motor
    float m_pan_kp, m_pan_ki, m_pan_kd, m_pan_power, m_pan_follow, m_pan_filter;
    int m_motor_pan_dir, m_pan_cw_limit_angle, m_pan_ccw_limit_angle, m_motor_pan_num_poles, m_pan_lpf, m_pan_trim, m_pan_mode;
//    [3] Roll Motor
    float m_roll_kp, m_roll_ki, m_roll_kd, m_roll_power, m_roll_follow, m_roll_filter;
    int m_motor_roll_dir, m_roll_up_limit_angle, m_roll_down_limit_angle, m_motor_roll_num_poles, m_roll_lpf, m_roll_trim, m_roll_mode;

//    [!]
    QTimer *linkConnectionTimer; // this timer will monitor message on mavlink, if timer timeout, lost connection.
    bool isConnected;            // use to monitor the status of board's connection to control the timer
    QString system_msg_log;             // system log message
    bool heartbeat_state;        // store heartbeat status

    bool first_data_pack;        // this will be check when mavlink message was received, to check whether it's 1st time to received the message
                                // if true: Request to Read all parameters to display on UI and store in current parameters.
                                // if false: continue to parse message to get data.

};

#endif // MAVLINKMANAGER_HPP
