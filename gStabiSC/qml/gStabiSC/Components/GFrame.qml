import QtQuick 2.0

Item{
    id: frameContainer
    property string border_normal   : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_normal_frame.png"
    property string border_hover    : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_hover_frame.png"
    property string title           : "GFrame"

    width: 310; height:  250
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            titlePanelText.font.pixelSize = 16;
            boarderHoverImg.visible = true
        }
        onExited: {
            titlePanelText.font.pixelSize = 14;
            boarderHoverImg.visible = false
        }
//        onEntered: boarderHoverImg.visible = true
//        onExited: boarderHoverImg.visible = false
    }
    GTextStyled{
        id: titlePanelText
        text: title
        font.pixelSize: 14
        color: "cyan"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top;     anchors.topMargin: -4
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

    }
    BorderImage {
        id: boardNormalImg
        asynchronous: true
        width: parent.width ; height: parent.height
        border.left: 5; border.top: 5 ;border.right: 5; border.bottom: 5
        anchors.top: parent.top;
        source: border_normal
    }
    BorderImage {
        id: boarderHoverImg
        asynchronous: true
        width: parent.width ; height: parent.height
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        anchors.top: parent.top;
        source: border_hover
        visible: false
    }
}
