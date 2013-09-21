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

#include <QtGui/QPixmap>


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
    QtQuick2ApplicationViewer splashscreen;

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

    splashscreen.setSource(QUrl("qrc:/qml/gStabiSC/GSplashScreen.qml"));
    splashscreen.setFlags(Qt::FramelessWindowHint);
    splashscreen.setMinimumSize(QSize(1000,500));
    splashscreen.show();


    viewer.setSource(QUrl("qrc:/qml/gStabiSC/GMain.qml"));
    viewer.setTitle(QString("%1 %2").arg(APPLICATION_NAME).arg(APPLICATION_VERSION));
    viewer.setMinimumSize(QSize(APPLICATION_WIDTH,APPLICATION_HEIGHT));
    viewer.setMaximumSize(QSize(APPLICATION_WIDTH,APPLICATION_HEIGHT));

//    viewer.setMinimumSize(QSize(1000,60));
//    viewer.setMaximumSize(QSize(1000,600));
//    viewer.addImportPath("qrc:/qml/gStabiSC");
//    viewer.addImportPath("qrc:/qml/gStabiSC/Components");
//    viewer.addImportPath("qrc:/qml/gStabiSC/GDashboard");
//    viewer.addImportPath("qrc:/javascript/storage.js");




    viewer.rootContext()->setContextProperty("_configuration",&m_configuration);
    viewer.rootContext()->setContextProperty("_serialLink", &m_serialLink);
    viewer.rootContext()->setContextProperty("_mavlink_manager", &m_mavlink_manager);

    m_gLinkManager.connectLink(&m_serialLink,&m_mavlink_manager);

    QTimer::singleShot(3000, &splashscreen, SLOT(close()));
    QTimer::singleShot(3000, &viewer, SLOT(show()));

//    viewer.showExpanded();

    return app.exec();
}
