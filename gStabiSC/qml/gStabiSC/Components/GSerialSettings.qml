import QtQuick 2.0

Rectangle{
    id: serialSettingDialog
//    property string portname: ""    // used to store portname in getPortNameList()
    property string selected_portname: "COM1"
    property int    selected_port_index: 1
    property bool   showPortSetting: true

    property string  msg_log: ""
    property string  serial_port_info_details: ""
    property bool  view_details: false


    height: 200;   width: 400
    color: "transparent"
    border{color: "cyan"; width: 1}
    // Open Close Port Button
    GButton{
        id: openCloseComportButton
        width: 60; height: 30;
        text: "Open"
        anchors.left: serialportNameList.right
        anchors.leftMargin: 10
        anchors.top: serialportNameList.top
        anchors.topMargin: 0
        onClicked: {
            if(!_serialLink.isConnected){       // if port is being closed, can update port name
                _serialLink.update_comport_settings(selected_portname);
                console.log("Port will be open: "+ selected_portname)
            }
            _serialLink.open_close_comport();
            if(_serialLink.isConnected) {
                dialog_log("Port " + selected_portname + " state: Opened");
                dialog_log("Waiting response from controller board...");
            }
            else dialog_log("Port " + selected_portname + " state: Closed")
        }
    } // end of Open Close Port Button
    GListView{
        id: serialportNameList
        width: 100; height: 150;
        anchors.left: parent.left; anchors.leftMargin: 10;
        anchors.top: parent.top ; anchors.topMargin: 10
        list_header_title: "Serial Ports"
        onClicked: {
            selected_port_index = item_index;
            selected_portname   = item_text;
            console.log("Chose: "+ selected_portname)
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
        onTriggered: {
            check_and_set_current_port()
        }
    }

    Flickable{
        id: portDetails
        width: 250; height: 100
        anchors.top: serialportNameList.top; anchors.topMargin: 40
        anchors.left: openCloseComportButton.left; anchors.leftMargin: 0
        pressDelay: 300
        clip: true
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        visible: view_details
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
    //[!] this code cause warning when run the app, but it works
    Connections{
        target: _serialLink
        onIsPortListUpdatedChanged: {check_and_set_current_port();}
        onIsConnectedChanged:{
            if(_serialLink.isConnected){ openCloseComportButton.text = "Close"} else {openCloseComportButton.text = "Open"}
        }
    }
//    [!]
    function getPortNameList()
    {
        serialportNameList.list_model.clear()
        for(var i=0 ; i < 10 ; i++){
            var portname = _serialLink.getPortName(i);
            if(portname !== "NA"){
                serialportNameList.list_model.append({"value": portname});
            }
        }
    }
    function check_and_set_current_port(){

        getPortNameList() // update portlist when there is a change
        for(var i=0; i < serialportNameList.list_count; i++){
            var port_name_in_list = serialportNameList.list_model.get(i).value;
            if(selected_portname === port_name_in_list ) // get port name from port name list model
            {
                dialog_log("Find the restored port " + selected_portname)
                serialportNameList.current_index = i;
                selected_portname = port_name_in_list;
                dialog_log("Selected the port: " + selected_portname)
            }
            else if(selected_port_index === i){
                dialog_log("Port " + selected_portname + " was removed")
                serialportNameList.current_index = i;
                selected_portname = port_name_in_list;
                dialog_log("Selected new port: " + selected_portname)
            }
        }
    }

    function dialog_log(_message){
//        msg_log = "<font color=\"cyan\">" + _message+ "</font><br>";
         msg_log = _message+ "\n";
    }
}

