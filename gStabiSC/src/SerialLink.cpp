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

    connect(serialport, SIGNAL(readyRead()),this, SLOT(getSerialPortMsg()));
    connect(enumerator, SIGNAL(deviceDiscovered(QextPortInfo)), SLOT(PortAddedRemoved()));
    connect(enumerator, SIGNAL(deviceRemoved(QextPortInfo)), SLOT(PortAddedRemoved()));
}

void SerialLink::PortAddedRemoved()
{
    updatePortStatus(false);
    fillSerialPortInfo();
}

QString SerialLink::getPortName(int idx)
{
    if(idx < port_name_list.size()){
        qDebug()<< port_name_list.at(idx);
        return port_name_list.at(idx);

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
        serialport->setRts(1); // 0V output on boot0
        serialport->setDtr(1); // 0v output on reset
        serialport->setDtr(0); // 3V3 output on reset
    }
    updatePortStatus(serialport->isOpen());
    return serialport->isOpen();

}

void SerialLink::update_comport_settings(QString portname_str)
{
    qDebug()<< "COM Port selected:" << portname_str;
    selected_port_name = portname_str;
    qDebug()<< "Selected Port @Running: " << selected_port_name;
}

void SerialLink::fillSerialPortInfo()
{
    // Get the ports available on this system
   QList<QextPortInfo> ports = QextSerialEnumerator::getPorts();
   // Add the ports in reverse order, because we prepend them to the list
   for(int i = ports.size() - 1; i >= 0; i--){
       QextPortInfo portInfo = ports.at(i);
       if(portInfo.portName !=""){
            port_name_list << portInfo.portName;
       }
   }
   selected_port_name = ports.at(ports.size()-1).portName; // get the latest port
   qDebug()<< "Selected Port @Start: " << selected_port_name;
}


void SerialLink::portSettings()
{
    m_port_settings.BaudRate = BAUD57600;
    m_port_settings.StopBits = STOP_1;
    m_port_settings.DataBits = DATA_8;
    m_port_settings.Parity = PAR_NONE;
    m_port_settings.FlowControl = FLOW_OFF;
    m_port_settings.Timeout_Millisec = 100;

    serialport = new QextSerialPort(selected_port_name, m_port_settings, QextSerialPort::EventDriven);
    enumerator = new QextSerialEnumerator(this);
    enumerator->setUpNotifications();
}

void SerialLink::updatePortStatus(bool isConnected)
{
    if(isConnected)
    {
        qDebug()<< "Port "<< serialport->portName() << " is opened";
    }
    else
    {
         qDebug()<< "Port "<< serialport->portName() << " is closed";
    }
}

QString SerialLink::getSerialPortMsg()
{
    QByteArray serial_data = serialport->readAll();
    qDebug()<< QString::fromUtf8(serial_data.data());
//    qDebug() << "Connect Called";
//    return "Done";
    return QString::fromUtf8(serial_data.data());

}
