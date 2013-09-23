import QtQuick 2.0

Rectangle{
    id: root
    width: messageTextContainer.width + 50; height: 120;
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
        id: udidLabel
        text: "Your UDID Number"
        color: "cyan"
        anchors.top: parent.top
        anchors.topMargin: 10
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 14

    }
    Rectangle{
        id: messageTextContainer
        width:udidValueText.contentWidth+20; height: udidValueText.contentHeight + 10; radius: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: udidLabel.bottom
        anchors.topMargin: 10
        color: "transparent"
        border.color: "cyan"; border.width: 1
        GTextStyled {
            id: udidValueText
            color : "cyan"
            anchors.fill: parent
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            horizontalAlignment: TextInput.AlignHCenter
            text: "  -  -  -  -  -  "
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 16
        }
    }
    GButton{
        id: okButton
        width: 50;     height: 25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: "OK"
        onClicked: {
            root.state = "hideDialog"
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
    Connections{
        target: _mavlink_manager
        onUdid_valuesChanged: udidValueText.text = _mavlink_manager.udid_values;
    }
}


