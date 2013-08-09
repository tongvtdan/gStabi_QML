#include <QtGui/QGuiApplication>
#include "qtquick2applicationviewer.h"

#define APPLICATION_NAME "gStabi"
#define APPLICATION_VERSION "V.1.0.1(beta rc1)"
#define WIDTH 1024
#define HEIGHT 700

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QtQuick2ApplicationViewer viewer;
    viewer.setMainQmlFile(QStringLiteral("qml/gStabiSC/main.qml"));

    viewer.setTitle(QString("%1 %2").arg(APPLICATION_NAME).arg(APPLICATION_VERSION));
    viewer.setMinimumSize(QSize(WIDTH,HEIGHT));
    viewer.setMaximumSize(QSize(WIDTH,HEIGHT));
//    viewer.setFlags(Qt::FramelessWindowHint); // no boarder and no icon on StaskBar
    viewer.showNormal();

    return app.exec();
}
