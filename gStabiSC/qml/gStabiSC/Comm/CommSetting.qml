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
    property int anchor_topMargin   : 10
    property int anchor_bottomMargin: 10
    property int anchor_leftMargin  : 10
    property int anchor_rightMargin : 10

    implicitHeight: 200
    implicitWidth: 300
    //    MouseArea{
    //        anchors.fill: parent
    //        onClicked: showPortSetting = !showPortSetting
    //    }
    BorderImage {
        id: commBorderImage
        source: "qrc:/images/qml/gStabiSC/images/comport_dialog.png"
        width: 300; height: 200
//        anchors.fill: parent
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }
    ComboBox{
        id: portListBox
        anchors.left: parent.left
        anchors.leftMargin: anchor_leftMargin
        anchors.top: parent.top
        anchors.topMargin: anchor_topMargin
        model: comportList
        style: ComboBoxStyle {
            background: BorderImage {
                source: control.pressed ? "qrc:/images/qml/gStabiSC/images/dropdownlist/selected_dropdownlist.png" : "qrc:/images/qml/gStabiSC/images/dropdownlist/deselected_dropdownlist.png"
//                border.left: 6 ; border.right: 6 ; border.top: 6 ; border.bottom: 6
            }
        }
        //             comboBoxStyle
        onCurrentTextChanged:{
            _serialLink.update_comport_settings(currentText);
            console.log(currentText);
        }
    }   // portlistBox
    Button{
        id: refresshPorts
        anchors.left: portListBox.right
        anchors.leftMargin:0
        anchors.top: portListBox.top
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
        onClicked: {
            comportSettings.visible = false
        }
    } // refresh Button
    Button{
        id: portOpenClose
        text: _serialLink.isConnected? "Close" : "Open"
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: portListBox.top
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

    Image{
        id: terminalLogImage
        width: 280
        height: 130
        source: "qrc:/images/qml/gStabiSC/images/terminal_log.png"
        anchors.horizontalCenter: commBorderImage.horizontalCenter
        anchors.bottom: commBorderImage.bottom
        anchors.bottomMargin: anchor_bottomMargin
    }

    TextArea{
        id: logText
        backgroundVisible: false
        readOnly: true
        anchors.fill: terminalLogImage
        wrapMode: Text.WordWrap
//        text: _mavlink_manager.msg_received
        text: " This is a sample text"
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
