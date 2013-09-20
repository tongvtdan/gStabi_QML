import QtQuick 2.0

Item {
    id: splashScreenContainer

    // image source is kept as an property alias, so that it can be set from outside
    property alias imageSource: splashImage.source

    // signal emits when splashscreen animation completes
    signal splashScreenCompleted()
    width: 1000
    height: 600
    Image {
        id: splashImage
        fillMode: Image.PreserveAspectFit
//        source: "images/Logo_Slogan_Gremsy.png"
        source: imageSource
        anchors.fill: splashScreenContainer // do specify the size and position
    }

    // simple QML animation to give a good user experience
    SequentialAnimation {
        id:splashanimation
        PauseAnimation { duration: 3000 }
        PropertyAnimation {
            target: splashImage
            duration: 1000
            properties: "opacity"
            to:0
        }
        onStopped:  {
            splashScreenContainer.splashScreenCompleted()
        }
    }
    //starts the splashScreen
    Component.onCompleted: splashanimation.start()
 }
