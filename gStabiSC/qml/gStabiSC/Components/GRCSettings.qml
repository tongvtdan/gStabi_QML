import QtQuick 2.0

Rectangle {
    id: rcSettingsContainer
    property string  title: "Tilt"
    property int    lpf_value   : 5
    property int    trim_value  : 5


    width: 200;     height: 55
    color: "transparent"
    radius: 5
    border.color: "cyan"; border.width: 1
    GTextStyled{
        id: titleText
        text: title;
        anchors.top: parent.top
        anchors.topMargin: -20
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 14; color: "cyan"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

    }
    Row{
        id: lpfRow
        width: 180
        height: 20
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.left: parent.left; anchors.leftMargin: 5
        spacing: 10
        GTextStyled{
            id: lpfLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Smooth"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: lpfSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 80; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: lpf_value
            onValueChanged: lpf_value = lpfSlider.value
        }
        GTextInput{
            id: lpfLevelInput
            bottom_value: 0; top_value: 100
            text_value: lpf_value.toString()
            onText_valueChanged: lpf_value = text_value
        }
    }

    Row{
        id: trimRow
        width: 180
        anchors.top: lpfRow.bottom; anchors.topMargin: 5
        anchors.left: parent.left; anchors.leftMargin: 5
        spacing: 10
        GTextStyled{
            id: trimLabel
            width: 50; height: 20
            color : "#00e3f9"
            font.pixelSize: 12
            text: "Trim"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        GSlider{
            id: trimSlider
            lowerLimit: 0 ; upperLimit: 100
            width: 80; //height: 4
            anchors.verticalCenter: parent.verticalCenter
            value: trim_value
            onValueChanged: trim_value = trimSlider.value
        }
        GTextInput{
            id: trimLevelInput
            bottom_value: 0; top_value: 100
            text_value: trim_value.toString()
            onText_valueChanged: trim_value = text_value
        }
    }


}
