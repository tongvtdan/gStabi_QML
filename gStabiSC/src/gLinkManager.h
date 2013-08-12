#ifndef LINKMANAGER_H
#define LINKMANAGER_H

#include <QObject>
#include "src/MavLinkManager.hpp"
#include "src/SerialLink.h"

class LinkManager : public QObject
{
    Q_OBJECT
public:
    explicit LinkManager(QObject *parent = 0);

signals:
    
public slots:
    void connectLink(SerialLink *serial, MavLinkManager *_mavlink);

};

#endif // LINKMANAGER_H
