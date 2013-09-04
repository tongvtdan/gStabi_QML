import QtQuick 2.0
Item{
    id: root
    signal clicked;
    signal entered;
    signal exited;
    property string list_header_title: "List Header"
    property int    item_index: 0
    property string item_text: ""
    property string hightlght_color: "cyan"
    property alias list_count: listView.count;
    property alias list_model: listView.model
    property alias  current_index: listView.currentIndex
    implicitWidth: 100; implicitHeight: 100
    Component {
        id: listDelegate
        Rectangle {
            id: wrapper
            width: listItemLabel.contentWidth+20 ; height: listItemLabel.contentHeight + 10; color: "#00000000"
            border.width: 1 ; border.color: "cyan"
            Text {
                id: listItemLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color : "#00e3f9"
                text: value
                Behavior on color{ ColorAnimation { } }
            }
            states: State{
                name: "Current" ; when: wrapper.ListView.isCurrentItem
                PropertyChanges {target: wrapper; x: 20}
            }
            transitions: Transition { NumberAnimation { property: "x"; duration: 200; }
            }
            MouseArea{
                anchors.fill: parent; hoverEnabled: true
                onClicked: {
                    wrapper.ListView.view.currentIndex = index
                    item_index = index;
                    item_text = listItemLabel.text
                    root.clicked();
                }

                onEntered: {
                    wrapper.border.color   = "#009dff"
                    listItemLabel.color = "red"
                    item_index = index;
                    root.entered();
                }
                onExited: {
                    wrapper.border.color   = "cyan"
                    listItemLabel.color = "#00e3f9"
                    root.exited();
                }
            }
        }

    } // end of Component
    Component {
        id: highlightBar
        Rectangle {
            width: listView.currentItem.width; height: listView.currentItem.height
            color: hightlght_color
            opacity: 0.5
            y: listView.currentItem.y;
            x: listView.currentItem.x;
            Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
            Behavior on x { SpringAnimation { spring: 2; damping: 0.1 } }
        }
    }
    Component{
        id: headerBar
        Rectangle {
            width: root.width; height: 20;
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#7d04f3e4"
                }

                GradientStop {
                    position: 1
                    color: "#000000"
                }
            }
            border { color: "cyan"; width: 1; }
            Text {
                id: headerText
                anchors.centerIn: parent
                color: "chartreuse"
                text: list_header_title
            }
        }
    }

    ListView{
        id: listView
        implicitWidth: 100; implicitHeight: 150;
        model: listModel
        delegate: listDelegate
        highlightFollowsCurrentItem: false
        highlight: highlightBar
        header: headerBar
        focus: true
        spacing: 2
    } // end of ListView
    ListModel {  id: listModel }
//    onItem_indexChanged: {console.log("Current Index: " + item_index); listView.currentIndex = item_index}
}
