#include "SerialLink.h"
#include <QStringList>
#include <QDebug>

#include "qextserialport.h"
#include "qextserialenumerator.h"
#include "MavLinkManager.hpp"


SerialLink::SerialLink(QObject *parent) :
    QObject(parent),
    m_connection_state(false),
    m_check_gstabi_product(true)
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

    fillSerialPortInfo();
    updatePortStatus(false);
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
        serialport->setRts(0); // 0V output on boot0
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
//    QextPortInfo portInfo ;
    QString gremsy_virtual_portname;
    serial_port_info = QextSerialEnumerator::getPorts();
//   // Add the ports in reverse order, because we prepend them to the list
   for(int i = serial_port_info.size() - 1; i >= 0; i--){
       QextPortInfo portInfo = serial_port_info.at(i);
       QString serialport_name;
       int m_productID;
       serialport_name = portInfo.portName;
       if(m_check_gstabi_product){
           m_productID = portInfo.productID;
           if(m_productID != 0x88FC){   // 0x88FC, Gremsy gStabi Product ID
               serial_port_info.removeAt(i);    // remove all dummy serial ports
           }
       }
       else{
           if(serialport_name == ""){
               serial_port_info.removeAt(i);    // remove all dummy serial ports
           }
       }
   }
   if(serial_port_info.size() > 0){
        selected_port_name = serial_port_info.at(0).portName; // get the latest port
   }
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
    setisPortListUpdated(connection_state);
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
