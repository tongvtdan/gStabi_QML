import QtQuick 2.0

Item{
    id: checkBoxContainer
    property string     checkbox_text   : "Checkbox"
    property bool       checked_state   : false

    implicitWidth: checkBoxBorder.width + checkBoxText.contentWidth + 30; implicitHeight: 30

    Rectangle {
        id: checkBoxBorder
        z: 1
        width: 20; height: 20; radius: height/2
        color: "transparent"
        border.width: 2
        border.color: "cyan"
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        Rectangle{
            id: checkBoxChecked
            anchors.centerIn:  parent.Center
            width: 0.7*checkBoxBorder.width; height: 0.7*checkBoxBorder.height; radius: height/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            state: "unchecked"
        }
        MouseArea{
            id: checkBoxMouseArea
            anchors.fill: parent
            onClicked: {
                checked_state = !checked_state;
            }
        }

    }
    TextStyled {
        id: checkBoxText
        text: checkbox_text
        anchors.left: checkBoxBorder.right;   anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color : "cyan"
        font.pixelSize: 16
    }

    states: [
        State{
            name: "checked"
            PropertyChanges { target: checkBoxChecked; color: "limegreen";   }
        }
        ,State {
            name:"unchecked"
            PropertyChanges { target: checkBoxChecked; color: "transparent";   }
        }

    ]
    onChecked_stateChanged:  {
        if(checked_state) checkBoxContainer.state = "checked"
        else checkBoxContainer.state = "unchecked"
    }


}
