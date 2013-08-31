#include "SerialLink.h"
//#include <QtSerialPort/QSerialPortInfo>
//#include <QtSerialPort/QSerialPort>
#include <QStringList>
#include <QDebug>

#include "qextserialport.h"
#include "qextserialenumerator.h"
#include "MavLinkManager.hpp"


SerialLink::SerialLink(QObject *parent) :
    QObject(parent),
    m_connection_state(false)
{
    fillSerialPortInfo();
    portSettings();
    updatePortStatus(false);

    connect(serialport, SIGNAL(readyRead()),this, SLOT(getSerialPortMsg()));
    connect(serialport, SIGNAL(aboutToClose()), this, SLOT(portPrepareToClose()));
    connect(enumerator, SIGNAL(deviceDiscovered(QextPortInfo)), SLOT(PortAddedRemoved()));
    connect(enumerator, SIGNAL(deviceRemoved(QextPortInfo)), SLOT(PortAddedRemoved()));    

}

void SerialLink::PortAddedRemoved()
{
    if(serialport->isOpen()) {serialport->close();}
    updatePortStatus(false);
    fillSerialPortInfo();
}

QString SerialLink::getPortName(int idx)
{
    if(idx < port_name_list.size()){
        return port_name_list.at(idx);
    } else {
        return "NA";
    }
}

void SerialLink::open_close_comport()
{
    if(serialport->isOpen())
    {
        serialport->close();
    }
    else
    {
        serialport->open(QIODevice::ReadWrite);
        //Hardware trigger
        serialport->setRts(1); // 0V output on boot0
        serialport->setDtr(1); // 0v output on reset
        serialport->setDtr(0); // 3V3 output on reset
    }
    updatePortStatus(serialport->isOpen());
}

void SerialLink::update_comport_settings(QString portname_str)
{
    if(serialport->isOpen()){
        serialport->close();
    }
//    qDebug()<< "COM Port selected:" << portname_str;
    selected_port_name = portname_str;
    serialport->setPortName(selected_port_name);
}

void SerialLink::fillSerialPortInfo()
{
    port_name_list.clear();
    // Get the ports available on this system
   QList<QextPortInfo> ports = QextSerialEnumerator::getPorts();
   // Add the ports in reverse order, because we prepend them to the list
   for(int i = ports.size() - 1; i >= 0; i--){
       QextPortInfo portInfo = ports.at(i);
       if(portInfo.portName !=""){
            port_name_list << portInfo.portName;
       }
   }
   selected_port_name = port_name_list.at(0); // get the latest port
//   m_ports_updated = !m_ports_updated;
   setisPortListUpdated(true);
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

void SerialLink::updatePortStatus(bool connection_state)
{
    /*
    if(connection_state)
    {
        qDebug()<< "Port "<< serialport->portName() << " is opened";

    }
    else
    {
         qDebug()<< "Port "<< serialport->portName() << " is closed";
    }
    */
    setisConnected(connection_state);

}

bool SerialLink::isConnected() const
{
    return m_connection_state;
}

void SerialLink::setisConnected(bool state)
{
    m_connection_state = state;
    emit isConnectedChanged(m_connection_state);
}

bool SerialLink::isPortListUpdated() const
{
    return m_ports_updated;
}

void SerialLink::setisPortListUpdated(bool update_state)
{
    m_ports_updated = update_state;
    emit isPortListUpdatedChanged();
}

QString SerialLink::getSerialPortMsg()
{
    QByteArray serial_data = serialport->readAll();
//    qDebug()<< QString::fromUtf8(serial_data.data());
    emit mavlink_data_ready(serial_data);
    return QString::fromUtf8(serial_data.data());
}

void SerialLink::portPrepareToClose()
{
    // do something before SerialPort close
}
