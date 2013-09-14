import QtQuick 2.0
import "../Components"

GFrame{
    id: infoContainer
    anchors.centerIn: parent.Center
    border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_info_normal_frame.png"
    GTextStyled{
        id: aboutText
        text: "gStabiSC Application\n
               Developed by Gremsy Co., Ltd\n
               Contact:\n
               dan.tong@gremsy.com"
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
        color: "cyan"
        anchors.top: parent.top; anchors.topMargin: 30

    }
}
