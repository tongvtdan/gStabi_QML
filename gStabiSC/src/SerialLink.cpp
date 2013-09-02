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
    if(idx < serial_port_info.size()){
        return serial_port_info.at(idx).portName;
    }
    else {return "NA";}
}
/**
 * @brief SerialLink::get_selected_port_details
 * @param idx
 * @return
 *  QString portName;   ///< Port name.
    QString physName;   ///< Physical name.
    QString friendName; ///< Friendly name.
    QString enumName;   ///< Enumerator name.
    int vendorID;       ///< Vendor ID.
    int productID;      ///< Product ID
 */
QString SerialLink::get_selected_port_details(int idx)
{
    QString m_details;
    if(idx < serial_port_info.size()){
        m_details = QString("Port name: %1 \nPhysical name: %2 \nFriendly name: %3 \nEnumerator name: %4\nVender ID: %5 \nProduct ID: %6").arg(serial_port_info.at(idx).portName).arg(serial_port_info.at(idx).physName).arg(serial_port_info.at(idx).friendName).arg(serial_port_info.at(idx).enumName).arg(serial_port_info.at(idx).vendorID).arg(serial_port_info.at(idx).productID);
        return m_details;
    }
    else {return "NA";}
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
    selected_port_name = portname_str;
    serialport->setPortName(selected_port_name);
}

void SerialLink::fillSerialPortInfo()
{

//    port_name_list.clear();
    serial_port_info = QextSerialEnumerator::getPorts();
//    // Get the ports available on this system
//   QList<QextPortInfo> ports = QextSerialEnumerator::getPorts();
//   // Add the ports in reverse order, because we prepend them to the list
   for(int i = serial_port_info.size() - 1; i >= 0; i--){
       QextPortInfo portInfo = serial_port_info.at(i);
       if(portInfo.portName == ""){
           serial_port_info.removeAt(i);    // remove all dummy serial ports
       }
   }
   selected_port_name = serial_port_info.at(0).portName; // get the latest port
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
    serialport->flush();
    emit mavlink_data_ready(serial_data);
    return QString::fromUtf8(serial_data.data());
}

void SerialLink::portPrepareToClose()
{
    // do something before SerialPort close
}

void SerialLink::send_message_to_comport(const char *_buf, unsigned int _len)
{
    if(serialport->isOpen()){
        serialport->write(_buf, _len);
    }
    else {
        qDebug("Please check the connection then open the Comport");
    }
}
