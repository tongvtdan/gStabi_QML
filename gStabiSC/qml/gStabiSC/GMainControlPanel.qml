import QtQuick 2.0
import "Components"
import "Controls"
Rectangle {
    id: mainControlPanel
    width: 1000 ;  height: 350
    color: "transparent"
    property int    control_width           : 1000
    property int    control_height          : 250
    property bool   motor_config_enabled    : false
    property bool   motor_control_enabled   : false
    property int    control_selected_index  : 0     // store the current index of control tab selected in taskBar



    state: "GeneralSettings"
    ListModel{
        id: controls
        ListElement{
            name: "General Settings"
            pixmap:  "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_settings.png"
            pixmapfocus:  "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_settings.png"
            stateId: "General Settings"
        }
        ListElement{
            name: "Motor Settings"
            pixmap: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_motors.png"
            pixmapfocus: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_motors.png"
            stateId: "Motor Settings"
        }
        ListElement{
            name: "Controller Settings"
            pixmap: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_pid.png"
            pixmapfocus: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_pid.png"
            stateId: "Controller Settings"
        }
        ListElement{
            name: "IMU Settings"
            pixmap: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_imu.png"
            pixmapfocus: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_imu.png"
            stateId: "IMU Settings"
        }
        ListElement{
            name: "Profile"
            pixmap: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_profile.png"
            pixmapfocus: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_profile.png"
            stateId: "Profile"
        }
        ListElement{
            name: "Realtime Charts"
            pixmap: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_chart.png"
            pixmapfocus: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_chart.png"
            stateId: "Realtime Charts"
        }
        ListElement{
            name: "Information"
            pixmap: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_normal_info.png"
            pixmapfocus: "qrc:/images/qml/gStabiSC/images/buttons/gStabiUI_3.3_focus_info.png"
            stateId: "Information"
        }
    }
    GTaskBar{
        id: taskBar
        width: 600
        height: 80
        anchors.horizontalCenterOffset: -150
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom;
        z: 100
        controlModel: controls
    }
    Rectangle{
        id: controlItemContainer
        width: control_width   ; height: control_height
        anchors.centerIn: parent.Center
        color: "transparent"
        anchors.bottom: taskBar.top
        anchors.bottomMargin: 0
        Item{
            id: controlXPosContainer
            width: control_width; height: control_height
            Item{
                id: generalSettings
                width: control_width; height: control_height
                GGeneralSettings{
                    id: gGeneralSettings
                    anchors.centerIn:   parent
                }
            }
            Item{
                id: motorSettings
                x: (control_width + 100)*1 ; y: 0;
                width: control_width; height: control_height
                GMotorsConfiguration{
                    id: gMotorSettings
                    anchors.centerIn:   parent
                }
            }
            Item{
                id: controllerSettings
                x: ( control_width + 100) * 2 ; y: 0;
                width: control_width; height: control_height
                GControllerParams{
                    id: gControllerParamsSetting
                    anchors.horizontalCenterOffset: 10
                    anchors.centerIn:   parent
                }
            }
            Item{
                id: imuSettings
                x: ( control_width + 100) * 3 ; y: 0;
                width: control_width; height: control_height
                GIMUSettings{
                    id: gImuSettings
                    anchors.centerIn:   parent
                }
            }
            Item{
                id: profileSettings
                x: ( control_width + 100) * 4 ; y: 0;
                width: control_width; height: control_height
                GProfile{
                    id: gProfileSettings
                    anchors.centerIn:   parent
                }
            }
            Item{
                id: realtimeChart
                x: ( control_width + 100) * 5 ; y: 0;
                width: control_width; height: control_height
                GCharts{
                    id: gCharts
                    anchors.centerIn:   parent
                }
            }
            Item{
                id: info
                x: ( control_width + 100) * 6 ; y: 0;
                width: control_width; height: control_height
                GInfo{
                    id: gInfo
                    anchors.centerIn:   parent
                }
            }
        }
    }
    states:[
        State {
            name: "General Settings"
            PropertyChanges { target: controlXPosContainer; x: 0 }
            PropertyChanges { target: generalSettings; opacity: 1; }
            PropertyChanges { target: motorSettings; opacity: 0; }
            PropertyChanges { target: controllerSettings; opacity: 0; }
            PropertyChanges { target: imuSettings; opacity: 0; }
            PropertyChanges { target: profileSettings; opacity: 0; }
            PropertyChanges { target: realtimeChart; opacity: 0; }
            PropertyChanges { target: info; opacity: 0; }
        },
        State {
            name: "Motor Settings"
            PropertyChanges { target: controlXPosContainer; x: -(control_width + 100) * 1 }
            PropertyChanges { target: generalSettings; opacity: 0; }
            PropertyChanges { target: motorSettings; opacity: 1; }
            PropertyChanges { target: controllerSettings; opacity: 0; }
            PropertyChanges { target: imuSettings; opacity: 0; }
            PropertyChanges { target: profileSettings; opacity: 0; }
            PropertyChanges { target: realtimeChart; opacity: 0; }
            PropertyChanges { target: info; opacity: 0; }
        },
        State {
            name: "Controller Settings"
            PropertyChanges { target: controlXPosContainer; x: -(control_width + 100) * 2}
            PropertyChanges { target: generalSettings; opacity: 0; }
            PropertyChanges { target: motorSettings; opacity: 0; }
            PropertyChanges { target: controllerSettings; opacity: 1; }
            PropertyChanges { target: imuSettings; opacity: 0; }
            PropertyChanges { target: profileSettings; opacity: 0; }
            PropertyChanges { target: realtimeChart; opacity: 0; }
            PropertyChanges { target: info; opacity: 0; }
        },
        State {
            name: "IMU Settings"
            PropertyChanges { target: controlXPosContainer; x: -(control_width + 100) * 3 }
            PropertyChanges { target: generalSettings; opacity: 0; }
            PropertyChanges { target: motorSettings; opacity: 0; }
            PropertyChanges { target: controllerSettings; opacity: 0; }
            PropertyChanges { target: imuSettings; opacity: 1; }
            PropertyChanges { target: profileSettings; opacity: 0; }
            PropertyChanges { target: realtimeChart; opacity: 0; }
            PropertyChanges { target: info; opacity: 0; }
        },
        State {
            name: "Profile"
            PropertyChanges { target: controlXPosContainer; x: -(control_width + 100) * 4 }
            PropertyChanges { target: generalSettings; opacity: 0; }
            PropertyChanges { target: motorSettings; opacity: 0; }
            PropertyChanges { target: controllerSettings; opacity: 0; }
            PropertyChanges { target: imuSettings; opacity: 0; }
            PropertyChanges { target: profileSettings; opacity: 1; }
            PropertyChanges { target: realtimeChart; opacity: 0; }
            PropertyChanges { target: info; opacity: 0; }
        },
        State {
            name: "Realtime Charts"
            PropertyChanges { target: controlXPosContainer; x: -(control_width + 100) * 5 }
            PropertyChanges { target: generalSettings; opacity: 0; }
            PropertyChanges { target: motorSettings; opacity: 0; }
            PropertyChanges { target: controllerSettings; opacity: 0; }
            PropertyChanges { target: imuSettings; opacity: 0; }
            PropertyChanges { target: profileSettings; opacity: 0; }
            PropertyChanges { target: realtimeChart; opacity: 1; }
            PropertyChanges { target: info; opacity: 0; }
        },
        State {
            name: "Information"
            PropertyChanges { target: controlXPosContainer; x: -(control_width + 100) * 6}
            PropertyChanges { target: generalSettings; opacity: 0; }
            PropertyChanges { target: motorSettings; opacity: 0; }
            PropertyChanges { target: controllerSettings; opacity: 0; }
            PropertyChanges { target: imuSettings; opacity: 0; }
            PropertyChanges { target: profileSettings; opacity: 0; }
            PropertyChanges { target: realtimeChart; opacity: 0; }
            PropertyChanges { target: info; opacity: 1; }
        }
    ]

    transitions: Transition {
        ParallelAnimation{
            NumberAnimation { properties: "x,y"; duration: 500; easing.type: Easing.InOutCubic }
            NumberAnimation { properties: "opacity"; duration: 250; }
        }
    }
    onStateChanged: {
        dialog_log("Changed to " + state)
    }
    onControl_selected_indexChanged: {
        motor_config_enabled = false    // reset before set if selected
        switch(control_selected_index){
        case 1:
            motor_config_enabled = true
            break;
        default:
            break;
        }
    }


}
