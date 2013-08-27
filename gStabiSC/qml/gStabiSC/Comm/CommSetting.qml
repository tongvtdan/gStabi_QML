import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0
import "../Components"

Item{
    id: comportSettings
    property string portname: ""    // used to store portname in getPortNameList()
    property string selected_portname: ""
    property int  selected_port_index: 1
    property bool portUpdated: _serialLink.isPortListUpdated
    property bool showPortSetting: true
    property int anchor_topMargin   : 10
    property int anchor_bottomMargin: 10
    property int anchor_leftMargin  : 10
    property int anchor_rightMargin : 10

    property int  dragMaxX          : 500
    property int  dragMaxY          : 500

    property string msg_log: ""
    property string title_normal_color: "cyan"
    property string title_hover_color: "yellow"


    implicitHeight: 200
    implicitWidth: 300
    BorderImage {
        id: commBorderImage
        source: "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_serial_setting_dialog.png"
//        source: "../images/gStabiUI_3.2_serial_setting_dialog.png"
        width: 300; height: 200

        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    Text {
        id: dialogTitle
        font.family: "Ubuntu"
        font.bold: true
        color: title_normal_color
        text: "Serial Ports"
        font.pixelSize: 12
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 30
    }
    // Open Close Port Button
    GButton{
        id: openCloseComportButton
        width: 60; height: 30;
        anchors.left: listBackGround.right; anchors.leftMargin: 30
        anchors.top: parent.top; anchors.topMargin: 50
        text: _serialLink.isConnected? "Close" : "Open"
        onClicked: {
            _serialLink.open_close_comport();
            if(_serialLink.isConnected) serial_dialog_log("Open Serialport");
            else serial_dialog_log("Close Serialport")

        }
    } // end of Open Close Port Button
    // Refresh Button
    GButton{
        id: refreshButton
        width: 60; height: 30;
        anchors.left: listBackGround.right; anchors.leftMargin: 30
        anchors.top: openCloseComportButton.top; anchors.topMargin: 36
        text: "Refresh"
        onClicked: {
            getPortNameList();
            serial_dialog_log("Refresh port list")
        }
    } // end of Refresh Button
    Rectangle{
        id: listBackGround
        width: 100; height: 88;
//        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.left: parent.left; anchors.leftMargin: 10
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
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color : "#00e3f9"
                    text: port
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
                        selected_portname = portNameListText.text;
                        selected_port_index = index
                        _serialLink.update_comport_settings(selected_portname); // update portname
                        serial_dialog_log("Selected: " + selected_portname )
                    }
                    onEntered: {
                        wrapper.border.color =  "cyan"
                        portNameListText.color = "red"
                    }
                    onExited: {
                        wrapper.border.color ="#009dff"
                        portNameListText.color = "#00e3f9"
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
            width: 100; height: parent.height
            x: 10

            model: comportList
            delegate: portListDelegate
            highlightFollowsCurrentItem: false
            highlight: highlightBar
            focus: true
            spacing: 2
            onCountChanged: {
//                var i;
//                for(i=0;i<comportList.count;i++){
//                    if(selected_port_index == i){
                        currentIndex = selected_port_index;
//                    }
//                }
            }


        } // end of ListView
    } // end of list
    ListModel {
        id: comportList
    }

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

    // State and transition for view the dialog

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
        anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        drag.minimumX: 0; drag.minimumY: 0
        drag.maximumX: dragMaxX; drag.maximumY: dragMaxY
        hoverEnabled: true
        onEntered: dialogTitle.color = title_hover_color
        onExited: dialogTitle.color = title_normal_color
        onDoubleClicked: comportSettings.state == "hide"? comportSettings.state = "show" : comportSettings.state = "hide"


    }
    onStateChanged: {
        if(state == "show"){
            getPortNameList()
        }
    }

    function serial_dialog_log(_message){
        msg_log = "<font color=\"cyan\">" + _message+ "</font><br>";
    }
}
