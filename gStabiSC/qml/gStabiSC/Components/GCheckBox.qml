import QtQuick 2.0

Item{
    id: checkBoxContainer
    property string     checkbox_text   : "Checkbox"
    property bool       checked_state   : false

    implicitWidth: checkBoxBorder.width + checkBoxText.contentWidth + 30; implicitHeight: 30

    Rectangle {
        id: checkBoxBorder
        z: 1
        width: 18; height: 18; radius: height/2
        color: "transparent"
        border.width: 2
        border.color: "cyan"
        anchors.left: parent.left; anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        Rectangle{
            id: checkBoxChecked
//            anchors.centerIn:  parent.Center
            width: 0.6*checkBoxBorder.width; height: 0.6*checkBoxBorder.height; radius: height/2
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
    GTextStyled {
        id: checkBoxText
        text: checkbox_text
        anchors.left: checkBoxBorder.right;   anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color : "cyan"
        font.pixelSize: 12
    }

    states: [
        State{
            name: "checked"
            when: checked_state
            PropertyChanges { target: checkBoxChecked; color: "cyan"; anchors.horizontalCenterOffset: 0; anchors.verticalCenterOffset: 0   }
        }
        ,State {
            name:"unchecked"
            when: !checked_state
            PropertyChanges { target: checkBoxChecked; color: "transparent";   }
        }

    ]


}
