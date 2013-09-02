import QtQuick 2.0
import "Components"

GDialog{
    id: consoleDialog
    title: "Console"
    state: "focus"
    border_normal: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_console_border.png"
    width: 250; height: 400
    Flickable{
        id: flickArea
        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.fill: parent
//        width: 280;     height: 150
        anchors.left: parent.left
        anchors.leftMargin: 20
        contentWidth: Math.max(parent.width,logText.paintedWidth)
        contentHeight: Math.max(parent.height,logText.paintedHeight+10)
        flickableDirection: Flickable.VerticalFlick
        pressDelay: 300
        clip: true
        Text{
            id: logText
            wrapMode: Text.WordWrap
            color: "cyan"
            textFormat: Text.RichText
            text: msg_history
            anchors.fill: parent
        }
    }

}

