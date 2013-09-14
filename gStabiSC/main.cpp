#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"
#include <QQmlEngine>
#include <QString>
#include <QQmlContext> // for setContextProperty
#include <QDir>

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


    Configuration m_configuration;
    SerialLink m_serialLink;
    MavLinkManager m_mavlink_manager;

    LinkManager m_gLinkManager;

    QtQuick2ApplicationViewer viewer;

    QString customPath = "Sqlite/OfflineStorage";
    QDir dir;
    if(dir.mkpath(QString(customPath))){
//        qDebug() << "Default path >> "+viewer.engine()->offlineStoragePath();
        viewer.engine()->setOfflineStoragePath(QString(customPath));
//        qDebug() << "New path >> "+viewer.engine()->offlineStoragePath();
    }
    // using as normal
//    viewer.setMainQmlFile(QStringLiteral("qml/gStabiSC/main.qml"));
    // using qml files form resources file, uncomment this to compile all qml file to .exe
    viewer.setSource(QUrl("qrc:/qml/gStabiSC/main.qml"));
    viewer.addImportPath("qrc:/qml/gStabiSC");
    viewer.addImportPath("qrc:/qml/gStabiSC/Components");
    viewer.addImportPath("qrc:/qml/gStabiSC/GDashboard");
    viewer.addImportPath("qrc:/javascript/storage.js");

    viewer.setTitle(QString("%1 %2").arg(APPLICATION_NAME).arg(APPLICATION_VERSION));
    viewer.setMinimumSize(QSize(APPLICATION_WIDTH,APPLICATION_HEIGHT));
    viewer.setMaximumSize(QSize(APPLICATION_WIDTH,APPLICATION_HEIGHT));

    viewer.rootContext()->setContextProperty("m_configuration",&m_configuration);
    viewer.rootContext()->setContextProperty("_serialLink", &m_serialLink);
    viewer.rootContext()->setContextProperty("_mavlink_manager", &m_mavlink_manager);

    m_gLinkManager.connectLink(&m_serialLink,&m_mavlink_manager);

    viewer.showExpanded();

    return app.exec();
}
