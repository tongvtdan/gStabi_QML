import QtQuick 2.0

Item{
    id: gDialog
    property string msg_history: "Init done \n"         // all other QML file will refer to this variable to display message in conole
    property int anchor_topMargin   : 10
    property int anchor_bottomMargin: 10
    property int anchor_leftMargin  : 10
    property int anchor_rightMargin : 10
    property int  dragMaxX          : 500
    property int  dragMaxY           : 500
    property string title_normal_color: "cyan"
    property string title_hover_color: "yellow"
    property string title: "Dialog"
    property int  focus_state_posY      : 500
    property int  unfocus_state_posY    : 600
    property double smaller_scale : 0.5
//    property string  border_normal: "../images/gStabiUI_3.2_normal_serial_setting_dialog.png"
    property string  border_normal :  "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_serial_setting_dialog.png"
    implicitHeight: 300
    implicitWidth: 300
    MouseArea{
        id: dragConsolWindowArea
//        width: parent.width ; height: 30
        anchors.fill: parent
        anchors.top: parent.top;  anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        drag.minimumX: 0; drag.minimumY: 0
        drag.maximumX: dragMaxX ;  drag.maximumY: dragMaxY
        hoverEnabled: true
        onEntered: dialogTitle.color = title_hover_color
        onExited: dialogTitle.color = title_normal_color
        onDoubleClicked: gDialog.state == "smaller"? gDialog.state = "focus" : gDialog.state = "smaller"
    }
    BorderImage {
        id: background
        x: 0
        y: 2
//        width: 150; height: 200
        anchors.fill: parent
        source: border_normal
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    Text {
        id: dialogTitle
        font.family: "Segoe UI"
        font.bold: true
        color: title_normal_color
        text: title
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 2

    }
    states:[
        State {
            name: "focus"
            PropertyChanges {target: gDialog; scale: 1.0; opacity: 1; y: focus_state_posY }

        }
        ,State {
            name: "smaller"
            PropertyChanges {target: gDialog; scale: smaller_scale ; opacity: 0.5; y: unfocus_state_posY}
        }


    ]
    transitions: [ Transition {
            from: "focus"
            to:   "smaller"
            ParallelAnimation{
                NumberAnimation { target: gDialog; property: "opacity"; duration: 400;  }
                NumberAnimation { target: gDialog; property: "y"; duration: 400; easing.type: Easing.InOutQuad }
                SequentialAnimation{
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 1.5; to: 0.5; duration: 200;}

                }

            }
        },
        Transition{
            from: "smaller"
            to: "focus"
            ParallelAnimation{
                NumberAnimation { target: gDialog; property: "opacity"; duration: 600;  }
                NumberAnimation { target: gDialog; property: "y"; duration: 600; easing.type: Easing.InOutQuad }
                SequentialAnimation{
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 0.5; to: 1.0; duration: 200;}
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 1.5; to: 1; duration: 200;}

                }
            }
        }
    ]
}
