# Add more folders to ship with the application, here
folder_01.source = qml/gStabiSC
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=
QT       += serialport

INCLUDEPATH += src \
               thirdParty/mavlink/v1.0/gremsyBGC \
               thirdParty/mavlink/v1.0

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    src/configuration.cpp \
    src/SerialLink.cpp \
    src/MavLinkManager.cpp \
    src/gLinkManager.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

include(thirdParty/qextserialport/src/qextserialport.pri)

OTHER_FILES += \
    qml/gStabiSC/Header/AppHeader.qml \
    qml/gStabiSC/Communication/CommSetting.qml \
    qml/gStabiSC/GDashboard/GDashBoard.qml \
    qml/gStabiSC/Console.qml \
    qml/gStabiSC/Components/GButton.qml

HEADERS += \
    src/configuration.h \
    src/SerialLink.h \
    src/MavLinkManager.hpp \
    src/gLinkManager.h

RESOURCES += \
    gStabiSC.qrc

#ICON = resources/icon64.png
#macx: ICON = resources/icon.icns
win32: RC_FILE = resources/appicon.rc
