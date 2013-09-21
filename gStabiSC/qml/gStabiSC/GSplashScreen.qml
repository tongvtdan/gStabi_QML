import QtQuick 2.0
import "Components"

Rectangle {
    id: splashScreenContainer

    // image source is kept as an property alias, so that it can be set from outside
    property alias imageSource: splashImage.source

    // signal emits when splashscreen animation completes
    signal splashScreenCompleted()
    width: 1000 ;   height: 400
    BorderImage {
        id: splashImage
//        fillMode: Image.PreserveAspectFit
//        source: "images/Logo_Slogan_Gremsy.png"
        source: "qrc:/images/qml/gStabiSC/images/Logo_Slogan_Gremsy.png"
        anchors.fill: splashScreenContainer // do specify the size and position
    }

    // simple QML animation to give a good user experience
    SequentialAnimation {
        id:splashanimation
        PauseAnimation { duration: 1000 }
        PropertyAnimation {
            target: splashImage
            duration: 2000
            properties: "opacity"
            to:0
        }
        onStopped:  {
            splashScreenContainer.splashScreenCompleted()
        }
    }

    GTextStyled {
        id: gStabi
        text: "gStabi"
        color: "green"
        anchors.horizontalCenterOffset: 158
        font.pixelSize: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter
    }
    //starts the splashScreen
    Component.onCompleted: splashanimation.start()
 }
