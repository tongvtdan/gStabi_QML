import QtQuick 2.0

Item{
    id: dialogContainer
    property string msg_history         : "Init done \n"         // all other QML file will refer to this variable to display message in conole
    property int    dragMaxX            : 500
    property int    dragMaxY            : 500
    property string title_normal_color  : "cyan"
    property string title_hover_color   : "yellow"
    property string title               : "Setting Dialog"
    property int  minimize_pos_x    : 0
    property int  minimize_pos_y    : 0
    property int  current_pos_x     : 0
    property int  current_pos_y     : 0

    property string  border_normal: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_setting_dialog.png"
    property string border_hover : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_hover_setting_dialog.png"
//    property string  border_normal  : "../images/gStabiUI_3.2_normal_setting_dialog.png"
//    property string border_hover    : "../images/gStabiUI_3.2_hover_setting_dialog.png"

    implicitWidth: 940; implicitHeight: 500
    MouseArea{
        id: windowMouseArea
        anchors.fill: parent
        anchors.top: parent.top;  anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        drag.minimumX: 0; drag.minimumY: 0
        drag.maximumX: dragMaxX ;  drag.maximumY: dragMaxY
        hoverEnabled: true
        onEntered: {
            dialogHoverBorderImg.opacity = 1;
            dialogTitle.color = title_hover_color;
        }
        onExited: {
            dialogHoverBorderImg.opacity = 0;
            dialogTitle.color = title_normal_color;
        }
//        onDoubleClicked: dialogContainer.state === "hideDialog"? dialogContainer.state = "showDialog" : dialogContainer.state = "hideDialog"
    }
    BorderImage {
        id: dialogBorderImg
        anchors.fill: parent
        source: border_normal
        opacity: 1
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    BorderImage {
        id: dialogHoverBorderImg
        anchors.fill: parent
        source: border_hover
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        opacity: 0
    }
    Text {
        id: dialogTitle
        color: "#042eff"
        font.family: "Segoe UI"
        font.bold: true
        text: title
        verticalAlignment: Text.AlignVCenter
        style: Text.Normal
        font.pixelSize: 20
        anchors.top: dialogBorderImg.top; anchors.topMargin: 9
        anchors.horizontalCenter: parent.horizontalCenter; anchors.horizontalCenterOffset: 0
        horizontalAlignment: Text.AlignHCenter
    }
    states:[
        State{
            name: "showDialog"
            PropertyChanges { target: dialogContainer; opacity: 1; scale: 1; z: 100  }
        }
        ,State {
            name: "hideDialog"
            PropertyChanges {target: dialogContainer; opacity: 0; scale: 0; z: -1}
        }
    ]
    transitions: [
        Transition {
            from: "showDialog" ; to:   "hideDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity";  duration: 500;}
                NumberAnimation { target: dialogContainer; property: "scale"; duration: 500; easing.type: Easing.Bezier}
                NumberAnimation { target: dialogContainer; property: "z"; duration: 500; easing.type: Easing.Bezier}
            }
        }
        ,Transition {
            from: "hideDialog" ; to: "showDialog"
            ParallelAnimation{
                PropertyAnimation{ target: dialogContainer; property : "opacity"; duration: 500;}
                NumberAnimation { target: dialogContainer; property: "scale"; duration: 500; easing.type: Easing.OutElastic}
                NumberAnimation { target: dialogContainer; property: "z"; duration: 500; easing.type: Easing.Bezier}

            }

        }
    ]

}
