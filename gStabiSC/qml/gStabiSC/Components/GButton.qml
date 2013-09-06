import QtQuick 2.0

Rectangle{
    id: button
    property string  text   : "Button"
    property bool hover_enabled: true
    signal clicked
    width: buttonLabel.width+20; height: buttonLabel.height + 5;
    border.width: 1; border.color: "cyan"
    color: "#00000000"
    smooth: true;

    TextStyled{
        id: buttonLabel
        anchors.centerIn: parent
        color : "#00e3f9"
        font.pixelSize: 16
        text: button.text
        Behavior on color { ColorAnimation { duration: 200 }}

    }
    MouseArea{
        id: mouseArea
        anchors.fill: parent; hoverEnabled: hover_enabled
        onClicked: button.clicked();
        onPressed: button.state = "pressed"
        onReleased:  button.state = "released"
        onEntered: button.state = "hover"
        onExited: button.state = "exit"
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
        ,State{
            name: "hover"
            PropertyChanges {target: button; border.color: "white"; border.width: 1}
            PropertyChanges { target: buttonLabel; color: "chartreuse"   }
        }
        ,State{
            name: "exit"
            PropertyChanges {target: button; border.color: "cyan"; border.width: 1}
            PropertyChanges { target: buttonLabel; color: "#00e3f9"   }

        }

    ]
} // end of button
