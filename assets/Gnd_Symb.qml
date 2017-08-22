import QtQuick 2.5

Item {
    id:root
    width: 40*scale_scrn_res
    height: 46*scale_scrn_res
    rotation: 0

    property color pen_color : "limegreen"
    property real scale_scrn_res
    property int line_width: 2

    Canvas {
        id:arrow_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        onPaint: {
            var arrow_context = getContext("2d");
            arrow_context.reset();

            arrow_context.beginPath();
            arrow_context.lineWidth = line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(0, line_width/2);
            arrow_context.lineTo(20*root.scale_scrn_res, line_width/2);
            arrow_context.stroke();

            arrow_context.beginPath();
            arrow_context.lineWidth = line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(20*root.scale_scrn_res, line_width/2);
            arrow_context.lineTo(20*root.scale_scrn_res, 20*root.scale_scrn_res);
            arrow_context.stroke();


            arrow_context.beginPath();
            arrow_context.lineWidth = line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(0, 20*root.scale_scrn_res);
            arrow_context.lineTo(40*root.scale_scrn_res, 20*root.scale_scrn_res);
            arrow_context.stroke();

            arrow_context.beginPath();
            arrow_context.lineWidth = line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(10*root.scale_scrn_res, 30*root.scale_scrn_res);
            arrow_context.lineTo(30*root.scale_scrn_res, 30*root.scale_scrn_res);
            arrow_context.stroke();

            arrow_context.beginPath();
            arrow_context.lineWidth = line_width;
            arrow_context.strokeStyle = pen_color;
            arrow_context.moveTo(20*root.scale_scrn_res, 40*root.scale_scrn_res);
            arrow_context.lineTo(20*root.scale_scrn_res, 46*root.scale_scrn_res);
            arrow_context.stroke();
        }
    }
}
