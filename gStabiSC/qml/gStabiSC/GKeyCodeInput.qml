import QtQuick 2.0
import "Components"

Rectangle{
    id: root
    width: 300; height: 120;
    color: "#e1000000"
    radius: 5
    border.width: 1
    border.color: "#04d6f1"

    property int key_code: 0

    MouseArea{
        id: dragConsolWindowArea
        anchors.fill: parent

    }
    GTextStyled{
        id: inputKeyCodeLabel
        text: "Enter your keycode"
        color: "cyan"
        anchors.top: parent.top
        anchors.topMargin: 10
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 14

    }
    FocusScope{
        id: scope
        property alias color: messageTextContainer.color
        x: messageTextContainer.x;        width: messageTextContainer.width; height: messageTextContainer.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: inputKeyCodeLabel.bottom
        anchors.topMargin: 10
        Rectangle{
            id: messageTextContainer
            width: 150; height: 30;        radius: 5
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter
            border.color: "cyan"; border.width: 1
            anchors.top: inputKeyCodeLabel.bottom; anchors.topMargin: 10
            MouseArea{
                anchors.fill: parent
                onClicked: inputText.forceActiveFocus()
            }

            TextInput {
                id: inputText
                color : "cyan"
                font{ family: "Segoe UI"; bold: true; pixelSize: 14}
                validator: IntValidator{bottom: 0; }
                focus: true
                anchors.bottomMargin: 5
                anchors.topMargin: 5
                cursorVisible: true
                echoMode: TextInput.Normal
                horizontalAlignment: TextInput.AlignHCenter
                anchors.fill: parent
                onTextChanged: {
                    messageTextContainer.border.color = "blue"
                    inputText.color = "red"
                }
                Keys.onPressed: {
                    if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
                        key_code = text
                        event.accepted = true;
                        messageTextContainer.border.color = "cyan"
                        inputText.color = "cyan"
                    }
                }
            }
        }
    }
    Row{
        id: buttonRow
        width: 170
        height: 27
        spacing: 15
        anchors.horizontalCenter: scope.horizontalCenter
        anchors.top: scope.bottom
        anchors.topMargin: 10
        GButton{
            id: activateButton
            height: 25
            text: "Activate"
//            anchors.top: messageTextContainer.bottom
//            anchors.topMargin: 10
//            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                key_code = inputText.text
                _mavlink_manager.send_keycode(key_code)

                root.state = "hideDialog";
            }
        }
        GButton{
            id: cancelButton
            height: 25
            text: "Cancel"
            onClicked: {
                root.state = "hideDialog"
            }
        }
    }
    states:[
           State{
               name: "showDialog"
               PropertyChanges { target: root; opacity: 1; scale: 1; z: 100 }
           }
           ,State {
               name: "hideDialog"
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

