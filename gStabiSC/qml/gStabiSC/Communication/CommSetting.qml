import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item{
    property string portname: ""    // used to store portname in getPortNameList()
    property alias selected_portname: portListBox.currentText
    GroupBox{
        id: communicationgroupbox
        flat: false
        title: "Communication"
        width: 300
        height: 250
        anchors.top: parent.top
        anchors.topMargin: 5
        RowLayout{
            id: portRow
            anchors.top: parent.top
            anchors.topMargin: 0
            Layout.fillWidth: parent
            ComboBox{
                id: portListBox
                model: comportList
                onCurrentTextChanged:{
                    _serialLink.update_comport_settings(currentText);
                    console.log(currentText);
                }
            }   // portlistBox
            Button{
                text: { if(_serialLink.isConnected) {
                        return "Close"
                    } else {
                        return "Open"
                    }
                }
                onClicked: {
                    _serialLink.open_close_comport()
                    if(_serialLink.isConnected){
                        text = "Close"
                        consoleLog.text += "Port Opened \n"
                    } else{
                        text = "Open"
                        consoleLog.text += "Port Closed \n"
                    }
                }
            }// comport Open/Close
            Button{
                id: refresshPorts
                text: "Refresh"
                onClicked: getPortNameList()
            }


        }
        TextArea {
            id: consoleLog
            x: 0
            y: 41
            width: 284
            height: 173
            readOnly: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
//            text: _mavlink_manager.hb_pulse? "HB OK \n" : "HB Stop \n"
        }   // portRow
    } // communication GroupBox
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
}
