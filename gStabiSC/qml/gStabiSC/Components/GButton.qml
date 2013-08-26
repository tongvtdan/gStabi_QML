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
        font.family: "Segoe UI Symbol"
        font.bold: true
        font.pixelSize: 16
        text: button.text
        Behavior on color { ColorAnimation { duration: 200 }}

    }
    MouseArea{
        id: mouseArea
        anchors.fill: parent; hoverEnabled: true
        onClicked: button.clicked();
        onEntered: {
            button.border.color =  "cyan"
            buttonLabel.color = "red"
        }
        onExited: {
            button.border.color ="#009dff"
            buttonLabel.color = "#00e3f9"            
        }
        onPressed: button.border.width = 3
        onReleased:  button.border.width = 1
    }
    Behavior on color {ColorAnimation {duration: 200 }}
} // end of button
