import QtQuick 2.0

BorderImage{
    id: rootContainer
    asynchronous: true
    // variables for P
    property int  p_value   : 45
    property int  p_min     : 0;
    property int  p_max     : 255;
    // variables for i
    property int  i_value   : 12
    property int  i_min     : 0;
    property int  i_max     : 255;
    // variables for d
    property int  d_value   : 25
    property int  d_min     : 0;
    property int  d_max     : 255;
    // variables for follow
    property int  follow_value   : 30
    property int  follow_min     : 0;
    property int  follow_max     : 255;
    // variables for filter
    property int  filter_value   : 54
    property int  filter_min     : 0;
    property int  filter_max     : 255;

    property string text_color: "cyan"

    // uncomment these lines to use resources
    property string border_normal   : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_tilt_normal_frame.png"
    property string border_hover    : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_hover_frame.png"

    width: 320; height: 230;
    source: border_normal
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered: borderHover.visible = true
        onExited: borderHover.visible = false

    }
    BorderImage {
        id: borderHover
        source: border_hover
        asynchronous: true
        visible: false
        anchors.fill: parent
    }
    Column{
        // p parameters
        id: paramsColumn
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.fill: parent
        spacing: 20
        Row{
            id: pParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -20
            spacing: 10
            GTextStyled{
                id: pLabel
                width: 20; height: 20
                color: text_color
                font.pixelSize: 16
                text: "P"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: pSlider
                lowerLimit: p_min ; upperLimit: p_max
                width: 180;// height: 20;
                anchors.verticalCenter: parent.verticalCenter
                value: p_value
                onValueChanged: { p_value = value; }
            }
            GTextInput{
                id: pValueInput
                bottom_value: p_min; top_value: p_max;
                text_value: p_value.toString()
                onText_valueChanged: p_value = text_value
            }
        }

        // i parameters
        Row{
            id: iParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -20
            spacing: 10
            GTextStyled{
                id: iLabel
                width: 20; height: 20
                //            color : "#00e3f9"
                color: text_color
                font.pixelSize: 16
                text: "I"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: iSlider
                lowerLimit: i_min ; upperLimit: i_max
                width: 180; //height: 20;
                anchors.verticalCenter: parent.verticalCenter
                value: i_value
                onValueChanged: { i_value = value; }
            }
            GTextInput{
                id: iValueInput
                bottom_value: i_min; top_value: i_max;
                text_value: i_value.toString()
                onText_valueChanged: i_value = text_value
            }
        }
        // d parameters
        Row{
            id: dParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -20
            spacing: 10
            GTextStyled{
                id: dLabel
                width: 20; height: 20
                //            color : "#00e3f9"
                color: text_color
                font.pixelSize: 16
                text: "D"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: dSlider
                lowerLimit: d_min ; upperLimit: d_max
                width: 180;// height: 20;
                anchors.verticalCenter: parent.verticalCenter
                value: d_value
                onValueChanged: { d_value = value; }
            }
            GTextInput{
                id: dValueInput
                bottom_value: d_min; top_value: d_max;
                text_value: d_value.toString()
                onText_valueChanged: d_value = text_value
            }
        }
        // follow parameters
        Row{
            id: followParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -20
            spacing: 10
            GTextStyled{
                id: followLabel
                width: 20; height: 20
                color: text_color
                //            color : "#00e3f9"
                font.pixelSize: 12
                text: "Follow"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: followSlider
                lowerLimit: follow_min ; upperLimit: follow_max
                width: 180;// height: 20;
                anchors.verticalCenter: parent.verticalCenter
                value: follow_value
                onValueChanged: { follow_value = value; }
            }
            GTextInput{
                id: followValueInput
                bottom_value: follow_min; top_value: follow_max;
                text_value: follow_value.toString()
                onText_valueChanged: follow_value = text_value
            }
        }

        // filter parameters
        Row{
            id: filterParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -20
            spacing: 10
            GTextStyled{
                id: filterLabel
                width: 20; height: 20
                //            color : "#00e3f9"
                color: text_color
                font.pixelSize: 12
                text: "Response"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: filterSlider
                lowerLimit: filter_min ; upperLimit: filter_max
                width: 180; //height: 20;
                anchors.verticalCenter: parent.verticalCenter
                value: filter_value
                onValueChanged: { filter_value = value; }
            }
            GTextInput{
                id: filterValueInput
                bottom_value: filter_min; top_value: filter_max;
                text_value: filter_value.toString()
                onText_valueChanged: filter_value = text_value
            }
        }
    }
    onP_valueChanged: {pSlider.value = p_value; pValueInput.text_value = p_value}
    onI_valueChanged: {iSlider.value = i_value; iValueInput.text_value = i_value}
    onD_valueChanged: {dSlider.value = d_value; dValueInput.text_value = d_value}
    onFollow_valueChanged: {followSlider.value = follow_value; followValueInput.text_value = follow_value}
    onFilter_valueChanged: {filterSlider.value = filter_value; filterValueInput.text_value = filter_value}

}

