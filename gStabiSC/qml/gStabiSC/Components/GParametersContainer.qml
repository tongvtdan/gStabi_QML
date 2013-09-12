import QtQuick 2.0

GContainer{
    id: rootContainer
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

    property string text_color: "white"

    // uncomment these lines to use resources
//    property string border_normal   : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_normal_controller_params_frame.png"
//    property string border_hover    : "qrc:/images/qml/gStabiSC/images/gStabiUI_3.2_hover_controller_params_frame.png"

    //    property string border_normal   : "../images/gStabiUI_3.2_normal_parameters_dialog.png"
    //    property string border_hover    : "../images/gStabiUI_3.2_hover_parameters_dialog.png"
    width: 300; height: 200;    Column{
        // p parameters
        id: paramsColumn
        anchors.fill: parent
        spacing: 20
        Row{
            id: pParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -10
            spacing: 10
            TextStyled{
                id: pLabel
                width: 20; height: 20
                color: text_color
                font.pixelSize: 16
                text: "P:"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: pSlider
                lowerLimit: p_min ; upperLimit: p_max
                width: 180;// height: 20;
                anchors.verticalCenter: parent.verticalCenter
                onValueChanged: { p_value = value; }
            }
            GTextInput{
                id: pValueInput
                bottom_value: p_min; top_value: p_max;
                onText_valueChanged: p_value = text_value
            }
        }

        // i parameters
        Row{
            id: iParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -10
            spacing: 10
            TextStyled{
                id: iLabel
                width: 20; height: 20
                //            color : "#00e3f9"
                color: text_color
                font.pixelSize: 16
                text: "I:"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: iSlider
                lowerLimit: i_min ; upperLimit: i_max
                width: 180; //height: 20;
                anchors.verticalCenter: parent.verticalCenter
                onValueChanged: { i_value = value; }
            }
            GTextInput{
                id: iValueInput
                bottom_value: i_min; top_value: i_max;
                onText_valueChanged: i_value = text_value
            }
        }
        // d parameters
        Row{
            id: dParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -10
            spacing: 10
            TextStyled{
                id: dLabel
                width: 20; height: 20
                //            color : "#00e3f9"
                color: text_color
                font.pixelSize: 16
                text: "D:"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: dSlider
                lowerLimit: d_min ; upperLimit: d_max
                width: 180;// height: 20;
                anchors.verticalCenter: parent.verticalCenter
                onValueChanged: { d_value = value; }
            }
            GTextInput{
                id: dValueInput
                bottom_value: d_min; top_value: d_max;
                onText_valueChanged: d_value = text_value
            }
        }
        // follow parameters
        Row{
            id: followParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -10
            spacing: 10
            TextStyled{
                id: followLabel
                width: 20; height: 20
                color: text_color
                //            color : "#00e3f9"
                font.pixelSize: 12
                text: "Follow:"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: followSlider
                lowerLimit: follow_min ; upperLimit: follow_max
                width: 180;// height: 20;
                anchors.verticalCenter: parent.verticalCenter
                onValueChanged: { follow_value = value; }
            }
            GTextInput{
                id: followValueInput
                bottom_value: follow_min; top_value: follow_max;
                onText_valueChanged: follow_value = text_value
            }
        }

        // filter parameters
        Row{
            id: filterParamsRow
            width: 300
            anchors.right: parent.right;anchors.rightMargin: -10
            spacing: 10
            TextStyled{
                id: filterLabel
                width: 20; height: 20
                //            color : "#00e3f9"
                color: text_color
                font.pixelSize: 12
                text: "Smooth:"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            GSlider{
                id: filterSlider
                lowerLimit: filter_min ; upperLimit: filter_max
                width: 180; //height: 20;
                anchors.verticalCenter: parent.verticalCenter
                onValueChanged: { filter_value = value; }
            }
            GTextInput{
                id: filterValueInput
                bottom_value: filter_min; top_value: filter_max;
                onText_valueChanged: filter_value = text_value
            }
        }
    }
    onP_valueChanged: {pSlider.value = p_value; pValueInput.text_value = p_value}
    onI_valueChanged: {iSlider.value = i_value; iValueInput.text_value = i_value}
    onD_valueChanged: {dSlider.value = d_value; dValueInput.text_value = d_value}
    onFollow_valueChanged: {followSlider.value = follow_value; followValueInput.text_value = follow_value}
    onFilter_valueChanged: {filterSlider.value = filter_value; filterValueInput.text_value = filter_value}

    states:[
        State{
            name: "showDialog"
            PropertyChanges { target: rootContainer; opacity: 1; }
        }
        ,State {
            name: "hideDialog"
            PropertyChanges {target: rootContainer; opacity: 0;}
        }

    ]
    transitions: [
        Transition {
            from: "showDialog" ; to:   "hideDialog"
            ParallelAnimation{
                NumberAnimation { target: rootContainer; property: "opacity";  duration: 500; }
                NumberAnimation { target: rootContainer; property: "scale"; to: 0.5; duration: 500; easing.type: Easing.Bezier}
            }
        }
        ,Transition {
            from: "hideDialog" ; to: "showDialog"
            ParallelAnimation{
                NumberAnimation { target: rootContainer; property: "opacity"; duration: 1000; }
                NumberAnimation { target: rootContainer; property: "scale"; to: 1; duration: 1000; easing.type: Easing.OutElastic}
            }
        }
    ]
}

