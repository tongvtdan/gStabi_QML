import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item{
    property string portname: ""    // used to store portname in getPortNameList()
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
                onCurrentTextChanged:  {
                    _serialLink.update_comport_settings(currentText);
                }
            }   // portlistBox
            Button{
                text: "Open"
                onClicked: {
                    if(_serialLink.open_close_comport()){
                        text = "Close"
                    } else{
                        text = "Open"
                    }
                }
            }// comport Open/Close
        }

        TextField {
            id: consoleLog
            x: 0
            y: 41
            width: 284
            height: 173
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            placeholderText: "Text Field"
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
        for(var i=0 ; i < 5 ; i++){
            portname = _serialLink.getPortName(i);
            if(portname !== "NA"){
                comportList.append({"port": portname});
            }
        }
    }
}
