import QtQuick 2.0
import "Components"

Rectangle{
    id: consoleDialog
    property string msg_history: ""
    width: 220; height: 250
    color: "transparent"
    radius: 5
    border.color: "cyan"; border.width: 1
    Flickable{
        id: flickArea
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottom: parent.bottom ;    anchors.bottomMargin: 5
        anchors.left: parent.left ;  anchors.leftMargin: 5
        contentWidth: Math.max(parent.width,logText.paintedWidth)
        contentHeight: Math.max(parent.height,logText.paintedHeight+10)
        flickableDirection: Flickable.VerticalFlick
        pressDelay: 300
        clip: true
        Text{
            id: logText
            width: 220
            height: 370
            wrapMode: Text.WordWrap
            color: "cyan"
            textFormat: Text.PlainText
            text: msg_history
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
            anchors.fill: parent
        }
    }

}

