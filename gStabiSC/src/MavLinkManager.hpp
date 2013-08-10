#ifndef MAVLINKMANAGER_HPP
#define MAVLINKMANAGER_HPP

#include <QObject>
//#include "gremsyBGC/mavlink.h"
//#include "globalData.h"
//#include "gMavlinkV1_0.h"
#include "thirdParty/mavlink/v1.0/gremsyBGC/mavlink.h"
#include "thirdParty/mavlink/v1.0/globalData.h"
#include "thirdParty/mavlink/v1.0/gMavlinkV1_0.h"


#define TARGET_SYSTEM_ID 10

class MavLinkManager : public QObject
{
    Q_OBJECT
public:
    explicit MavLinkManager(QObject *parent = 0);


    
signals:
    void mavlink_data_ready(QByteArray data);
public slots:
    void process_seriallink_data(QByteArray data);
private:
    void mavlink_init();
private:
    /// mavlink variables
    mavlink_attitude_t att;
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
};

#endif // MAVLINKMANAGER_HPP
