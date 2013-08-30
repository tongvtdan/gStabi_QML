#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"




#include <QQmlContext> // for setContextProperty

#include "configuration.h"
#include "SerialLink.h"
#include "MavLinkManager.hpp"
#include "gLinkManager.h"

#include "piechart.h"
#include "pieslice.h"


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<PieChart>("Charts", 1, 0, "PieChart");
    qmlRegisterType<PieSlice>("Charts", 1, 0, "PieSlice");

    QtQuick2ApplicationViewer viewer;
//    QQuickView viewer;
    // using as normal
//    viewer.setMainQmlFile(QStringLiteral("qml/gStabiSC/main.qml"));

    // using qml files form resources file, uncomment this to compile all qml file to .exe
    viewer.setSource(QUrl("qrc:/qml/gStabiSC/main.qml"));
    viewer.addImportPath("qrc:/qml/gStabiSC");
    viewer.addImportPath("qrc:/qml/gStabiSC/Components");
    viewer.addImportPath("qrc:/qml/gStabiSC/GDashboard");

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

    viewer.show();

    return app.exec();
}
