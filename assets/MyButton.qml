import QtQuick 2.3

Rectangle {
    id:button
    radius: 6
    width: buttonWidth
    height: buttonHeight
    border.width: 2
    color: fillColor
    border.color: borderColor
    antialiasing: true

    property int buttonHeight: 75
    property int buttonWidth: 150

    property color fillColor: "lightblue"
    property color onHoverColor: "Gold"
    property color borderColor: "white"
    property color textColor: "red"
    property string buttonLabelText: "button label"

    property real labelSize: 14

    signal buttonClick()
    signal buttonReleased()

    onButtonClick: {
        console.log(buttonLabel.text + " clicked")
        button.scale = 1.2;
        button.color = Qt.darker(fillColor, 1.5);
        button_timer.start();
    }

    onButtonReleased: {
    }

    Text{
        id: buttonLabel
        anchors.centerIn: parent
        text: buttonLabelText
        font.pointSize: labelSize
        color: textColor
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
           button.scale = 1.0;
           button.color = fillColor;
        }
    }

}

