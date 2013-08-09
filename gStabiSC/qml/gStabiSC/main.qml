import QtQuick 2.0

import "Header"

Rectangle {
    width: 1024
    height: 700

    BorderImage {
        id: gstabiBackgroundImage
        anchors.fill: parent
        source: "images/background.png"
    }
    AppHeader{
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        implicitHeight: 30
        implicitWidth: 1024
    }
}
