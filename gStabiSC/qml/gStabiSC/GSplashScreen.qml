import QtQuick 2.0
import "Components"

Rectangle {
    id: splashScreenContainer

    // image source is kept as an property alias, so that it can be set from outside
    property alias imageSource: splashImage.source

    // signal emits when splashscreen animation completes
    signal splashScreenCompleted()
    width: 600   ;   height: 500
    BorderImage {
        id: splashImage
//        source: "images/gStabi_splashscreen.png"
        source: "qrc:/images/qml/gStabiSC/images/gStabi_splashscreen.png"
        anchors.fill: splashScreenContainer // do specify the size and position
    }
    GTextStyled {
        id: loading
        text: "Loading..."
        anchors.right: parent.right
        anchors.rightMargin: 10
        font.italic: true
        verticalAlignment: Text.AlignVCenter
        color: "white"
        font.pixelSize: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
    }
    SequentialAnimation {
        id:splashanimation
        PauseAnimation { duration: 3000 }
        PropertyAnimation {
            target: splashScreenContainer;  duration: 1000;  properties: "opacity";  to:0
        }
        onStopped:  {
            splashScreenContainer.splashScreenCompleted()
        }
    }
    //starts the splashScreen
    Component.onCompleted: splashanimation.start()
 }
