import QtQuick 2.0

Rectangle {
    width: 300;   height: 200
    color: "transparent"
    border{color: "cyan"; width: 1}
    GListView{
        id: radioType;
        width: 100; height: 150;
        anchors.left: parent.left; anchors.leftMargin: 10;
        anchors.top: parent.top ; anchors.topMargin: 10
        list_header_title: "Control Type"
        Component.onCompleted: {
            radioType.list_model.append({"value": "PPM"});
            radioType.list_model.append({"value": "SBUS"});
            radioType.list_model.append({"value": "gHand"});
            radioType.list_model.append({"value": "PC"});
        }

    }
}
