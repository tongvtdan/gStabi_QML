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
    implicitWidth: serialportNameList.width
    border_normal: ""
    title: ""
    smaller_scale: 0
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
    GListView{
        id: serialportNameList
        width: 100; height: 150;  anchors.top: parent.top ; anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        x: 10
        list_header_title: "Serial Ports"
        onClicked: {
            selected_port_index = item_index;
            selected_portname   = item_text;
        }
        onEntered: {
            serial_port_info_details = _serialLink.get_selected_port_details(item_index);
            serialportInfoDetailsText.opacity = 1
        }
        onExited: {
            serial_port_info_details = _serialLink.get_selected_port_details(item_index);
            serialportInfoDetailsText.opacity = 0
        }
    }

    Timer{
        id: getPortListTimer
        interval: 100;  repeat: false   // run once at start up
        running: true
        onTriggered: getPortNameList();
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
        serialportNameList.list_model.clear()
        for(var i=0 ; i < 10 ; i++){
            portname = _serialLink.getPortName(i);
            if(portname !== "NA"){
                serialportNameList.list_model.append({"port": portname});
            }
        }
    }
    function serial_dialog_log(_message){
        msg_log = "<font color=\"cyan\">" + _message+ "</font><br>";
    }

}

