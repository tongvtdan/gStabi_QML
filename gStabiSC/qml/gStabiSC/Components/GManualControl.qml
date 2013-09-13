import QtQuick 2.0

Rectangle {
    id: manualControlSettingsContainer

    property int  control_type_selected: 0


    width: 300;   height: 200
    color: "transparent"
    radius: 5
    border{color: "cyan"; width: 1}
    // Control Type
    GListView{
        id: controlTypeList;
        width: 100; height: 150;
        anchors.left: parent.left; anchors.leftMargin: 10;
        anchors.top: parent.top ; anchors.topMargin: 10
        list_header_title: "Control Type"
        onClicked: {
            control_type_selected = item_index
        }
        Component.onCompleted: {
            controlTypeList.list_model.append({"value": "PPM"});
            controlTypeList.list_model.append({"value": "SBUS"});
            controlTypeList.list_model.append({"value": "gHand"});
            controlTypeList.list_model.append({"value": "PC"});
        }

    }

    GButton{
        id: gHandConnectButton
        text: "Connect >>>"
        anchors.top: controlTypeList.top; anchors.topMargin: 75
        anchors.left: controlTypeList.right
        anchors.leftMargin: 0
        visible: {if(control_type_selected === 2) return true; else return false}
    }

    onControl_type_selectedChanged: _mavlink_manager.control_type = control_type_selected;
    Connections{
        target: _mavlink_manager
        onControl_typeChanged: controlTypeList.current_index = _mavlink_manager.control_type
    }

}
