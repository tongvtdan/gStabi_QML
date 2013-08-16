import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.0


Item{
    id: comportSettings
    property string portname: ""    // used to store portname in getPortNameList()
    property alias selected_portname: portListBox.currentText
    property bool portUpdated: _serialLink.isPortListUpdated
    property bool showPortSetting: true
    MouseArea{
        anchors.fill: parent
        onClicked: showPortSetting = !showPortSetting
    }

    ColumnLayout{
        id: portRow
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 10
        Layout.fillWidth: parent
        ComboBox{
            id: portListBox
            width: 115
            height: 30
//            anchors.left: parent.left
//            anchors.leftMargin: 0
//            anchors.verticalCenter: parent.verticalCenter
            model: comportList
            style: ComboBoxStyle {}
            onCurrentTextChanged:{
                _serialLink.update_comport_settings(currentText);
                console.log(currentText);
            }
        }   // portlistBox
        Button{
            id: portOpenClose
            y: -25
            width: 672
            height: 30
            text: _serialLink.isConnected? "Close" : "Open"
//            anchors.left: portListBox.right
//            anchors.leftMargin: 0
//            anchors.verticalCenter: parent.verticalCenter
            style: ButtonStyle{}
            onClicked: {
                _serialLink.open_close_comport()
            }
        }// comport Open/Close
        Button{
            id: refresshPorts
            width: 50
            height: 25
//            text: "Refresh"
            anchors.top: portOpenClose.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 0
            style: ButtonStyle{
                background: BorderImage {
                    source: control.pressed ? "qrc:/images/qml/gStabiSC/images/buttons/good_button_active.png" : "qrc:/images/qml/gStabiSC/images/buttons/good_button_inactive.png"
                    border.left: 4 ; border.right: 4 ; border.top: 4 ; border.bottom: 4
                }
                label: Text{
                    color: "white"
                    text: "Refresh"
                    anchors.centerIn: control.center
                }
            }

            onClicked: {
                getPortNameList()
            }
        }
    } // portRow
    Label{
        id: logText
        anchors.top: portRow.bottom
        anchors.topMargin: 10
//        anchors.left: parent.left
        width: 222
        height: 150
        color: "#ee1212"
        text: _mavlink_manager.msg_received
        anchors.left: parent.left
        anchors.leftMargin: 0
        styleColor: "#0af9ea"
        wrapMode: Text.WordWrap
    }


    //    } // communication GroupBox
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
    states:[
        State {
            name: "show"
            when: (showPortSetting == true)
            PropertyChanges {
                target: comportSettings
                x: 0

            }
        }
        ,State {
            name: "hide"
            when: (showPortSetting == false)
            PropertyChanges {
                target: comportSettings
                x: -200
            }
        }

    ]
    transitions: Transition {
        PropertyAnimation{
            properties: "x"
            easing.type: Easing.Bezier
        }
    }

}
