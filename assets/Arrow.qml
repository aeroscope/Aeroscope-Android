import QtQuick 2.5

Item {
    id:root
    width: 60*scale_scrn_res
    height: 30*scale_scrn_res
    rotation: 0

    property color pen_color : "red"
    property real scale_scrn_res : 1
    property int line_width : 2

    Canvas {
        id:arrow_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        onPaint: {
            var arrow_context = getContext("2d");
            arrow_context.reset();

            arrow_context.beginPath();
            arrow_context.lineWidth = root.line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(0, 15*root.scale_scrn_res);
            arrow_context.lineTo(15*root.scale_scrn_res, 30*root.scale_scrn_res);
            arrow_context.stroke();

            arrow_context.beginPath();
            arrow_context.lineWidth = root.line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(0, 15*root.scale_scrn_res);
            arrow_context.lineTo(15*root.scale_scrn_res, 0);
            arrow_context.stroke();


            arrow_context.beginPath();
            arrow_context.lineWidth = root.line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(0, 15*root.scale_scrn_res);
            arrow_context.lineTo(60*root.scale_scrn_res, 15*root.scale_scrn_res);
            arrow_context.stroke();
        }
    }
}
