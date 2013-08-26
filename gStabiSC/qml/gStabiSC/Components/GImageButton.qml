import QtQuick 2.0

Item{
    id: rootItem

    property string imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_released_button.png"
    property string imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_released_button.png"
    property string imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_pressed_button.png"
    property string text: "ImgButton"
    signal clicked

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
        font.family: "Segoe UI Symbol"
        font.bold: true
        font.pixelSize: 16
    }
    MouseArea{
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            rootItem.state = "hover"
        }
        onExited: {
            rootItem.state = "normal"
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
            PropertyChanges { target: buttonImage; source: imageHover; }
            PropertyChanges {target: rootItem; scale: 1.5  }
        }

    ]


}
/*
Image {
    id: button

    property string theme: "Beryl"
    property string imageNormal: "../pics/svgbutton/"+theme+"/normal.svg"
    property string imageHover: "../pics/svgbutton/"+theme+"/hovered.svg"
    property string imagePressed: "../pics/svgbutton/"+theme+"/pressed.svg"
    property bool hover: false

    source: hover ? imageHover : imageNormal

    states: [
        State {
            name: "pressed"
            PropertyChanges {
                target: button
                source: imagePressed
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            button.hover = true
        }
        onExited: {
            button.hover = false
            button.state = ""
        }
        onPressed: {
            button.state = "pressed"
        }
        onReleased: {
            button.state = ""
        }
    }
}
  */
