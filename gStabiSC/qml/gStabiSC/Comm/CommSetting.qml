import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item{
    id: comportSettings
    property string portname: ""    // used to store portname in getPortNameList()
    property string selected_portname: ""
    property bool portUpdated: _serialLink.isPortListUpdated
    property bool showPortSetting: true
    property int anchor_topMargin   : 10
    property int anchor_bottomMargin: 10
    property int anchor_leftMargin  : 10
    property int anchor_rightMargin : 10

    property int  dragMaxX          : 500
    property int  dragMaxY          : 500


    implicitHeight: 150
    implicitWidth: 300
    BorderImage {
        id: commBorderImage
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_serial_setting_dialog.png"
        width: 300; height: 200
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    Text {
        font.family: "Ubuntu"
        font.bold: true
        color: "cyan"
        text: "Serial Ports"
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
    }
/*
    ComboBox{
        id: portListBox
        anchors.left: parent.left
        anchors.leftMargin: anchor_leftMargin
        anchors.top: parent.top
        anchors.topMargin: anchor_topMargin+20
        model: comportList
        style: ComboBoxStyle {
            background: BorderImage {
                source: control.pressed ? "qrc:/images/qml/gStabiSC/images/dropdownlist/selected_dropdownlist.png" : "qrc:/images/qml/gStabiSC/images/dropdownlist/deselected_dropdownlist.png"
            }
        }
        onCurrentTextChanged:{
            _serialLink.update_comport_settings(currentText);
            console.log(currentText);
        }
    }   // portlistBox
*/
    Rectangle{
        id:listBackGround
        width: 180; height: 88;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.bottom: parent.bottom; anchors.bottomMargin: 50
        color: "#00000000"

        Component {
            id: portListDelegate
            Rectangle {
                id: wrapper
                width: 70 ; height: 20; color: "#00000000"
                border.width: 1 ; border.color: "cyan"

                Text {
                    id: portNameListText
//                    anchors.left: parent.left; anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color : "#00e3f9"
                    text: port
                    Behavior on color{
                        ColorAnimation { }
                    }
                }
                states: State{
                    name: "Current"
                    when: wrapper.ListView.isCurrentItem
                    PropertyChanges {target: wrapper; x: 20}
                    PropertyChanges { target: portNameListText; color: "red" }
                }
                transitions: Transition {
                    NumberAnimation { property: "x"; duration: 200; }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        wrapper.ListView.view.currentIndex = index
                        selected_portname = portNameListText.text;
                        console.log("Selected: " + selected_portname)
                    }

                    onEntered: {
                        wrapper.border.color =  "cyan"
                        portNameListText.color = "red"
//                        portNameListText.anchors.leftMargin = 60
                    }
                    onExited: {
                        wrapper.border.color ="#009dff"
                        portNameListText.color = "#00e3f9"
//                        portNameListText.anchors.leftMargin = 10
                    }
                }

            }
        } // end of Component
        Component {
            id: highlightBar
            Rectangle {
                width: 70; height: 20
                color: "cyan"
                opacity: 0.5
                y: portListView.currentItem.y;
                x: portListView.currentItem.x;
                Behavior on y { SpringAnimation { spring: 2; damping: 0.1 } }
                Behavior on x { SpringAnimation { spring: 2; damping: 0.1 } }
            }
        }

        ListView{
            id: portListView
            width: 150; height: parent.height
            x: 10

            model: comportList
            delegate: portListDelegate
            highlightFollowsCurrentItem: false
            highlight: highlightBar
            focus: true
            spacing: 2



        } // end of ListView
    } // end of list
    ListModel {
        id: comportList
    }


    Button{
        id: refresshPorts
//        anchors.left: portListBox.right
        anchors.leftMargin:0
//        anchors.top: portListBox.top
        anchors.topMargin: 1

        style: ButtonStyle{
            background: BorderImage {
                source: control.pressed ? "qrc:/images/qml/gStabiSC/images/buttons/pressed_refresh.png" : "qrc:/images/qml/gStabiSC/images/buttons/released_refresh.png"
                border.left: 4 ; border.right: 4 ; border.top: 4 ; border.bottom: 4
            }

            label: Text{
                Row {
                    anchors.centerIn: parent
                    spacing: 2
                    Image {
                        source: control.iconSource
                        anchors.verticalCenter: parent.verticalCenter
                        scale: 0.8
                    }
                    Text {
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                        text: control.text
                        color: "white"
                    }
                }
            }
        }
    } // refresh Button
    Button{
        id: portOpenClose
        text: _serialLink.isConnected? "Close" : "Open"
        anchors.right: parent.right
        anchors.rightMargin: 10
//        anchors.top: portListBox.top
        anchors.topMargin: 1

        style: ButtonStyle{
            background: BorderImage {
                source: control.pressed ? "qrc:/images/qml/gStabiSC/images/buttons/pressed_red_button.png" : "qrc:/images/qml/gStabiSC/images/buttons/released_red_button.png"
                border.left: 4 ; border.right: 4 ; border.top: 4 ; border.bottom: 4
            }
            label: Text{
                Row {
                    id: row
                    anchors.centerIn: parent
                    spacing: 2
                    Image {
                        source: control.iconSource
                        anchors.verticalCenter: parent.verticalCenter
                        scale: 0.8
                    }
                    Text {
                        renderType: Text.NativeRendering
                        anchors.verticalCenter: parent.verticalCenter
                        text: control.text
                        color: "white"
                    }
                }
            }
        }

        onClicked: {
            _serialLink.open_close_comport()
        }
    }// comport Open/Close


    //    } // communication GroupBox


    Timer{
        id: getPortListTimer
        interval: 100
        running: true
        repeat: false   // run once at start up
        onTriggered: {
            getPortNameList();
        }
    }
    function getPortNameList()
    {
        comportList.clear()
        for(var i=0 ; i < 5 ; i++){
            portname = _serialLink.getPortName(i);
            if(portname !== "NA"){
                comportList.append({"port": portname});
            }
        }
    }
    onPortUpdatedChanged: {
        getPortNameList();
    }
    states:[
        State {
            name: "show"
            PropertyChanges {target: comportSettings; scale: 1.0; opacity: 1; }

        }
        ,State {
            name: "hide"
            PropertyChanges {target: comportSettings; scale: 0.5 ; opacity: 0.5; }
        }

    ]
    transitions: [ Transition {
            from: "show" ; to:   "hide"
            NumberAnimation{ target: comportSettings; properties: "scale"; from: 1.0; to: 0.5; duration: 500}
            NumberAnimation { target: comportSettings; property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition{
            from: "hide"; to: "show"
            NumberAnimation { target: comportSettings; properties: "scale" ; from: 0.5; to: 1.0; duration: 500}
            NumberAnimation { target: comportSettings; property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
        }
    ]
    MouseArea{
        id: windowMouseArea
        width: parent.width ; height: 30
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        drag.minimumX: 0; drag.minimumY: 0
        drag.maximumX: dragMaxX
        drag.maximumY: dragMaxY
        onDoubleClicked: comportSettings.state == "hide"? comportSettings.state = "show" : comportSettings.state = "hide"


    }
    onStateChanged: {
        if(state == "show"){
            getPortNameList()
        }
    }
}
