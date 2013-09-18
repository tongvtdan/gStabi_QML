import QtQuick 2.0

Item{
    id: frameContainer
    property string border_normal   : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_tilt_normal_frame.png"
    property string border_hover    : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_hover_frame.png"
    width: 310; height:  250

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: boarderHoverImg.visible = true
        onExited: boarderHoverImg.visible = false
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
