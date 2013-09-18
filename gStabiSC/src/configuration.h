#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <QObject>

#include "thirdParty/mavlink/config.h"

#define APPLICATION_NAME "gStabiSC"
#define APPLICATION_VERSION "V.2.1.1(beta-rc1)"
#define APPLICATION_WIDTH 1024
#define APPLICATION_HEIGHT 700

class Configuration : public QObject
{
    Q_OBJECT
public:
    explicit Configuration(QObject *parent = 0);


    Q_INVOKABLE QString application_name()
    {
        return APPLICATION_NAME;
    }
    Q_INVOKABLE QString application_version()
    {
        return APPLICATION_VERSION;
    }
    Q_INVOKABLE int application_width(){
        return APPLICATION_WIDTH;
    }
    Q_INVOKABLE int application_height(){
        return APPLICATION_HEIGHT;
    }
    QString get_mavlink_lib_version(){
        return MAVLINK_VERSION_LIB;
    }


signals:

public slots:

};

#endif // CONFIGURATION_H
