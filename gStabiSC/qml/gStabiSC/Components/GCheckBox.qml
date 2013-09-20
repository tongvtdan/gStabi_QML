import QtQuick 2.0

Item{
    id: checkBoxContainer
    property string     checkbox_text   : "Checkbox"
    property bool       checked_state   : false

    implicitWidth: checkBoxImage.width + checkBoxText.contentWidth + 30; implicitHeight: 30


    Image {
        id: checkBoxImage
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_unchecked_checkbox.png"

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
        anchors.left: checkBoxImage.right;   anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color : "cyan"
        font.pixelSize: 12
    }
    states: [
        State{
            name: "checked"
            when: checked_state
            PropertyChanges { target: checkBoxImage; source: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_checked_checkbox.png";   }
        }
        ,State {
            name:"unchecked"
            when: !checked_state
            PropertyChanges { target: checkBoxImage; source: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_unchecked_checkbox.png";   }
        }
    ]


}
