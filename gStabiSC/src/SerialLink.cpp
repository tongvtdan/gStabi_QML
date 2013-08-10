#include "SerialLink.h"
//#include <QtSerialPort/QSerialPortInfo>
//#include <QtSerialPort/QSerialPort>
#include <QStringList>
#include <QDebug>

#include "qextserialport.h"
#include "qextserialenumerator.h"


SerialLink::SerialLink(QObject *parent) :
    QObject(parent)
{
    fillSerialPortInfo();
    portSettings();
    connect(enumerator, SIGNAL(deviceDiscovered(QextPortInfo)), SLOT(PortAddedRemoved()));
    connect(enumerator, SIGNAL(deviceRemoved(QextPortInfo)), SLOT(PortAddedRemoved()));
    connect(serialport, SIGNAL(readyRead()),this, SLOT(getSerialPortMsg()));
}

void SerialLink::PortAddedRemoved()
{
    updatePortStatus(false);
    fillSerialPortInfo();
}

QString SerialLink::getPortName(int idx)
{
    if(idx < portNameList.size()){
        qDebug()<< portNameList.at(idx);
        return portNameList.at(idx);

    } else {
        return "NA";
    }
}

bool SerialLink::open_close_comport()
{
    if(serialport->isOpen())
    {
        serialport->close();
    }
    else
    {
        serialport->open(QIODevice::ReadWrite);
//        serialport->setRts(1); // 0V output on boot0
//        serialport->setDtr(1); // 0v output on reset
//        serialport->setDtr(0); // 3V3 output on reset
    }
    updatePortStatus(serialport->isOpen());
    return serialport->isOpen();

}

void SerialLink::update_comport_settings(QString portname_str)
{
//    m_settings.name = portname_str;
    qDebug()<< "COM Port selected:" << portname_str;
//    m_settings.baudRate = QSerialPort::Baud38400;
//    m_settings.dataBits = QSerialPort::Data8;
//    m_settings.parity = QSerialPort::NoParity;
//    m_settings.stopBits = QSerialPort::OneStop;
//    m_settings.flowControl = QSerialPort::NoFlowControl;
}

void SerialLink::fillSerialPortInfo()
{
    // Get the ports available on this system
   QList<QextPortInfo> ports = QextSerialEnumerator::getPorts();
   // Add the ports in reverse order, because we prepend them to the list
   for(int i = ports.size() - 1; i >= 0; i--){
       QextPortInfo portInfo = ports.at(i);
       if(portInfo.portName !=""){
            portNameList << portInfo.portName;
       }
   }
}


void SerialLink::portSettings()
{
    PortSettings settings = {BAUD57600, DATA_8, PAR_NONE, STOP_1, FLOW_OFF, 100};
    serialport = new QextSerialPort("COM5", settings, QextSerialPort::EventDriven);
    enumerator = new QextSerialEnumerator(this);
    enumerator->setUpNotifications();
}

void SerialLink::updatePortStatus(bool isConnected)
{
    if(isConnected)
    {
        qDebug(("Port Opened"));
    }
    else
    {
        qDebug("Port Closed");
    }
}

QString SerialLink::getSerialPortMsg()
{
//    QByteArray serial_data = serialport->readAll();
//    qDebug()<< QString::fromUtf8(serial_data.data());
    qDebug() << "Connect Called";
    return "Done";
//    return QString::fromUtf8(serial_data.data());

}
