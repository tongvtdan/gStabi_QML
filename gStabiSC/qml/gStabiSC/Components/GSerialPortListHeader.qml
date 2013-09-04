import QtQuick 2.0

Rectangle {
    width: 100; height: 20;
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#7d04f3e4"
        }

        GradientStop {
            position: 1
            color: "#000000"
        }
    }
    border {
        color: "cyan"; width: 1
    }

    Text {
        id: headerText
        anchors.centerIn: parent
        color: "chartreuse"
        text: qsTr("Serial Ports")
    }
}
