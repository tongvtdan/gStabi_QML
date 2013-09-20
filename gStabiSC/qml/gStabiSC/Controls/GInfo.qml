import QtQuick 2.0
import "../Components"

GFrame{
    id: infoContainer
    anchors.centerIn: parent.Center
    title: "INFO"
    GTextStyled{
        id: aboutText
        text: "    gStabiSC Application\n\n" +
              "Software Version: "  + _configuration.application_version()+ "\n\n" +
               "Developed by Gremsy Co., Ltd\n\n" +
               "Contact: dan.tong@gremsy.com"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
        color: "cyan"
        anchors.top: parent.top; anchors.topMargin: 30

    }
    GButton{
        id: enterKeycodeEnableButton
        text: "Enter Keycode"
        anchors.left: parent.left ;  anchors.leftMargin: 20
        anchors.bottom: parent.bottom;  anchors.bottomMargin: 30
        onClicked: {
            keycodeInputDialog.state = "showDialog"
        }
    }
}
