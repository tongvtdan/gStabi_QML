#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <QObject>

#define APPLICATION_NAME "gStabi"
#define APPLICATION_VERSION "V.1.0.1(beta rc1)"
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



signals:
    
public slots:
    
};

#endif // CONFIGURATION_H
