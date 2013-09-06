import QtQuick 2.0

Item{
    id: dialogContainer
    property string msg_history         : "Init done \n"         // all other QML file will refer to this variable to display message in conole
    property int    dragMaxX            : 500
    property int    dragMaxY            : 500
    property string title_normal_color  : "cyan"
    property string title_hover_color   : "yellow"
    property string title               : "Setting Dialog"
    property int    show_state_posY     : 500
    property int    hide_state_posY     : 600
    property double hide_scale          : 0.5


    property string  border_normal: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_setting_dialog.png"
    property string  border_hover : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_hover_setting_dialog.png"
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
        State {
            name: "show"
            PropertyChanges {target: dialogContainer; scale: 1.0; opacity: 1; y: show_state_posY ; z: 50}

        }
        ,State {
            name: "hide"
            PropertyChanges {target: dialogContainer; scale: hide_scale ; opacity: 0.5; y: hide_state_posY; z: -1}
        }
    ]
    transitions: [ Transition {
            from: "show"
            to:   "hide"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity"; duration: 400;   }
                NumberAnimation { target: dialogContainer; property: "y"; duration: 400; easing.type: Easing.InOutQuad }
                SequentialAnimation{
                    NumberAnimation{ target: dialogContainer; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
                    NumberAnimation{ target: dialogContainer; properties: "scale"; from: 1.5; to: 0.5; duration: 200;}

                }

            }
        },
        Transition{
            from: "hide"
            to: "show"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity"; duration: 600;   }
                NumberAnimation { target: dialogContainer; property: "y"; duration: 600; easing.type: Easing.InOutQuad }
                SequentialAnimation{
                    NumberAnimation{ target: dialogContainer; properties: "scale"; from: 0.5; to: 1.0; duration: 200;}
                    NumberAnimation{ target: dialogContainer; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
                    NumberAnimation{ target: dialogContainer; properties: "scale"; from: 1.5; to: 1; duration: 200;}

                }
            }
        }
    ]

}
