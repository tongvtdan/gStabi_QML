#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <QObject>

#include "thirdParty/mavlink/config.h"

#define APPLICATION_NAME "gStabiSC"
#define APPLICATION_VERSION "V.2.1.2(beta-rc2)"
#define APPLICATION_WIDTH 1024
#define APPLICATION_HEIGHT 700

#define GREMSY_PRODUCT_ID 1;   //0: no, 1: gStabi, 2: gMotion

class Configuration : public QObject
{
    Q_OBJECT
public:
    explicit Configuration(QObject *parent = 0);

    Q_INVOKABLE int gremsy_product_id(){
        return GREMSY_PRODUCT_ID;
    }

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
