import QtQuick 2.0

Item{
    id: rootItem

    property string imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_released_button.png"
    property string imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_released_button.png"
    property string imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_pressed_button.png"
    property string text: "ImgButton"
    signal clicked
    property string previous_state: ""

    implicitHeight: 20; implicitWidth: 100
    width: buttonImage.width; height: buttonImage.height
    Image{
        id: buttonImage
        source: imageNormal

    }
    Text{
        id: buttonText
        text: rootItem.text
        anchors.centerIn: parent
        color : "#00e3f9"
        font.family: "Segoe UI"
        font.bold: true
        font.pixelSize: 16
    }
    MouseArea{
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            previous_state = rootItem.state
            rootItem.state = "hover"
        }
        onExited: {
            rootItem.state = ""
        }
        onPressed: {
            rootItem.state = "pressed"
        }
        onReleased: {
            rootItem.state = "normal"
        }
        onClicked: rootItem.clicked();
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges { target: buttonImage; source: imagePressed; }
            PropertyChanges {target: rootItem; scale: 1.2  }
        }
        ,State {
            name: "normal"
            PropertyChanges { target: buttonImage; source: imageNormal;  }
            PropertyChanges {target: rootItem; scale: 1  }
        }
        ,State {
            name: "hover"
//            PropertyChanges { target: buttonImage; source: imageHover; }
            PropertyChanges {target: rootItem; scale: 1.5  }
        }

    ]


}
