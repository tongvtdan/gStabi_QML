import QtQuick 2.0

Rectangle {
    id: rcSettingsContainer
    property string title       : "Tilt"
    property int    lpf_value   : 5
    property int    trim_value  : 5
    property int    channel_value: 1
    property int    rc_value: 50


    width: 200;     height: 100
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

    Row{
        id: channelRow
        visible: (control_type_selected === 0 || control_type_selected === 1)
        spacing: 7
        anchors.left: parent.left ;  anchors.leftMargin: 5
        anchors.top: trimRow.bottom ;anchors.topMargin: 20
        GTextStyled{
            text: {
                if (control_type_selected === 0) return "Value";
                else if (control_type_selected === 1) return "Channel";
            }
            anchors.verticalCenter: parent.verticalCenter
            color: "cyan"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 12
        }
        GTextInput{
            id: channelValue
            width: 30
            top_value: 18
            text_value: channel_value.toString()
            read_only: (control_type_selected === 0)

        }
    }

    Item{
        id: rcValueChannel
        visible: (control_type_selected === 0 || control_type_selected === 1)
        anchors.top: trimRow.bottom;  anchors.topMargin: 20
        anchors.left: channelRow.right ;  anchors.leftMargin: 5
        Rectangle{
            id: rcValueChannelIndicatorBorder
            width: 100
            height: 20
            color: "transparent"
            border{ color: "#088bee"; width: 2}
            Rectangle{
                id: rcValueChannelLevelIndicator
                anchors.centerIn: parent.Center
                width: rc_value
                height: rcValueChannelIndicatorBorder.height - 2*rcValueChannelIndicatorBorder.border.width
                color: "#0ef1e2"
                anchors.verticalCenter: parent.verticalCenter
                transformOrigin: Item.Bottom
            }
            GTextStyled {
                id: rcValueChannelLevelLabel
                width: 10
                color: "#035bf3"
                text: (rc_value - 50).toString() // 50 is the offset value
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    onLpf_valueChanged: {
        lpfLevelInput.text_value = lpf_value
        lpfSlider.value = lpf_value
    }
    onTrim_valueChanged: {
        trimLevelInput.text_value = trim_value
        trimSlider.value = trim_value
    }
}
