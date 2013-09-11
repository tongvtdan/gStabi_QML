
import QtQuick 2.0
/**

property int fill_width:      The fill_width that the slider currently has.
property int lowerLimit: The lower limit of the slider.
property int upperLimit: The upper limit of the slider.
*/
Rectangle {
    property double value       : 0
    property double step        : 1
    property int    fill_width  : 0
    property int    lowerLimit  : 0
    property int    upperLimit  : 0
    property int    handle_offset_x: handle.width/2
    property double convert_ratio: (handleMouseArea.drag.maximumX - handleMouseArea.drag.minimumX)/(Math.abs(upperLimit) - Math.abs(lowerLimit))
    property string handle_normal   : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.2_normal_slider_handle.png"
    property string handle_pressed  : "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.2_pressed_slider_handle.png"

    id: background
    color: "#00000000"
    smooth: true
    radius: 0.7*height/2
    border.width: 0.5
    border.color: "cyan"
    implicitHeight: 4; implicitWidth: 300
    Item {
        id: grooveRect
        width: parent.width - parent.border.width
        height: parent.height - parent.border.width
        anchors.centerIn: parent
        clip: true
        Rectangle {
            id: fillRect
            height: parent.height;
            width: (value - lowerLimit)*convert_ratio
            radius: background.radius
            color: "#04ffde"
            opacity: 0.8
            anchors.left: parent.left; anchors.leftMargin: background.border.width/2
        }
    }
    Item {
        id: handle
        height:  25 ; width: 25; anchors.verticalCenter: grooveRect.verticalCenter;
        x: -handle_offset_x + background.border.width + fillRect.width
        Image{
            id: handleReleasedImage
            asynchronous: true
            anchors.fill: parent
            source: handle_normal
//            source: "images/gStabiUI_3.2_normal_slider_handle.png"
        }
        Image{
            id: handlePressedImage
            asynchronous: true
            anchors.fill: parent
            source: handle_pressed
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
            hoverEnabled: true
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: -handle_offset_x + background.border.width
            drag.maximumX: background.width - handle_offset_x - background.border.width
            onPressed: { handlePressedImage.state  = "focus" }
            onReleased: { handlePressedImage.state = "normal"}
            onEntered: handleReleasedImage.source = handle_pressed
            onExited:  handleReleasedImage.source = handle_normal
            onPositionChanged: {
                fill_width = handle.x + handle_offset_x  - background.border.width
                value = lowerLimit + (fill_width )/convert_ratio    //(drag.maximumX - drag.minimumX)*(Math.abs(upperLimit) - Math.abs(lowerLimit));
//                console.log("Handle pos x: "+ handle.x + ", Fill width: " + fill_width +  ", Slider pos: " + value)
            }
        }
    }

}

