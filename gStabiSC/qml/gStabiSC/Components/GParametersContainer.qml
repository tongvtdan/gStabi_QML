import QtQuick 2.0

Item{
    id: dialogContainer

    property int    power_level : 50
    property int    poles_num   : 24
    property int    max_value   : 10
    property int    min_value   : -10

//    property string border_normal   : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_parameters_dialog.png"
//    property string border_hover    : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_hover_parameters_dialog.png"
    property string border_normal   : "../images/gStabiUI_3.2_normal_parameters_dialog.png"
    property string border_hover    : "../images/gStabiUI_3.2_hover_parameters_dialog.png"

    implicitWidth: 300; implicitHeight: 200
    BorderImage {
        id: dialogBorderImg
        anchors.fill: parent
        source: border_normal
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        anchors.top: parent.top;
    }
    BorderImage {
        id: dialogHoverBorderImg
        anchors.fill: parent
        source: border_hover
        visible: false
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
        anchors.top: parent.top;
        focus: true
        onFocusChanged: focus? dialogHoverBorderImg.visible = true : dialogHoverBorderImg.visible = false
    }
    Row{
        id: pParamsRow
        width: 300
        anchors.top: dialogBorderImg.top
        anchors.topMargin: 30
        anchors.left: dialogBorderImg.left
        anchors.leftMargin: 20
        spacing: 5
        Text{
            id: pLabel
            width: 20; height: 20
            color : "#d308fb"
            font.family: "Segoe UI"
            font.bold: true
            font.pixelSize: 12
            text: "P:"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: pSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 180; height: 20
            anchors.verticalCenter: parent.verticalCenter
            value: power_level
            onValueChanged: power_level = pSlider.value
        }
        Rectangle{
            width: 45;  height: 20
            color: "#00000000"
            smooth: true
            radius: height/2
            border.width: 1;border.color: "cyan"
            anchors.verticalCenter: parent.verticalCenter
            TextInput {
                id: pInput
                anchors.centerIn: parent
                color : "#00e3f9"
                font.family: "Segoe UI"
                font.bold: true
                font.pixelSize: 16
                text: power_level
                validator: IntValidator{bottom: 0; top: 100;}
                focus: true

            }
        }
    }

    states:[
        State{
            name: "showDialog"
            PropertyChanges { target: dialogContainer; opacity: 1; }
        }
        ,State {
            name: "hideDialog"
            PropertyChanges {target: dialogContainer; opacity: 0;}
        }

    ]
    transitions: [
        Transition {
            from: "showDialog" ; to:   "hideDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity";  duration: 500; }
                NumberAnimation { target: dialogContainer; property: "scale"; to: 0.5; duration: 500; easing.type: Easing.Bezier}
            }
        }
        ,Transition {
            from: "hideDialog" ; to: "showDialog"
            ParallelAnimation{
                NumberAnimation { target: dialogContainer; property: "opacity"; duration: 1000; }
                NumberAnimation { target: dialogContainer; property: "scale"; to: 1; duration: 1000; easing.type: Easing.OutElastic}
            }
        }
    ]
}

