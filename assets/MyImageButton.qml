import QtQuick 2.3
import QtGraphicalEffects 1.0

Rectangle {
    id:root
    radius: 6
    width: buttonWidth
    height: buttonHeight
    border.width: 2
    border.color: borderColor
    antialiasing: true
    color: fillColor

    property int buttonHeight: 75
    property int buttonWidth: 150

    property color fillColor: "lightblue"
    property color onHoverColor: "Gold"
    property color borderColor: "white"
    property color textColor: "red"
    property string buttonLabelText: "button label"
    property bool buttonLabelEn: true
    property string image_location
    property bool image_overlay_enabled: false
    property color image_overlay_color: "transparent"
    property real image_opacity: 1

    property real labelSize: 14

    signal buttonClick()
    signal buttonReleased()

    onButtonClick: {
        console.log(buttonLabel.text + " clicked");
        root.scale = 1.2;
        root.color = Qt.darker(fillColor, 1.5);
        button_timer.start();
    }

    onButtonReleased: {
    }

    Text{
        id: buttonLabel
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: buttonLabelText
        font.pointSize: labelSize
        color: textColor
        visible: buttonLabelEn
    }

    Image {
        id: button_image
        width: parent.width
        height: (buttonLabelEn == true ? (parent.height - buttonLabel.height) : parent.height)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        fillMode: Image.PreserveAspectFit
        opacity: root.image_opacity
        source: image_location
    }

    ColorOverlay {
        id: button_image_ovrly
        anchors.fill: button_image
        source: button_image
        color: root.image_overlay_color
        opacity: root.image_opacity
        visible: root.image_overlay_enabled
    }



    MouseArea{
        id: buttonMouseArea
        onClicked: buttonClick()
        onReleased: buttonReleased()
        //hoverEnabled: true
        //onEntered: parent.border.color = onHoverColor
        //onExited: parent.border.color = borderColor
        //anchors all sides of the mouse area to the rectangle's anchors
        anchors.fill: parent
        //onclicked handles valid mouse button clicks
    }

    //color: buttonMouseArea.pressed ? Qt.darker(fillColor, 1.5) : fillColor

    Behavior on color { ColorAnimation { duration: 55 } }

    // Scale the button when pressed
    //scale: buttonMouseArea.pressed ? 1.2 : 1.0
    // Animate the scale property change
    Behavior on scale { NumberAnimation { duration: 100 } }

    Timer {
        id: button_timer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
           root.scale = 1.0;
           root.color = fillColor;
        }
    }

}

