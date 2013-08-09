#ifndef SERIALLINK_H
#define SERIALLINK_H

#include <QObject>
#include <QStringList>
#include <QSerialPort>
#include <QSerialPortInfo>

class SerialLink : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QSerialPortInfo> portList READ portList WRITE setportList NOTIFY portListChanged)


public:

    struct Settings {
        QString name;
        QSerialPort::BaudRate baudRate;
//        QString stringBaudRate;
        QSerialPort::DataBits dataBits;
//        QString stringDataBits;
        QSerialPort::Parity parity;
//        QString stringParity;
        QSerialPort::StopBits stopBits;
//        QString stringStopBits;
        QSerialPort::FlowControl flowControl;
//        QString stringFlowControl;
        bool localEchoEnabled;
    };

    explicit SerialLink(QObject *parent = 0);

    QList<QSerialPortInfo> ports;
    QSerialPortInfo portInfo;

    QList<QSerialPortInfo> portList();
    void setportList(QList<QSerialPortInfo> mList);

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

signals:
    void portListChanged(QList<QSerialPortInfo>);
public slots:

private slots:
    void showPortInfo(int idx);

private:
    void getPortsInfo();

    QList<QSerialPortInfo> m_list;
    QSerialPort m_serialPort;

    Settings m_settings;



};

#endif // SERIALLINK_H
