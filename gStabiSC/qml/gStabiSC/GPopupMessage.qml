import QtQuick 2.0
import "Components"
Rectangle{
    id: root
    width: 300; height: messageTextContainer.height + 50
    color: "#c8000000"
    radius: 5
    border.width: 1
    border.color: "#04d6f1"
    MouseArea{
        anchors.fill: parent
        id: dragConsolWindowArea
//        width: parent.width ; height: 30
//        anchors.top: parent.top;  anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent

    }
    GButton{
        y: 10
        text: "OK"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom;        anchors.bottomMargin: 5
        onClicked: popup_show = false
    }

    Rectangle{
        id: messageTextContainer
        width: 280; height: messageText.contentHeight + 20
        radius: 5
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "#00aaff"; border.width: 1
        anchors.top: parent.top; anchors.topMargin: 10
        Text{
            id: messageText
            wrapMode: Text.WordWrap
            color: "white"
//            color: "#21fb04"
            textFormat: Text.PlainText
            text: popup_msg
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.fill: parent
        }

    }
    states:[
           State{
               name: "showDialog"
               when: popup_show
               PropertyChanges { target: root; opacity: 1; scale: 1; z: 100 }
           }
           ,State {
               name: "hideDialog"
               when: !popup_show
               PropertyChanges {target: root; opacity: 0; scale: 0.5; z: -100}
           }

       ]
       transitions: [
           Transition {
               from: "showDialog" ; to:   "hideDialog"
               ParallelAnimation{
                   NumberAnimation { target: root; property: "opacity";  duration: 500; }
                   NumberAnimation { target: root; property: "scale"; duration: 500; easing.type: Easing.Bezier}
               }
           }
           ,Transition {
               from: "hideDialog" ; to: "showDialog"
               ParallelAnimation{
                   NumberAnimation { target: root; property: "opacity"; duration: 500; }
                   NumberAnimation { target: root; property: "scale"; duration: 500; easing.type: Easing.Bezier}
               }

           }
       ]
}

