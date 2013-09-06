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
               thirdParty/mavlink/v1.0 \
               thirdParty/mavlink

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    src/configuration.cpp \
    src/SerialLink.cpp \
    src/MavLinkManager.cpp \
    src/gLinkManager.cpp \
    src/pieslice.cpp \
    src/piechart.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

include(thirdParty/qextserialport/src/qextserialport.pri)


HEADERS += \
    src/configuration.h \
    src/SerialLink.h \
    src/MavLinkManager.hpp \
    src/gLinkManager.h \
    src/pieslice.h \
    src/piechart.h \
    thirdParty/mavlink/config.h

RESOURCES += \
    gStabiSC.qrc

#ICON = resources/icon64.png
#macx: ICON = resources/icon.icns
win32: RC_FILE = resources/appicon.rc

OTHER_FILES += \
    qml/gStabiSC/Components/GButton.qml                 \
    qml/gStabiSC/Components/GDialog.qml                 \
    qml/gStabiSC/Components/GGauge.qml                  \
    qml/gStabiSC/Components/GImageButton.qml            \
    qml/gStabiSC/Components/GParametersContainer.qml    \
    qml/gStabiSC/Components/GSettingDialog.qml          \
    qml/gStabiSC/Components/GSlider.qml                 \
    qml/gStabiSC/Components/GTextInput.qml              \
    qml/gStabiSC/GDashboard/GMotorConfig.qml            \
    qml/gStabiSC/GAppHeader.qml \
    qml/gStabiSC/GConsole.qml   \
    qml/gStabiSC/GPIDDialog.qml \
    qml/gStabiSC/GSerialSettings.qml \
    qml/gStabiSC/GDashboard/GDashBoard.qml \
    qml/gStabiSC/Components/GSerialPortListHeader.qml \
    qml/gStabiSC/Components/GProfile.qml \
    javascript/storage.js \
    qml/gStabiSC/Components/GListView.qml \
    qml/gStabiSC/Components/GCheckBox.qml \
    qml/gStabiSC/Components/TextStyled.qml
