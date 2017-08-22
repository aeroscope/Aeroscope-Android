import QtQuick 2.0

Item {
    id:root
    width: 40
    height: 20
    rotation: 0

    property color pen_color : "red"
    property real scale_scrn_res : 1

    Canvas {
        id:carrot_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        onPaint: {
            var carrot_context = getContext("2d");
            carrot_context.reset();

            carrot_context.beginPath();
            carrot_context.lineWidth = 2;
            carrot_context.strokeStyle = pen_color;
            carrot_context.fillStyle = pen_color;
            carrot_context.moveTo(0, 0);
            carrot_context.lineTo(40 * scale_scrn_res, 0);
            carrot_context.lineTo(20 * scale_scrn_res, 20 * scale_scrn_res);
            carrot_context.lineTo(0, 0);
            carrot_context.fill();

            carrot_context.stroke();
        }
    }
}
