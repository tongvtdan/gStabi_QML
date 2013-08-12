#include "gLinkManager.h"

LinkManager::LinkManager(QObject *parent) :
    QObject(parent)
{
}

void LinkManager::connectLink(SerialLink *serial, MavLinkManager *_mavlink)
{
    connect(serial, SIGNAL(mavlink_data_ready(QByteArray)), _mavlink, SLOT(process_seriallink_data(QByteArray)));
}
