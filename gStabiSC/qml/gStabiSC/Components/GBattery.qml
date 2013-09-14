import QtQuick 2.0

Item {
    property double  battery_percent: 0

//    AnimatedImage{
//        id: batteryLevelAnimaation
//        width: 30
//        height: 140
//        source: "qrc:/images/qml/gStabiSC/images/animation.gif"
//        currentFrame: 10;
//        paused: true
//    }
    Rectangle{
        id: batteryIndicatorBorder
        width: 20
        height: 100
        color: "transparent"
        border{ color: "cyan"; width: 1}
        Rectangle {
            id: pole
            width: 7
            height: 5
            color: "#00000000"
            border.color: "cyan"; border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: -border.width
        }

        Rectangle{
            id: batteryLevelIndicator
            anchors.centerIn: parent.Center
            width: parent.width;
//            height: 50
            height: battery_percent
            color: "#0ef1e2"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            transformOrigin: Item.Bottom
        }

        GTextStyled {
            id: batteryLevelLabel
            x: 15
            y: 36
            width: 10
            color: "green"

            text: battery_percent.toFixed(1).toString()+"%"
            font.pixelSize: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

    }

    function battery_percent_calc(_vol){

    }
    Connections{
        target: _mavlink_manager;
        onBattery_voltageChanged: {
            battery_percent = _mavlink_manager.get_battery_percent_remain(_mavlink_manager.battery_voltage);
        }
    }
}
