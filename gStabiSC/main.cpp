#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#include <QQmlContext> // for setContextProperty


#include "configuration.h"
#include "SerialLink.h"
#include "MavLinkManager.hpp"
#include "gLinkManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/gStabiSC/main.qml"));

    viewer.setTitle(QString("%1 %2").arg(APPLICATION_NAME).arg(APPLICATION_VERSION));
    viewer.setMinimumSize(QSize(APPLICATION_WIDTH,APPLICATION_HEIGHT));
    viewer.setMaximumSize(QSize(APPLICATION_WIDTH,APPLICATION_HEIGHT));
//    viewer.setFlags(Qt::FramelessWindowHint); // no boarder and no icon on StaskBar

    Configuration m_configuration;
    viewer.rootContext()->setContextProperty("m_configuration",&m_configuration);
    SerialLink m_serialLink;
    viewer.rootContext()->setContextProperty("_serialLink", &m_serialLink);
    MavLinkManager m_mavlink_manager;
    viewer.rootContext()->setContextProperty("_mavlink_manager", &m_mavlink_manager);

    LinkManager m_gLinkManager;
    m_gLinkManager.connectLink(&m_serialLink,&m_mavlink_manager);

    viewer.showExpanded();

    return app.exec();
}
