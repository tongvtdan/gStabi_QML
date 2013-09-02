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
    Q_PROPERTY(bool isConnected READ isConnected WRITE setisConnected NOTIFY isConnectedChanged)
    Q_PROPERTY(bool isPortListUpdated READ isPortListUpdated WRITE setisPortListUpdated NOTIFY isPortListUpdatedChanged)


public:



    explicit SerialLink(QObject *parent = 0);

    QextSerialPort *serialport;
    QextSerialEnumerator *enumerator;

    /**
     * @brief: this function is called from QML to get the portname only
     * @param: idx is the index of port in the ports
     * @note:  the index will be check to make sure it is the range of ports size
    **/
    Q_INVOKABLE QString getPortName(int idx);

    Q_INVOKABLE QString get_selected_port_details(int idx);
    /**
     * @brief: open and close comport, this function can be called from QML
     * @return: bool port status, true if port is opened, false if port is close
     **/
    Q_INVOKABLE void open_close_comport();
    /**
      *@brief: update port setting if there is any change in setting
      **/
    Q_INVOKABLE void update_comport_settings(QString portname_str);

    void fillSerialPortInfo();

    void portSettings();

    /*! Trigger when a device plug or unplug from COM/USB port*/
    void updatePortStatus(bool connection_state);

    //[!] Q_PROPERTY
    bool isConnected()const ;
    void setisConnected(bool state);

    bool isPortListUpdated() const;
    void setisPortListUpdated(bool update_state);


    //[!]

public slots:
    QString getSerialPortMsg();
    void portPrepareToClose();

    // send a message from mavlink to comport
    void send_message_to_comport(const char *_buf, unsigned int _len);


signals:
    void mavlink_data_ready(QByteArray data);
//    [!] Q_PROPERTY
    void isConnectedChanged(bool state);
    void isPortListUpdatedChanged();

//    [!]
private slots:
    void PortAddedRemoved();
private:

//    QList<QString> port_name_list;
    QList<QextPortInfo> serial_port_info;
    PortSettings m_port_settings;
    QString selected_port_name;

//    [!] Q_PROPERTY
    bool m_connection_state;
    bool m_ports_updated;
//    [!]



};

#endif // SERIALLINK_H
