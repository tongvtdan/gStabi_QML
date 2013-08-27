
import QtQuick 2.0
/**
This file defines a simple slider. Since only seems to support horizontal
gradients the background of the slider is a slightly rotated rectangle
with a gradient that is clipped by a rectangle defining the actual slider
box.

property int fill_width:      The fill_width that the slider currently has.
property int lowerLimit: The lower limit of the slider.
property int upperLimit: The upper limit of the slider.
*/
Rectangle {
    property double value   : 0
    property double step    : 1
    property int fill_width: 0
    property int lowerLimit: 0
    property int upperLimit: 0
    property int  handle_offset_x: handle.width/2

    property double  convert_ratio: (handleMouseArea.drag.maximumX - handleMouseArea.drag.minimumX)/(Math.abs(upperLimit) - Math.abs(lowerLimit))

    id: background
    color: "#00000000"
    smooth: true
//    radius: 2
    border.width: 2
    border.color: "dodgerblue"
    implicitHeight: 20; implicitWidth: 300


    Item {
        id: grooveRect
        width: parent.width - parent.border.width
        height: parent.height - parent.border.width
        anchors.centerIn: parent
        clip: true
        Rectangle {
            id: fillRect
            height: parent.height;
//            width: fill_width
            width: (value - lowerLimit)*convert_ratio
            color: "#04ffde"
            anchors.left: parent.left
            anchors.leftMargin: background.border.width/2
        }
    }

    Item {
        id: handle
        height:  40; width: 40
        x: -handle_offset_x + background.border.width + fillRect.width
        anchors.top: grooveRect.bottom; anchors.topMargin: 0
        Image{
            id: handleReleasedImage
            anchors.fill: parent
            source: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.2_released_slider_handle.png"
        }
        Image{
            id: handlePressedImage
            anchors.fill: parent
            source: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.2_pressed_slider_handle.png"
//            visible: false
            state: "normal"
            states:[
                State {
                    name: "focus"
                    PropertyChanges {target: handlePressedImage; opacity: 1; }
                }
                ,State {
                    name: "normal"
                    PropertyChanges {target: handlePressedImage; opacity: 0; }
                }
            ]
            transitions: [ Transition {
                    from: "focus"
                    to:   "normal"
                    ParallelAnimation{
                        NumberAnimation { target: handlePressedImage; property: "opacity"; duration: 200;  }
                        SequentialAnimation{
                            NumberAnimation{ target: handlePressedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: handlePressedImage; properties: "scale"; to: 0.5; duration: 100;}
                        }
                    }
                },
                Transition{
                    from: "normal"
                    to: "focus"
                    ParallelAnimation{
                        NumberAnimation { target: handlePressedImage; property: "opacity"; duration: 300;  }
                        SequentialAnimation{
                            NumberAnimation{ target: handlePressedImage; properties: "scale"; to: 1.0; duration: 100;}
                            NumberAnimation{ target: handlePressedImage; properties: "scale"; to: 1.5; duration: 100;}
                            NumberAnimation{ target: handlePressedImage; properties: "scale"; to: 1; duration: 100;}

                        }
                    }
                }
            ]
        }
        MouseArea {
            id: handleMouseArea
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: -handle_offset_x + background.border.width
            drag.maximumX: background.width - handle_offset_x - background.border.width
            onPressed: { handlePressedImage.state  = "focus" }
            onReleased: { handlePressedImage.state = "normal"}
            onPositionChanged: {
                fill_width = handle.x + handle_offset_x  - background.border.width
                value = lowerLimit + (fill_width )/convert_ratio    //(drag.maximumX - drag.minimumX)*(Math.abs(upperLimit) - Math.abs(lowerLimit));
                console.log("Handle pos x: "+ handle.x + ", Fill width: " + fill_width +  ", Slider pos: " + value)
            }
        }
    }


}

