import QtQuick 2.0

Rectangle{
    id: root
    property string text_value      : "10"
    property int    bottom_value    : 0
    property int    top_value       : 100
    property bool   read_only       : false
    property bool   save_profile    : true;
    property string msg_log: "GProfile"

    width: 300; height: 100
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#06f9d1"
        }

        GradientStop {
            position: 1
            color: "#404142"
        }
    }
    border.width: 1; border.color: "cyan"
    smooth: true;

    /* function dialog_log(_message)
       @brief: put message to log
       @input: _message
       @output: msg_log in HTML format
      */
    function dialog_log(_message){
        msg_log = "<font color=\"yellow\">" + _message+ "</font><br>";
    }

    Rectangle{
        id: container
        border.width: 1; border.color: "cyan"
        color: "#00000000";  smooth: true;
        radius: 0.7*height/2
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 50
        anchors.topMargin: 5
        anchors.fill: parent

        MouseArea{
            id: mouseArea
            anchors.fill: parent; hoverEnabled: true
            onEntered: container.state = "focus"
            onExited:  container.state = "unfocus"
        }

        TextInput {
            id: inputText
            anchors.centerIn: parent
            color : "#0800f9"
            font{ family: "Segoe UI"; bold: true; pixelSize: 16}
            focus: true
            horizontalAlignment: TextInput.AlignHCenter
            Behavior on color {ColorAnimation {duration: 200 }}
            text: "gProfile_Camera7D"
        }

        states: [
            State{
                name: "focus"
                PropertyChanges {target: container; border.color: "#009dff"; border.width: 2}
                PropertyChanges { target: inputText; color: "red"   }
            }
            ,State {
                name: "unfocus"
                PropertyChanges {target: container; border.color: "cyan"; border.width: 1 }
                PropertyChanges { target: inputText; color: "#0800f9"   }

            }
        ]
        Behavior on color {ColorAnimation {duration: 200 }}

    } // end of container
    Row{
        id: buttonsRow
        width: 120
        height: 26
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        GButton{
            id: okButton
            text: "OK"
            onClicked: {
                text_value = inputText.text;
                root.visible = false;
                save_profile = true;
                dialog_log("Saved profile: " + text_value);
            }
        }
        GButton {
            id: cancelButton
            text: "Cancel"
            onClicked: { root.visible = false; save_profile = false; dialog_log("Canceled to save the profile")}
        }
    }
}

