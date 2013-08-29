import QtQuick 2.0
import "Components"

GDialog{
    id: consoleDialog
    title: "Console"
    state: "focus"
    Flickable{
        id: flickArea
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: 280
        height: 150
        contentWidth: Math.max(parent.width,logText.paintedWidth)
        contentHeight: Math.max(parent.height,logText.paintedHeight+10)
        flickableDirection: Flickable.VerticalFlick
        pressDelay: 300
        clip: true
        Text{
            id: logText
            width: 280
            height: 150
            wrapMode: Text.WordWrap
            anchors.fill: parent
            color: "cyan"
            textFormat: Text.RichText
            text: msg_history
        }
    }
}

