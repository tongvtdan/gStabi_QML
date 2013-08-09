#include "SerialLink.h"
#include <QtSerialPort/QSerialPortInfo>
#include <QStringList>
#include <QDebug>

SerialLink::SerialLink(QObject *parent) :
    QObject(parent)
{
    getPortsInfo();
}


void SerialLink::getPortsInfo()
{
    QList<QSerialPortInfo> list;
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts()) {
        list << info;
    }
//    update port list
    setportList(list);
}


void SerialLink::showPortInfo(int idx)
{
    if(idx != -1){
        // do something here
    }
}


QList<QSerialPortInfo> SerialLink::portList()
{
    return m_list;
}

void SerialLink::setportList(QList<QSerialPortInfo> mList)
{
    m_list = mList;
    emit portListChanged(m_list);

}


QString SerialLink::getPortName(int idx)
{
    if(idx < portList().size()){
//        qDebug() << "Get port Name: " << portList().at(idx).portName();
        return portList().at(idx).portName();

    } else {
        return "NA";
    }

}

bool SerialLink::open_close_comport()
{
    m_serialPort.setPortName(m_settings.name);

    if(!m_serialPort.isOpen()){
        if (m_serialPort.open(QIODevice::ReadWrite)) {
            if (m_serialPort.setBaudRate(m_settings.baudRate)
                    && m_serialPort.setDataBits(m_settings.dataBits)
                    && m_serialPort.setParity(m_settings.parity)
                    && m_serialPort.setStopBits(m_settings.stopBits)
                    && m_serialPort.setFlowControl(m_settings.flowControl)) {
                qDebug() << "Port Opened";
            } else {
                m_serialPort.close();
                qDebug() << "COM Error: " << m_serialPort.errorString();
            }
        } else {
            qDebug() << "COM Error: " << m_serialPort.errorString();
        }
    } else {
        m_serialPort.close();
        qDebug() << "Port Closed";
    }
    return m_serialPort.isOpen();
}

void SerialLink::update_comport_settings(QString portname_str)
{
    m_settings.name = portname_str;
    qDebug()<< "COM Port selected:" << portname_str;
    m_settings.baudRate = QSerialPort::Baud38400;
    m_settings.dataBits = QSerialPort::Data8;
    m_settings.parity = QSerialPort::NoParity;
    m_settings.stopBits = QSerialPort::OneStop;
    m_settings.flowControl = QSerialPort::NoFlowControl;
}
