import QtQuick 2.0

Rectangle{
    id: button
    property string  text   : "Button"
    signal clicked
    width: buttonLabel.width+20; height: buttonLabel.height + 5;
    border.width: 1; border.color: "cyan"
    color: "#00000000"
    smooth: true;

    Text{
        id: buttonLabel
        anchors.centerIn: parent
        color : "#00e3f9"
        font.family: "Segoe UI"
        font.bold: true
        font.pixelSize: 16
        text: button.text
        Behavior on color { ColorAnimation { duration: 200 }}

    }
    MouseArea{
        id: mouseArea
        anchors.fill: parent; hoverEnabled: true
        onClicked: button.clicked();
        onEntered: { button.state = "pressed"   }
        onExited: { button.state = "released"   }
        onPressed: button.state = "pressed"
        onReleased:  button.state = "released"
    }
    Behavior on color {ColorAnimation {duration: 200 }}
    states: [
        State{
            name: "pressed"
            PropertyChanges {target: button; border.color: "#009dff"; border.width: 2}
            PropertyChanges { target: buttonLabel; color: "red"   }
        }
        ,State {
            name: "released"
            PropertyChanges {target: button; border.color: "cyan"; border.width: 1 }
            PropertyChanges { target: buttonLabel; color: "#00e3f9"   }
        }
    ]
} // end of button
