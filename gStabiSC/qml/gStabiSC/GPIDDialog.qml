import QtQuick 2.0

Item{
    id: pidDialogItem
    property string title_normal_color: "cyan"
    property string title_hover_color: "yellow"


    implicitWidth: 620; implicitHeight: 410
    BorderImage {
        id: pidDialogBorderImg
        width: 585
        height: 401
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: "images/gStabiUI_3.2_pid_dialog.png"
//        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_pid_dialog.png"
        border.left: 5; border.top: 21
        border.right: 32; border.bottom: 0

        Text {
            id: title
            font.family: "Segoe UI"
            font.bold: true
            color: title_normal_color
            text: "PID Setings"
            style: Text.Normal
            font.pixelSize: 12
            anchors.horizontalCenterOffset: 0
            anchors.top: parent.top
            anchors.topMargin: 3
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
