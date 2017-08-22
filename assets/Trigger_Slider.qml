import QtQuick 2.0
import QtQuick.Controls 2.1

Item {
    id:root
    width: 100
    height: 200

    property color button_highlight_color
    property color button_bkgnd_color

    Slider{
        id: trig_slider

        height: parent.height
        width: parent.width
        value: 127
        orientation: Qt.Vertical
        onValueChanged:
        {
            scope.settrigger_level(trig_slider.value)
        }
        from: 0
        to: 255
        snapMode: Slider.SnapAlways

        background: Rectangle {
            anchors.centerIn: parent
            radius: trig_slider.width/8
            height: parent.height
            width: trig_slider.width/4
            color: "gray"
        }

        handle: Rectangle {
            id: trig_handle

            y: trig_slider.topPadding + trig_slider.visualPosition * (trig_slider.availableHeight - width)
            x: trig_slider.leftPadding + trig_slider.availableWidth / 2 - trig_handle.width/2

            height: trig_slider.width
            width: trig_slider.width
            radius: trig_slider.width/2
            border.color: "black"
            color: "red"

        }

    }
}
