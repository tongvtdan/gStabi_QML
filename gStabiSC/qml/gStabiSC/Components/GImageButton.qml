import QtQuick 2.0

BorderImage{
    id: rootItem

    property string imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_settings"
    property string imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_settings"
    property string imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.2_pressed_button.png"
    property string border_normal   : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_button_border.png"
    property string border_hover    : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_hover_button_border.png"

    property string text: "ImgButton"
    property bool  hover_enabled: true
    property bool toggle: false;
    property bool toggle_enabled: false
    signal clicked
    signal entered
    signal exited
    signal pressed
    signal released


    width : 70; height: 50
    border.left: 5; border.top: 5
    border.right: 5; border.bottom: 5
    asynchronous: true
//    source: "../images/buttons/gStabiUI_3.3_normal_button_border.png"
    source: border_normal

    Image{
        id: buttonImage
//        source: "../images/buttons/gStabiUI_3.3_normal_settings.png"
        asynchronous: true
//        fillMode: Image.PreserveAspectFit
        width: 50 ;  height: 35
        anchors.centerIn: parent
        source: imageNormal


    }
    GTextStyled{
        id: buttonText
        text: rootItem.text
        anchors.centerIn: parent
        color : "#00e3f9"
        font.pixelSize: 16
    }
    MouseArea{
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: hover_enabled
        onEntered: {
            if(rootItem.state !== "pressed")
            rootItem.state = "hover"
            rootItem.entered();
        }
        onExited: {
            if(rootItem.state !== "pressed")

            rootItem.state = "normal"
            rootItem.exited();
        }
        onPressed: {
            rootItem.state = "pressed"
            rootItem.pressed();
        }
        onReleased: {

            rootItem.state = "normal"
            rootItem.released();
        }
        onClicked: {
            toggle = !toggle
            rootItem.clicked();
        }
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges { target: buttonImage; source: imagePressed; }
            PropertyChanges { target: rootItem; source: border_hover  }
        }
        ,State {
            name: "normal"
            PropertyChanges { target: buttonImage; source: imageNormal;  }
            PropertyChanges { target: rootItem; source: border_normal  }
//            PropertyChanges {target: rootItem; scale: 1  }
        }
        ,State {
            name: "hover"
            PropertyChanges { target: buttonImage; source: imageHover; }
            PropertyChanges { target: rootItem; source: border_hover  }
//            PropertyChanges {target: rootItem; scale: 1.2  }
        }

    ]


}
