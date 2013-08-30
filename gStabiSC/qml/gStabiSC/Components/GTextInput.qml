import QtQuick 2.0

Rectangle{
    id: container
    property string text_value      : "10"
    property int    bottom_value    : 0
    property int    top_value       : 100
    property bool   read_only       : false
    signal clicked
    width: 45; height: 20;
    implicitWidth: 45; implicitHeight: 20
    border.width: 1; border.color: "cyan"
    color: "#00000000";  smooth: true;
    radius: 0.7*height/2
    MouseArea{
        id: mouseArea
        anchors.fill: parent; hoverEnabled: true
        onClicked: container.clicked();
        onEntered: container.state = "focus"
        onExited:  container.state = "unfocus"
    }
    TextInput {
        id: inputText
        anchors.centerIn: parent
        color : "#00e3f9"
        font{ family: "Segoe UI"; bold: true; pixelSize: 16}
        validator: IntValidator{bottom: bottom_value; top: top_value;}
        focus: true
        text: text_value
        readOnly: read_only
        Behavior on color {ColorAnimation {duration: 200 }}
        Keys.onPressed: {
            if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
                text_value = text
                event.accepted = true;
            }
        }
    }

    states: [
        State{
            name: "focus"
            PropertyChanges {target: container; border.color: "#009dff"; border.width: 2}
            PropertyChanges { target: inputText; color: "red"   }
        }
        ,State {
            name: "unfocus"
            PropertyChanges {target: container; border.color: "cyan"; border.width: 1 }
            PropertyChanges { target: inputText; color: "#00e3f9"   }

        }

    ]
    Behavior on color {ColorAnimation {duration: 200 }}
} // end of container

