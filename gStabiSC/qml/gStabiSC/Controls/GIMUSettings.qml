import QtQuick 2.0
import "../Components"
Item{
    id: imuMainContainer
    width: 930; height: 250

    property int  gyroTrust_value   : 5
    property int  gyroLpf_value     : 5
    property bool calib_normal_mode : true
    property bool use_gps_correction: false


    Row{
        id: motorsParamsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0
        GFrame{
            id: gyroSettings
            border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_gyro_normal_frame.png"
            GTextStyled{
                id: gyroFrameLabel
                text: "Offset"
                anchors.horizontalCenter: gyroOffsetContainer.horizontalCenter
                font.pixelSize: 12
                anchors.top: parent.top
                anchors.topMargin: 20
                color: "cyan"

            }
            Rectangle{
                id: gyroOffsetContainer
                anchors.top: gyroFrameLabel.bottom; anchors.topMargin: 0
                color: "transparent"
                width: 150; height: 50; radius: 5
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "cyan"; border.width: 1
                Row{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    Column{
                        id: xAxisColumn
                        GTextStyled{
                            id: xAxisLabel
                            text: "X"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 12
                            color: "cyan"
                        }
                        GTextInput{
                            id: xAxisOffsetValueLabel
                            read_only: true;
                        }
                    }
                    Column{
                        id: yAxisColumn
                        GTextStyled{
                            id: yAxisLabel
                            text: "Y"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 12
                            color: "cyan"
                        }
                        GTextInput{
                            id: yAxisOffsetValueLabel
                            read_only: true;
                        }
                    }
                    Column{
                        id: zAxisColumn
                        GTextStyled{
                            id: zAxisLabel
                            text: "Z"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 12
                            color: "cyan"
                        }
                        GTextInput{
                            id: zAxisOffsetValueLabel
                            read_only: true;
                        }
                    }
                }
            }
            Row{
                id: gyroTrust
                width: 300
                anchors.top: gyroOffsetContainer.bottom; anchors.topMargin: 20
                anchors.left: parent.left ; anchors.leftMargin: 10
                spacing: 5
                GTextStyled{
                    id: gyroTrustLabel
                    width: 55; height: 20
                    color : "#00e3f9"
                    font.pixelSize: 12
                    text: "Gyro Trust"
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                GSlider{
                    id: gyroTrustSlider
                    lowerLimit: 0 ; upperLimit: 100
                    width: 180; //height: 4
                    anchors.verticalCenter: parent.verticalCenter
                    value: gyroTrust_value
                    onValueChanged: gyroTrust_value = gyroTrustSlider.value
                }
                GTextInput{
                    id: gyroTrustLevelInput
                    bottom_value: 0; top_value: 100
                    text_value: gyroTrust_value.toString()
                    onText_valueChanged: gyroTrust_value = text_value
                }
            }
            Row{
                id: gyroLpf
                width: 300
                anchors.top: gyroTrust.bottom; anchors.topMargin: 20
                anchors.left: parent.left ; anchors.leftMargin: 10
                spacing: 5
                GTextStyled{
                    id: gyroLpfLabel
                    width: 55; height: 20
                    color : "#00e3f9"
                    font.pixelSize: 12
                    text: "Gyro Lpf"
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                GSlider{
                    id: gyroLpfSlider
                    lowerLimit: 0 ; upperLimit: 100
                    width: 180; //height: 4
                    anchors.verticalCenter: parent.verticalCenter
                    value: gyroLpf_value
                    onValueChanged: gyroLpf_value = gyroLpfSlider.value
                }
                GTextInput{
                    id: gyroLpfLevelInput
                    bottom_value: 0; top_value: 100
                    text_value: gyroLpf_value.toString()
                    onText_valueChanged: gyroLpf_value = text_value
                }
            }
            GCheckBox{
                id: calibOnStartUpChecked
                checkbox_text: "Calib Gyro on Start up"
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: gyroLpf.bottom
                anchors.topMargin: 10
            }
            GButton{
                id: calibGyroButton
                text: "Calib Gyro"
                anchors.top: calibOnStartUpChecked.top;    anchors.topMargin: 0
                anchors.left: calibOnStartUpChecked.right; anchors.leftMargin: 10
            }
        }
        GFrame{
            id: accelSettings
            border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_accel_normal_frame.png"
            GTextStyled{
                id: accelFrameLabel
                text: "Offset"
                anchors.horizontalCenter: accelOffsetContainer.horizontalCenter
                font.pixelSize: 12
                anchors.top: parent.top
                anchors.topMargin: 20
                color: "cyan"

            }
            Rectangle{
                id: accelOffsetContainer
                anchors.top: accelFrameLabel.bottom; anchors.topMargin: 0
                color: "transparent"
                width: 150; height: 50; radius: 5
                anchors.horizontalCenter: parent.horizontalCenter
                border.color: "cyan"; border.width: 1
                Row{
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    Column{
                        id: accelXAxisColumn
                        GTextStyled{
                            id: accelXAxisLabel
                            text: "X"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 12
                            color: "cyan"
                        }
                        GTextInput{
                            id: accelXAxisOffsetValueLabel
                            read_only: true;
                        }
                    }
                    Column{
                        id: accelYAxisColumn
                        GTextStyled{
                            id: accelYAxisLabel
                            text: "Y"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 12
                            color: "cyan"
                        }
                        GTextInput{
                            id: accelYAxisOffsetValueLabel
                            read_only: true;
                        }
                    }
                    Column{
                        id: accelZAxisColumn
                        GTextStyled{
                            id: accelZAxisLabel
                            text: "Z"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 12
                            color: "cyan"
                        }
                        GTextInput{
                            id: accelZAxisOffsetValueLabel
                            read_only: true;
                        }
                    }
                }
            }
            Rectangle{
                id: modeContainer
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: accelOffsetContainer.bottom; anchors.topMargin: 20
                width: Math.max(calibNormal.width, calib6Faces.width) + 10
                height: (calibNormal.height + calib6Faces.height + 10)
                color: "transparent"
                radius: 5
                border.color: "cyan"; border.width: 1
                GCheckBox{
                    id: calibNormal
                    height: 30
                    checkbox_text: "Basic Mode"
                    anchors.top: parent.top ; anchors.topMargin: 5
                    anchors.left: parent.left;  anchors.leftMargin: 5
                    checked_state: calib_normal_mode
                    onChecked_stateChanged: {
                        calib_normal_mode = checked_state
                    }
                }
                GCheckBox{
                    id: calib6Faces
                    checkbox_text: "Advanced Mode"
                    anchors.top: calibNormal.bottom ; anchors.topMargin: 5
                    anchors.left: parent.left;  anchors.leftMargin: 5
                    checked_state: !calib_normal_mode
                    onChecked_stateChanged: {
                        calib_normal_mode = !checked_state
                    }
                }
            }
            GButton{
                id: calibAccelButton
                text: "Calib Accel"
                anchors.top: modeContainer.top;    anchors.topMargin: 0
                anchors.left: modeContainer.right; anchors.leftMargin: 10
            }
        }
        GFrame{
            id: gpsSettings
            border_normal: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.3_gps_normal_frame.png"
            GCheckBox{
                id: gpsCorrectionChecked
                checkbox_text: "Use GPS Correction"
                anchors.top: gpsSettings.top ; anchors.topMargin: 50
                anchors.left: parent.left;  anchors.leftMargin: 50
                checked_state: use_gps_correction
                onChecked_stateChanged: {
                    use_gps_correction = checked_state
                }
            }
        }
   }
    onCalib_normal_modeChanged:  {
        calibNormal.checked_state = calib_normal_mode
        calib6Faces.checked_state = !calib_normal_mode
    }

}
