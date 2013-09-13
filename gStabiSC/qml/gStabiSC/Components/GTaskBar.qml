import QtQuick 2.0

Image {
    id: taskBar

    property alias controlModel: controlView.model
    property int  task_bar_width: 300
    property int  task_bar_height: 100

//    source: "qrc:/images/qml/gStabiSC/images/toolbar_back.png"
//    source: "../images/toolbar_back.png"

    height: 100
    width: 600
    Component {
        id: taskDelegate
        Item
        {
            id: delegate
            width: 80  ; height: 70
            BorderImage {
                id: borderIamge
                source:"qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_button_border.png"
                width: 70; height: 50
                border.left: 5; border.top: 5
                border.right: 5; border.bottom: 5
                Image {
                    width: 50 ;  height: 35
                    anchors.centerIn: parent
                    source: delegate.ListView.isCurrentItem? pixmapfocus:pixmap
                }
            }
            GTextStyled {
                text: name
                color: "cyan"
                font.pixelSize: 10
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: { delegate.ListView.view.currentIndex = index;
                    delegate.ListView.view.clicked(stateId) }
            }
        }
    }
    Component {
        id: highlight
        Item {
            width: 70; height: 50
            Image {
                id: highlightRect
                 width: 70; height: 50
//                anchors.fill: parent
                source: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_hover_button_border.png"
            }
        }
    }

    ListView {
        id: controlView
        signal clicked( string stateId )
        height: task_bar_height
        orientation: ListView.Horizontal
        anchors.left: parent.left
        anchors.right: parent.right
        delegate: taskDelegate
        highlight: highlight
        highlightMoveDuration: 1000
        highlightFollowsCurrentItem: true
        focus: true
        clip: true
        onClicked: { if(mainControlPanel.state !== stateId) mainControlPanel.state = stateId }
    }


    transitions: Transition {
        NumberAnimation { properties: "width,height,x,y"; duration: 500; }
        NumberAnimation { properties: "opacity"; duration: 250 }
    }
}
