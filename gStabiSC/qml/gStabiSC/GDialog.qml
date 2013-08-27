import QtQuick 2.0

Item{
    id: gDialog
    property string msg_history: "Init done \n"         // all other QML file will refer to this variable to display message in conole
    property int anchor_topMargin   : 10
    property int anchor_bottomMargin: 10
    property int anchor_leftMargin  : 10
    property int anchor_rightMargin : 10
    property int  dragMaxX          : 500
    property int dragMaxY           : 500
    property string title_normal_color: "cyan"
    property string title_hover_color: "yellow"
    property string title: "Dialog"

    implicitHeight: 200
    implicitWidth: 300
    scale: 1.0
    BorderImage {
        id: background
        x: 0
        y: 2
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_serial_setting_dialog.png"
        width: 300; height: 200
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    Text {
        id: dialogTitle
        font.family: "Segoe UI Symbol"
        font.bold: true
        color: title_normal_color
        text: title
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
    }
    states:[
        State {
            name: "focus"
            PropertyChanges {target: gDialog; scale: 1.0; opacity: 1; }

        }
        ,State {
            name: "smaller"
            PropertyChanges {target: gDialog; scale: 0.5 ; opacity: 0.5; }
        }

    ]
    transitions: [ Transition {
            from: "focus"
            to:   "smaller"
            ParallelAnimation{
                NumberAnimation { target: gDialog; property: "opacity"; duration: 400;  }
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
                SequentialAnimation{
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 0.5; to: 1.0; duration: 200;}
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 1.0; to: 1.5; duration: 200;}
                    NumberAnimation{ target: gDialog; properties: "scale"; from: 1.5; to: 1; duration: 200;}
                }
            }
        }
    ]

    MouseArea{
        id: dragConsolWindowArea
        width: parent.width ; height: 30
        anchors.top: parent.top;  anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        drag.minimumX: 0; drag.minimumY: 0
        drag.maximumX: dragMaxX ;  drag.maximumY: dragMaxY
        hoverEnabled: true
        onEntered: dialogTitle.color = title_hover_color
        onExited: dialogTitle.color = title_normal_color
        onDoubleClicked: gDialog.state == "smaller"? gDialog.state = "focus" : gDialog.state = "smaller"
    }
}
