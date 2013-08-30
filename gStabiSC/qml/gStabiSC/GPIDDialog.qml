import QtQuick 2.0
import "Components"

GSettingDialog{
    id: pidDialog
    title: "Controller Parameters"
    state:"showDialog"
    width: 930; height: 500
    // Tilt Axis Motor
    Item{
        id: tiltItems
        anchors.left: parent.left; anchors.leftMargin: 20
        anchors.top: parent.top; anchors.topMargin: 70
        GTextInput{
            width: 140
            read_only: true
            text_value: "Tilt Axis Motor"
            anchors.bottom: tiltParameters.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: tiltParameters.horizontalCenter
        }
        GParametersContainer{
            id: tiltParameters
            height: 350
            anchors.left: parent.left; anchors.leftMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
        }
    }
    // Pan Axis Motor
    Item{
        id: panItems
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 70

        GTextInput{
            width: 140
            read_only: true
            text_value: "Pan Axis Motor"
            anchors.bottom: panParameters.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: panParameters.horizontalCenter
        }
        GParametersContainer{
            id: panParameters
            height: 350
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 0
        }
    }
    // Roll Axis Motor
    Item{
        id: rollItems
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.top: parent.top; anchors.topMargin: 70

        GTextInput{
            width: 140
            read_only: true
            text_value: "Roll Axis Motor"
            anchors.bottom: rollParameters.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: rollParameters.horizontalCenter
        }
        GParametersContainer{
            id: rollParameters
            height: 350
            anchors.right: parent.right; anchors.rightMargin: 0
            anchors.top: parent.top; anchors.topMargin: 0
        }
    }
    Item{
        id: buttonsItem
        anchors.left: parent.left
        anchors.leftMargin: 200
        anchors.bottom: parent.bottom; anchors.bottomMargin: 40
        Row{
            spacing: 5
            GButton{
                id: readButton
                text: "Read"
                onClicked: {

                }
            }
            GButton{
                id: writeButton
                text: "Write"
                onClicked: {}
            }

            GButton {
                id: runCheckButton
                text: "Run Check"
            }
        }
    }


}
