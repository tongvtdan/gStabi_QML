import QtQuick 2.0

Item {
    property double  battery_percent: 0

    Rectangle{
        id: batteryIndicatorBorder
        width: 25
        height: 100
        color: "transparent"
        border{ color: "#0c57ee"; width: 2}
        Rectangle {
            id: pole
            width: 10
            height: 5
            color: "#403434"
            border.color: "#334040"; border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: -border.width
        }

        Rectangle{
            id: batteryLevelIndicator
            anchors.centerIn: parent.Center
            width: parent.width - 2*parent.border.width;
            height: battery_percent
            color: "#0ef1e2"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom;  anchors.bottomMargin: parent.border.width
            transformOrigin: Item.Bottom
        }

        GTextStyled {
            id: batteryLevelLabel
            width: 10
            color: "blue"
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
