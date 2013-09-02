import QtQuick 2.0
import "Components"

GDialog{
    id: serialSettingDialog
    property string portname: ""    // used to store portname in getPortNameList()
    property string selected_portname: ""
    property int    selected_port_index: 1
    property bool   showPortSetting: true

    property string  msg_log: ""
    property string  serial_port_info_details: ""


    implicitHeight: 200
    implicitWidth: portListView.width
    border_normal: ""
    title: ""
    // Open Close Port Button
    GButton{
        id: openCloseComportButton
        width: 60; height: 30;
        text: "Open"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom;  anchors.bottomMargin: 10
        onClicked: {
            _serialLink.open_close_comport();
            if(_serialLink.isConnected) {
                serial_dialog_log("Open Serialport: " + selected_portname);
                serial_dialog_log("Waiting response from controller board...");

            }
            else serial_dialog_log("Close Serialport: " + selected_portname)

        }
    } // end of Open Close Port Button
    Component {
        id: portListDelegate
        Rectangle {
            id: wrapper
            width: 70 ; height: 20; color: "#00000000"
            border.width: 1 ; border.color: "cyan"
            Text {
                id: portNameText
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
                    selected_portname = portNameText.text;
                    selected_port_index = index
                }

                onEntered: {
                    wrapper.border.color   = "#009dff"
                    portNameText.color = "red"
                    serial_port_info_details = _serialLink.get_selected_port_details(index);
                    serialportInfoDetailsText.opacity = 1
                }
                onExited: {
                    wrapper.border.color   = "cyan"
                    portNameText.color = "#00e3f9"
                    serial_port_info_details = _serialLink.get_selected_port_details(index);
                    serialportInfoDetailsText.opacity = 0
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
    Component{
        id: headerBar
        GSerialPortListHeader{
        }
    }

    ListView{
        id: portListView
        width: 100; height: 150;  anchors.top: parent.top ; anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        x: 10
        model: comportList
        delegate: portListDelegate
        highlightFollowsCurrentItem: false
        highlight: highlightBar
        header: headerBar
        focus: true
        spacing: 2
    } // end of ListView
    /*
    Rectangle{
        id: portListItem
        width: 100; height: 100
        anchors.left: parent.left; anchors.leftMargin: 15
        color: "#00000000"
        anchors.top: parent.top
        anchors.topMargin: 0
        Component {
            id: portListDelegate
            Rectangle {
                id: wrapper
                width: 70 ; height: 20; color: "#00000000"
                border.width: 1 ; border.color: "cyan"
                Text {
                    id: portNameText
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
                        selected_portname = portNameText.text;
                        selected_port_index = index
                    }

                    onEntered: {
                        wrapper.border.color   = "#009dff"
                        portNameText.color = "red"
                        serial_port_info_details = _serialLink.get_selected_port_details(index);
                        serialportInfoDetailsText.opacity = 1
                    }
                    onExited: {
                        wrapper.border.color   = "cyan"
                        portNameText.color = "#00e3f9"
                        serial_port_info_details = _serialLink.get_selected_port_details(index);
                        serialportInfoDetailsText.opacity = 0
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
        Component{
            id: headerBar
            GSerialPortListHeader{
            }
        }

        ListView{
            id: portListView
            width: 100; height: parent.height
            anchors.top: parent.top ; anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            highlightRangeMode: QQuickItemView.ApplyRange
            x: 10
            model: comportList
            delegate: portListDelegate
            highlightFollowsCurrentItem: true
            highlight: highlightBar
            header: headerBar
            focus: true
            spacing: 2
            contentHeight: parent.height; contentWidth: parent.width
        } // end of ListView
    } // end of list
    */
    ListModel {  id: comportList }

    Timer{
        id: getPortListTimer
        interval: 100;  repeat: false   // run once at start up
        running: true
        onTriggered: getPortNameList();
    }

//    onPortUpdatedChanged: { getPortNameList();}
    onStateChanged: {
        if(state == "show"){
            getPortNameList()
        }
    }
    // this code cause warning when run the app, but it works
    Connections{
        target: _serialLink
        onIsPortListUpdatedChanged: {
            getPortNameList() // update portlist when there is a change
            for(var i=0; i < portListView.count; i++){
                if(selected_port_index === i){
                    portListView.currentIndex = i
                    selected_portname = comportList.get(i).port // get port name from port name list model
                }
            }
        }
        onIsConnectedChanged:{
            if(_serialLink.isConnected){ openCloseComportButton.text = "Close"} else {openCloseComportButton.text = "Open"}
        }
    }
    Flickable{
        id: portDetails
        width: 250; height: 100
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.right
        anchors.leftMargin: 0
        pressDelay: 300
        clip: true
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        Text {
            id: serialportInfoDetailsText
            anchors.fill: parent
            color: "#04f900"
            text:serial_port_info_details
            font.family: "Segoe UI"
            wrapMode: Text.NoWrap
            opacity: 0
            font.pixelSize: 12
            Behavior on opacity {
                NumberAnimation { target: serialportInfoDetailsText; property: "opacity"; duration: 500; easing.type: Easing.Bezier }
            }
        }
    }
    onSelected_portnameChanged: {
        _serialLink.update_comport_settings(selected_portname);
        serial_dialog_log("Reselected port to: "+ selected_portname)
    }

    function getPortNameList()
    {
        comportList.clear()
        for(var i=0 ; i < 10 ; i++){
            portname = _serialLink.getPortName(i);
            if(portname !== "NA"){
                comportList.append({"port": portname});
            }
        }
    }
    function serial_dialog_log(_message){
        msg_log = "<font color=\"cyan\">" + _message+ "</font><br>";
    }

}

