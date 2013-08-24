import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item{
    id: consoleLog
    property string msg_history: "Init done \n"         // all other QML file will refer to this variable to display message in conole
    property int anchor_topMargin   : 10
    property int anchor_bottomMargin: 10
    property int anchor_leftMargin  : 10
    property int anchor_rightMargin : 10
    property int  dragMaxX          : 500
    property int dragMaxY           : 500
    implicitHeight: 200
    implicitWidth: 300
    BorderImage {
        id: background
        x: 0
        y: 2
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_serial_setting_dialog.png"
        width: 300; height: 200
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    Text {
        font.family: "Ubuntu"
        font.bold: true
        color: "cyan"
        text: "Console"
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
    }
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

    states:[
        State {
            name: "show"
            PropertyChanges {target: consoleLog; scale: 1.0; opacity: 1; }

        }
        ,State {
            name: "hide"
            PropertyChanges {target: consoleLog; scale: 0.5 ; opacity: 0.5; }
        }

    ]
    transitions: [ Transition {
            from: "show"
            to:   "hide"
            NumberAnimation{ target: consoleLog; properties: "scale"; from: 1.0; to: 0.5; duration: 500}
            NumberAnimation { target: consoleLog; property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition{
            from: "hide"
            to: "show"
            NumberAnimation { target: consoleLog; properties: "scale" ; from: 0.5; to: 1.0; duration: 500}
            NumberAnimation { target: consoleLog; property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
        }
    ]
    MouseArea{
        id: dragConsolWindowArea
        width: parent.width
        height: 30
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        drag.minimumX: 0
        drag.minimumY: 0
        drag.maximumX: dragMaxX
        drag.maximumY: dragMaxY

        onDoubleClicked: consoleLog.state == "hide"? consoleLog.state = "show" : consoleLog.state = "hide"


    }


}
