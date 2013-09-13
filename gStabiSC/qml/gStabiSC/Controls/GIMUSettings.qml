import QtQuick 2.0
import "../Components"
Rectangle {
    width: 300;   height: 200
    color: "transparent"
    border{color: "cyan"; width: 1}
    GTextStyled{
        anchors.centerIn: parent
        color: "cyan"
        text: "Comming soon..."
    }
}
