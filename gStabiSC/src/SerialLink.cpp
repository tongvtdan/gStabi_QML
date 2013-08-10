#include "SerialLink.h"
#include <QtSerialPort/QSerialPortInfo>
#include <QtSerialPort/QSerialPort>
#include <QStringList>
#include <QDebug>

#include "qextserialport.h"
#include "qextserialenumerator.h"


SerialLink::SerialLink(QObject *parent) :
    QObject(parent)
{
    m_serialPort = new QSerialPort(this);
    connect(m_serialPort, SIGNAL(readyRead()), this, SLOT(getSerialPortMsg()));
    getPortsInfo();

//    fillSerialPortInfo();
//    portSettings();
//    connect(enumerator, SIGNAL(deviceDiscovered(QextPortInfo)), SLOT(PortAddedRemoved()));
//    connect(enumerator, SIGNAL(deviceRemoved(QextPortInfo)), SLOT(PortAddedRemoved()));
//    connect(serialport, SIGNAL(readyRead()),this, SLOT(getSerialPortMsg()));

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

void SerialLink::PortAddedRemoved()
{
    updatePortStatus(false);
//    watchdogTimer->stop();
//    chartTimer->stop();
//    ui->BoardConnectionStatusLabel->hide();

//    ui->portListBox->blockSignals(true);
//    ui->portListBox->clear();
    fillSerialPortInfo();
//    ui->portListBox->setCurrentIndex(0);
//    ui->portListBox->blockSignals(false);
    // update portname
//    serialport->setPortName(ui->portListBox->currentText());
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
//    if(serialport->isOpen())
//    {
//        serialport->close();
//    }
//    else
//    {
//        serialport->open(QIODevice::ReadWrite);
//        serialport->setRts(1); // 0V output on boot0
//        serialport->setDtr(1); // 0v output on reset
//        serialport->setDtr(0); // 3V3 output on reset
//    }
//    updatePortStatus(serialport->isOpen());
//    return serialport->isOpen();

    m_serialPort->setPortName(m_settings.name);

    if(!m_serialPort->isOpen()){
        if (m_serialPort->open(QIODevice::ReadWrite)) {
            if (m_serialPort->setBaudRate(m_settings.baudRate)
                    && m_serialPort->setDataBits(m_settings.dataBits)
                    && m_serialPort->setParity(m_settings.parity)
                    && m_serialPort->setStopBits(m_settings.stopBits)
                    && m_serialPort->setFlowControl(m_settings.flowControl)) {
                qDebug() << "Port Opened";
            } else {
                m_serialPort->close();
                qDebug() << "COM Error: " << m_serialPort->errorString();
            }
        } else {
            qDebug() << "COM Error: " << m_serialPort->errorString();
        }
    } else {
        m_serialPort->close();
        qDebug() << "Port Closed";
    }
    return m_serialPort->isOpen();
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

void SerialLink::fillSerialPortInfo()
{
    // Get the ports available on this system
   QList<QextPortInfo> ports = QextSerialEnumerator::getPorts();
   // Add the ports in reverse order, because we prepend them to the list
   for(int i = ports.size() - 1; i >= 0; i--){
       QextPortInfo portInfo = ports.at(i);
       Q_UNUSED(portInfo);
   }
}

void SerialLink::openSerialPort()
{
    if(serialport->isOpen())
    {
        serialport->close();
//        watchdogTimer->stop();
//        chartTimer->stop();
//        ui->BoardConnectionStatusLabel->hide();
    }
    else
    {
        serialport->open(QIODevice::ReadWrite);
//        watchdogTimer->start();
//        ui->BoardConnectionStatusLabel->show();

        serialport->setRts(1); // 0V output on boot0
        serialport->setDtr(1); // 0v output on reset
        serialport->setDtr(0); // 3V3 output on reset
    }
    updatePortStatus(serialport->isOpen());

}

void SerialLink::portSettings()
{
    PortSettings settings = {BAUD57600, DATA_8, PAR_NONE, STOP_1, FLOW_OFF, 100};
//    QString t_portName = ui->portListBox->currentText();
    serialport = new QextSerialPort("COM5", settings, QextSerialPort::EventDriven);
    enumerator = new QextSerialEnumerator(this);
    enumerator->setUpNotifications();
}

void SerialLink::updatePortStatus(bool isConnected)
{
    if(isConnected)
    {
//        ui->SerialPortConnectButton->setText("Disconnect");
        qDebug(("Port Opened"));
//        m_statusLabel->setText(QString("%1: 57600, N, 8, 1 - Connected").arg(serialport->portName()));
    }
    else
    {
//        ui->SerialPortConnectButton->setText("Connect");
        qDebug("Port Closed");
//        ui->hearbeatPulseLabel->setPixmap(QPixmap::fromImage(imageOff));
//        m_statusLabel->setText(QString("%1: 57600, N, 8, 1 - Disconnected").arg(serialport->portName()));
    }
}

QString SerialLink::getSerialPortMsg()
{
//    QByteArray serial_data = m_serialPort->readAll();
//    qDebug()<< QString::fromUtf8(serial_data.data());
    qDebug() << "Connect Called";
    return "NA" ;// QString::fromUtf8(serial_data.data());

}
