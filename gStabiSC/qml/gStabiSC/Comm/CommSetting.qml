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
            PropertyChanges {target: comportSettings; scale: 1.0; opacity: 1; }

        }
        ,State {
            name: "hide"
            PropertyChanges {target: comportSettings; scale: 0.5 ; opacity: 0.5; }
        }

    ]
    transitions: [ Transition {
            from: "show"
            to:   "hide"
            NumberAnimation{ target: comportSettings; properties: "scale"; from: 1.0; to: 0.5; duration: 500}
            NumberAnimation { target: comportSettings; property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
        },
        Transition{
            from: "hide"
            to: "show"
            NumberAnimation { target: comportSettings; properties: "scale" ; from: 0.5; to: 1.0; duration: 500}
            NumberAnimation { target: comportSettings; property: "opacity"; duration: 200; easing.type: Easing.InOutQuad }
        }
    ]
    MouseArea{
        width: parent.width
        height: 30
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        drag.target: parent
        onDoubleClicked: comportSettings.state == "hide"? comportSettings.state = "show" : comportSettings.state = "hide"


    }
    onStateChanged: {
        if(state == "show"){
            getPortNameList()
        }
    }
}
