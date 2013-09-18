import QtQuick 2.0

GFrame{
    id: serialSettingDialog
//    property string selected_portname: "COM1"
//    property int    selected_port_index: 1
    property bool   showPortSetting: true

    property string serial_port_info_details: ""
    property bool   view_details: false
    property string connection_image_src: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_run_0_port_connect.png"


    border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_serialports_normal_frame.png"
    // Open Close Port Button
    GImageButton{
        id: openCloseComportButton
        width: 70; height: 50;
        anchors.left: serialportNameList.right; anchors.leftMargin: 10
        anchors.top: viewportDetailsChecked.bottom; anchors.topMargin: 20
        text: ""
        imageNormal : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_ports_disconnect.png"
        imagePressed: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
        imageHover  : "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
        Image{
            id: connectedImage
            anchors.fill: parent
            width: 50; height: 35
            source: connection_image_src
            visible: false
        }
        onEntered: dialog_log("* Open or Close Comport *")
        onClicked: {
            if(!_serialLink.isConnected){       // if port is being closed, can update port name
                _serialLink.update_comport_settings(selected_portname);
            }
            _serialLink.open_close_comport();
            if(_serialLink.isConnected) {
                show_popup_message("Port " + selected_portname + " is Opened \n Connecting to gStabi Controller ...")
            }
            else {
                show_popup_message("Port " + selected_portname + " is Closed.")
            }
        }
    }

    GCheckBox{
        id: viewportDetailsChecked
        width: 100
        height: 30
        anchors.top: parent.top; anchors.topMargin: 40
        anchors.left: serialportNameList.right ;    anchors.leftMargin: 0
        checkbox_text: "View port details"
        state: "unchecked"
        onChecked_stateChanged: {
            view_details = checked_state
        }
    }

    GListView{
        id: serialportNameList
        width: 70; height: 100;
        anchors.left: parent.left; anchors.leftMargin: 20;
        anchors.top: parent.top ; anchors.topMargin: 30
        list_header_title: "Serial Ports"
        onClicked: {
            selected_port_index = item_index;
            selected_portname   = item_text;
        }
        onEntered: {
            if(view_details){
                serial_port_info_details = _serialLink.get_selected_port_details(item_index);
                dialog_log(serial_port_info_details)
            }
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

    //[!] this code cause warning when run the app, but it works
    Connections{
        target: _serialLink
        onIsPortListUpdatedChanged: {check_and_set_current_port();}
    }
    Connections{
        target: _mavlink_manager;
        onBoard_connection_stateChanged: {
            if(_mavlink_manager.board_connection_state){
                openCloseComportButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_port_connect.png"
                openCloseComportButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_port_connect.png"
                openCloseComportButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_port_connect.png"
                connectedImage.visible = true;
                gremsy_product_id = _configuration.gremsy_product_id()
//                popup_msg = "gStabi controller is connected"
            }
            else{
                openCloseComportButton.imageNormal  = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_ports_disconnect.png"
                openCloseComportButton.imagePressed = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
                openCloseComportButton.imageHover   = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_ports_disconnect.png"
                connectedImage.visible = false
//                show_popup_message("gStabi controller is disconnected.")
            }
        }
        onHb_pulseChanged: {
            if(_mavlink_manager.hb_pulse)
                connection_image_src =   "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_run_0_port_connect.png"
            else connection_image_src = "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_run_1_port_connect.png"
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
        var no_of_ports = serialportNameList.list_count;
        if(no_of_ports === 0)
        {
            dialog_log("Check Driver for Silicon Labs CP210x USB to UART Bridge is installed then restart application")
            dialog_log("* No Serial Port on your computer *");
        }
        return no_of_ports
    }
    function check_and_set_current_port()
    {
        var no_of_ports = getPortNameList() // update portlist when there is a change
        if(no_of_ports > 0) {
            for(var i=0; i < no_of_ports; i++){
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
    }
}

