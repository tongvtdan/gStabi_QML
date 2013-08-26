
import QtQuick 2.0
/**
This file defines a simple slider. Since only seems to support horizontal
gradients the background of the slider is a slightly rotated rectangle
with a gradient that is clipped by a rectangle defining the actual slider
box.

property int value:      The value that the slider currently has.
property int lowerLimit: The lower limit of the slider.
property int upperLimit: The upper limit of the slider.
*/
Rectangle {
    property int value: 0
    property int lowerLimit: 0
    property int upperLimit: 0

    id: background
    color: "#00000000"
    smooth: true
    radius: 2
    border.width: 2
    border.color: "cyan"

    Item {
        id: grooveRect
        width: parent.width - 2
        height: parent.height - 2
        anchors.centerIn: parent
        clip: true

        Rectangle {
            id: fillRect
            height: parent.height;  width: value
            color: "#03ff96"
            anchors.left: parent.left
            anchors.leftMargin: 0
//            anchors.verticalCenter: parent.verticalCenter
            border.color: "#08f7d0"
        }
    }

    Image {
        id: handle
        source: "qrc:/images/qml/gStabiSC/Components/images/gStabiUI_3.2_released_slider_handle.png"
        x: 0; y: grooveRect.height
        height: 40 ; width: 40
        MouseArea {
            id: handleMouseArea
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: background.width// - handle.width
//            onPressed: {
//                handle.border.color ="#009dff"
//            }
//            onReleased: {
//                handle.border.color = "cyan"
//            }
            onPositionChanged: {
                value = lowerLimit + parent.x    // (drag.maximumX - drag.minimumX)) * (Math.abs(upperLimit) - Math.abs(lowerLimit))
                console.log("Slider value: " + value)
            }
        }
    }
}
