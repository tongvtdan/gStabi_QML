#ifndef SERIALLINK_H
#define SERIALLINK_H

#include <QObject>
#include <QStringList>
//#include <QSerialPort>
//#include <QSerialPortInfo>

#include "qextserialport.h"
#include "qextserialenumerator.h"


class SerialLink : public QObject
{
    Q_OBJECT
//    Q_PROPERTY(QList<QextPortInfo> portList READ portList WRITE setportList NOTIFY portListChanged)



public:



    explicit SerialLink(QObject *parent = 0);

    QextSerialPort *serialport;
    QextSerialEnumerator *enumerator;

    /**
     * @brief: this function is called from QML to get the portname only
     * @param: idx is the index of port in the portlist
     * @note:  the index will be check to make sure it is the range of portlist size
    **/
    Q_INVOKABLE QString getPortName(int idx);
    /**
     * @brief: open and close comport, this function can be called from QML
     * @return: bool port status, true if port is opened, false if port is close
     **/
    Q_INVOKABLE bool open_close_comport();
    /**
      *@brief: update port setting if there is any change in setting
      **/
    Q_INVOKABLE void update_comport_settings(QString portname_str);

    void fillSerialPortInfo();

    void portSettings();

    /*! Trigger when a device plug or unplug from COM/USB port*/
    void updatePortStatus(bool isConnected);

public slots:
    QString getSerialPortMsg();


private slots:
    void PortAddedRemoved();
private:

    QList<QString> port_name_list;
    PortSettings m_port_settings;
    QString selected_port_name;



};

#endif // SERIALLINK_H
