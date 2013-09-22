import QtQuick 2.0

Rectangle{
    id: root
    width: 300; height: 120;
    color: "#e1000000"
    radius: 5
    border.width: 1
    border.color: "#04d6f1"

    MouseArea{
        id: dragConsolWindowArea
        anchors.fill: parent

    }
    GTextStyled{
        id: calibStepsLabel
        text: "Calibration Steps"
        color: "cyan"
        anchors.top: parent.top
        anchors.topMargin: 10
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 14

    }
    Row{
        id: calibSteps
        spacing: 5
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: calibStepsLabel.bottom
        anchors.topMargin: 20
        Rectangle{
            id: step1Finished
            width: 30
            height: 20
            color: _mavlink_manager.accel_calib_steps >= 1? "cyan" : "transparent"
            radius: 1
            border.color: "cyan"; border.width: 1
            GTextStyled{
                color:  _mavlink_manager.accel_calib_steps >= 1 ? "blue" : "red"
                text: "1"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle{
            id: step2Finished
            width: 30
            height: 20
            color: _mavlink_manager.accel_calib_steps >= 2? "cyan" : "transparent"
            radius: 1
            border.color: "cyan"; border.width: 1
            GTextStyled{
                color:  _mavlink_manager.accel_calib_steps >= 2 ? "blue" : "red"
                text: "2"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle{
            id: step3Finished
            width: 30
            height: 20
            color: _mavlink_manager.accel_calib_steps >= 3? "cyan" : "transparent"
            radius: 1
            border.color: "cyan"; border.width: 1
            GTextStyled{
                color:  _mavlink_manager.accel_calib_steps >= 3 ? "blue" : "red"
                text: "3"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle{
            id: step4Finished
            width: 30
            height: 20
            color: _mavlink_manager.accel_calib_steps >= 4? "cyan" : "transparent"
            radius: 1
            border.color: "cyan"; border.width: 1
            GTextStyled{
                color:  _mavlink_manager.accel_calib_steps >= 4 ? "blue" : "red"
                text: "4"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle{
            id: step5Finished
            width: 30
            height: 20
            color: _mavlink_manager.accel_calib_steps >= 5? "cyan" : "transparent"
            radius: 1
            border.color: "cyan"; border.width: 1
            GTextStyled{
                color:  _mavlink_manager.accel_calib_steps >= 5 ? "blue" : "red"
                text: "5"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle{
            id: step6Finished
            width: 30
            height: 20
            color: (_mavlink_manager.accel_calib_steps === 6 )? "cyan" : "transparent"
            radius: 1
            border.color: "cyan"; border.width: 1
            GTextStyled{
                color: _mavlink_manager.accel_calib_steps === 6 ? "blue" : "red"
                text: "6"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Row{
        id: buttonRow
        width: 170
        height: 27
        spacing: 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: calibSteps.bottom
        anchors.topMargin: 15
        GButton{
            id: nextCalibStep
            height: 25
            text:  _mavlink_manager.accel_calib_steps === 6 ? "Finish" : "Next"
            onClicked: {
                if(calib_accel_finished){
                    show_popup_message("*** Calibration Process is DONE ***")
                    root.state = "hideDialog"
                }

                if(_serialLink.isConnected){
                    _mavlink_manager.calib_accel()
                } else show_popup_message("gStabi Controller is disconnected while calibrating accelerometer sensors.\nCheck connection then try again")
            }
        }
//        GButton{
//            id: cancelButton
//            height: 25
//            text: "Cancel"
//            onClicked: {
//                root.state = "hideDialog"
//            }
//        }
    }
    states:[
           State{
               name: "showDialog"
               PropertyChanges { target: root; opacity: 1; scale: 1; z: 100 }
           }
           ,State {
               name: "hideDialog"
               PropertyChanges {target: root; opacity: 0; scale: 0.5; z: -100}
           }

       ]
       transitions: [
           Transition {
               from: "showDialog" ; to:   "hideDialog"
               ParallelAnimation{
                   NumberAnimation { target: root; property: "opacity";  duration: 500; }
                   NumberAnimation { target: root; property: "scale"; duration: 500; easing.type: Easing.Bezier}
               }
           }
           ,Transition {
               from: "hideDialog" ; to: "showDialog"
               ParallelAnimation{
                   NumberAnimation { target: root; property: "opacity"; duration: 500; }
                   NumberAnimation { target: root; property: "scale"; duration: 500; easing.type: Easing.Bezier}
               }

           }
       ]

}

