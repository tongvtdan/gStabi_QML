#include "gLinkManager.h"

LinkManager::LinkManager(QObject *parent) :
    QObject(parent)
{
}

void LinkManager::connectLink(SerialLink *serial, MavLinkManager *_mavlink)
{
    connect(serial, SIGNAL(mavlink_data_ready(QByteArray)), _mavlink, SLOT(process_mavlink_message(QByteArray)));
    connect(serial, SIGNAL(isConnectedChanged(bool)), _mavlink, SLOT(link_connection_state_changed(bool)));
    connect(_mavlink, SIGNAL(messge_write_to_comport_ready(const char*,uint)), serial, SLOT(send_message_to_comport(const char*,uint)));
}
