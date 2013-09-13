import QtQuick 2.0
import "../Components"

GContainer{
    id: generalSettings
    width: 600; height: 220

   property string  msg_log: ""

    Rectangle{
        id: borderRect
        anchors.fill: parent
        color: "transparent"
        border{ color: "cyan"; width: 1       }
        GSerialSettings{
            id: serialPortSettings
            width: 200
            height: 200
            anchors.left: parent.left; anchors.leftMargin: 10
            anchors.top:    parent.top; anchors.topMargin: 10
            onMsg_logChanged: generalSettings.msg_log = msg_log
        }
        GManualControl{
            anchors.left: serialPortSettings.right; anchors.leftMargin: 10
            anchors.top: parent.top; anchors.topMargin: 10
        }
    }
    function dialog_log(_message){
         msg_log = _message+ "\n";
    }
}
