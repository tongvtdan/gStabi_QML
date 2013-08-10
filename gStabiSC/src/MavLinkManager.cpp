#include "MavLinkManager.hpp"

MavLinkManager::MavLinkManager(QObject *parent) :
    QObject(parent)
{
    mavlink_init();
}

void MavLinkManager::process_seriallink_data(QByteArray data)
{

}

void MavLinkManager::mavlink_init()
{
    system_type = MAV_TYPE_FIXED_WING;
    autopilot_type = MAV_AUTOPILOT_GENERIC;
    system_mode = MAV_MODE_PREFLIGHT; ///< Booting up
    custom_mode = 0;                 ///< Custom mode, can be defined by user/adopter
    system_state = MAV_STATE_STANDBY; ///< System ready for flight
}
