import QtQuick 2.0
import "../Components"
Item{
    id: imuMainContainer
    width: 930; height: 250

    property int  gyroTrust_value       : 5
    property int  gyroLpf_value         : 5
    property bool acc_calib_mode_adv  : true
    property bool use_gps_correction    : false
    property bool calib_accel_finished : false


    Row{
        id: imuSettingsRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0
        GFrame{
            id: gyroSettings
            title: "Gyro"
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
                anchors.top: gyroOffsetContainer.bottom; anchors.topMargin: 15
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
                    lowerLimit: 0 ; upperLimit: 255
                    width: 180; //height: 4
                    anchors.verticalCenter: parent.verticalCenter
                    value: gyroTrust_value
                    onValueChanged: gyroTrust_value = value
                }
                GTextInput{
                    id: gyroTrustLevelInput
                    bottom_value: 0; top_value: 255
                    text_value: gyroTrust_value.toString()
                    onText_valueChanged: gyroTrust_value = text_value
                }
            }
            Row{
                id: gyroLpf
                width: 300
                anchors.top: gyroTrust.bottom; anchors.topMargin: 10
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
                    lowerLimit: 0 ; upperLimit: 255
                    width: 180; //height: 4
                    anchors.verticalCenter: parent.verticalCenter
                    value: gyroLpf_value
                    onValueChanged: gyroLpf_value = value
                }
                GTextInput{
                    id: gyroLpfLevelInput
                    bottom_value: 0; top_value: 255
                    text_value: gyroLpf_value.toString()
                    onText_valueChanged: gyroLpf_value = text_value
                }
            }
            GCheckBox{
                id: calibOnStartUpChecked
                checkbox_text: "Calib Gyro on Start up"
                anchors.left: parent.left ;      anchors.leftMargin: 10
                anchors.top: gyroLpf.bottom ;    anchors.topMargin: 10
//                state: "unchecked"
                onChecked_stateChanged: {
                    _mavlink_manager.skip_gyro_calib = checked_state
                }
            }
            GButton{
                id: calibGyroButton
                text: "1.Calib Gyro"
                anchors.top: calibOnStartUpChecked.top;    anchors.topMargin: 0
                anchors.left: calibOnStartUpChecked.right; anchors.leftMargin: 10
                onClicked: {
                    if(_serialLink.isConnected){
                    _mavlink_manager.calib_gyro()
                    } else show_popup_message("gStabi Controller is disconnected!\n\nCheck connection then try again")
                }
            }
        }
        GFrame{
            id: accelSettings
            title: "Accel"
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
                width: Math.max(accCalibModeBasicChecked.width, accCalibModeAdvancedChecked.width) + 10
                height: (accCalibModeBasicChecked.height + accCalibModeAdvancedChecked.height + 10)
                color: "transparent"
                radius: 5
                border.color: "cyan"; border.width: 1
                GCheckBox{
                    id: accCalibModeBasicChecked
                    height: 30
                    checkbox_text: "Basic Mode"
                    anchors.top: parent.top ; anchors.topMargin: 5
                    anchors.left: parent.left;  anchors.leftMargin: 5
                    checked_state: acc_calib_mode_adv
                    onChecked_stateChanged: {
                        acc_calib_mode_adv = !checked_state
                    }
                }
                GCheckBox{
                    id: accCalibModeAdvancedChecked
                    checkbox_text: "Advanced Mode"
                    anchors.top: accCalibModeBasicChecked.bottom ; anchors.topMargin: 5
                    anchors.left: parent.left;  anchors.leftMargin: 5
                    checked_state: !acc_calib_mode_adv
                    onChecked_stateChanged: {
                        acc_calib_mode_adv = checked_state
                    }
                }
            }
            GButton{
                id: calibAccelButton
                text: "2.Calib Accel"
                anchors.top: modeContainer.top;    anchors.topMargin: 0
                anchors.left: modeContainer.right; anchors.leftMargin: 10
                onClicked: {
                    if(_serialLink.isConnected){
                        _mavlink_manager.calib_mode = acc_calib_mode_adv
                        if(acc_calib_mode_adv) {
                            calibStepDialog.state = "showDialog"
                            _mavlink_manager.accel_calib_steps = 0;
                            popupDialog.x = 50;
                            show_popup_message("Calib accelerometer sensors in Advanced mode\n\n" +
                                               "This mode will calib sensors in 06 faces\n\n"+
                                               "Please follow these steps to get good calib results:\n\n"+
                                               "[1]. If sensor module is mounted on your gStabi System, take it out then place it on a surface\n\n"+
                                               "[2]. Click 'Next' button to start calibrating the 1st face\n\n"+
                                               "[3]. Continue the next face by clicking 'Next' button become 'Finish'\n\n"+
                                               "[4]. Continue to the 6th face then 'Next' button become 'Finish'\n\n"+
                                               "[5]. Place the sensor module on a surface, don't move it then Click 'Finish' button\n\n" +
                                               "[6]. Calibration process completed with a pop up message \n\n" +
                                               "Note: You must finish the process once it is started \n\n"+
                                               "      To Restart the process, click on '2.Calib Accel' again  \n"
                                               )
                        }
                        else {
                            _mavlink_manager.calib_accel()
                            show_popup_message("Start to calib accel sensor in basic mode")

                        }
                    } else show_popup_message("gStabi Controller is disconnected.\nCheck connection then try again")

                }
            }
            GCaliAccelDialog{
                id: calibStepDialog
                anchors.horizontalCenter: accelSettings.horizontalCenter
                anchors.bottom: accelSettings.top
                anchors.bottomMargin: 0
                state: "hideDialog"

            }

        }
        GFrame{
            id: gpsSettings
            title: "GPS"
            GCheckBox{
                id: gpsCorrectionChecked
                checkbox_text: "Use GPS Correction"
                anchors.top: gpsSettings.top ; anchors.topMargin: 50
                anchors.left: parent.left;  anchors.leftMargin: 50
                checked_state: use_gps_correction
                onChecked_stateChanged: {
                    _mavlink_manager.use_gps = checked_state

                }
            }
        }
   }
    onAcc_calib_mode_advChanged:  {
        accCalibModeBasicChecked.checked_state      = !acc_calib_mode_adv
        accCalibModeAdvancedChecked.checked_state   = acc_calib_mode_adv
    }
    onGyroTrust_valueChanged: {
        gyroTrustSlider.value = gyroTrust_value;
        gyroTrustLevelInput.text_value = gyroTrust_value
        _mavlink_manager.gyro_trust = gyroTrust_value
    }
    onGyroLpf_valueChanged: {
        gyroLpfSlider.value = gyroLpf_value
        gyroLpfLevelInput.text_value = gyroLpf_value
        _mavlink_manager.gyro_lpf = gyroLpf_value
    }

    Connections{
        target: _mavlink_manager

        onGyro_x_offsetChanged  : xAxisOffsetValueLabel.text_value = _mavlink_manager.gyro_x_offset
        onGyro_y_offsetChanged  : yAxisOffsetValueLabel.text_value = _mavlink_manager.gyro_y_offset
        onGyro_z_offsetChanged  : zAxisOffsetValueLabel.text_value = _mavlink_manager.gyro_z_offset
        onAcc_x_offsetChanged   : accelXAxisOffsetValueLabel.text_value = _mavlink_manager.acc_x_offset
        onAcc_y_offsetChanged   : accelYAxisOffsetValueLabel.text_value = _mavlink_manager.acc_y_offset
        onAcc_z_offsetChanged   : accelZAxisOffsetValueLabel.text_value = _mavlink_manager.acc_z_offset
        onSkip_gyro_calibChanged: calibOnStartUpChecked.checked_state   = _mavlink_manager.skip_gyro_calib;
        onUse_gpsChanged        : gpsCorrectionChecked.checked_state    = _mavlink_manager.use_gps
        onGyro_trustChanged     : gyroTrust_value = _mavlink_manager.gyro_trust
        onGyro_lpfChanged       : gyroLpf_value = _mavlink_manager.gyro_lpf
        onAccel_calib_stepsChanged: {
            if(_mavlink_manager.accel_calib_steps === 6)  calib_accel_finished = true;
            if(_mavlink_manager.accel_calib_steps !== 0)  calibAccelButton.enabled = false;
            else calibAccelButton.enabled = true;
        }
    }


}
