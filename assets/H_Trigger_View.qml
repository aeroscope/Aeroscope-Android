import QtQuick 2.0

Item {
    id:root
    width: 1000
    height: 1000

    property int label_text_size: 12
    property int label_height: 50
    property int label_width: 275

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color
    property color bkgnd_color

    property real scale_scrn_res

    Canvas {
        id: horiz_trigger_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        function paint_canvas() {
            // Get drawing context
            var trig_data_context = getContext("2d");
            trig_data_context.reset();
            trig_data_context.beginPath();
            trig_data_context.lineWidth = 2;
            trig_data_context.strokeStyle = "yellow";

            if(scope.rel_window_pos < 0)
            {
                trig_data_context.moveTo(0, 0);
                trig_data_context.lineTo(0, height);
            }
            else if(scope.rel_window_pos > scope.display_pnts)
            {
                trig_data_context.moveTo(width, 0);
                trig_data_context.lineTo(width, height);
            }
            else
            {
                var trig_loc = scope.rel_window_pos * width/(scope.display_pnts - 1);
                trig_data_context.moveTo(trig_loc, 0);
                trig_data_context.lineTo(trig_loc, height);
            }
            trig_data_context.stroke();
            line_timeout.restart();
        }

        function clear_canvas() {
            var trig_data_context = horiz_trigger_canvas.getContext("2d");
            trig_data_context.reset();
        }
    }

    Arrow {
        id: offscreen_arrow_left
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 80
        visible: false
        pen_color: root.button_highlight_color
        rotation: 0
        scale_scrn_res: root.scale_scrn_res
    }

    Arrow {
        id: offscreen_arrow_right
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 80
        visible: false
        pen_color: root.button_highlight_color
        rotation: 180
        scale_scrn_res: root.scale_scrn_res
    }

    Rectangle {
        id: offscreen_time_left
        width: label_width*2
        height: label_height
        border.color: "transparent"
        visible: false
        color: "transparent"
        anchors.left: offscreen_arrow_left.left
        anchors.top: offscreen_arrow_left.bottom

        Label {
            id: offscreen_time_right_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignLeft
            font.pointSize: label_text_size
            color: root.button_highlight_color
            text: scope.time_delay
        }
    }

    Rectangle {
        id: offscreen_time_right
        width: label_width*2
        height: label_height
        border.color: "transparent"
        visible: false
        color: "transparent"
        anchors.right: offscreen_arrow_right.right
        anchors.top: offscreen_arrow_right.bottom

        Label {
            id: offscreen_time_left_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignRight
            font.pointSize: label_text_size
            color: root.button_highlight_color
            text: scope.time_delay
        }
    }

    Trigger_Carrot {
        id: trigger_marker
        width: 40*root.scale_scrn_res
        height: 20*root.scale_scrn_res
        visible: true
        anchors.top: parent.top
        x: scope.rel_window_pos * parent.width/(scope.display_pnts - 1) - width/2;
        scale_scrn_res: root.scale_scrn_res
    }

    Rectangle {
        id: trigger_marker_mask_right
        width: 40*root.scale_scrn_res
        height: 20*root.scale_scrn_res
        color: root.bkgnd_color
        anchors.left: parent.right
        anchors.top: parent.top
    }

    Rectangle {
        id: trigger_marker_mask_left
        width: 40*root.scale_scrn_res
        height: 20*root.scale_scrn_res
        color: root.bkgnd_color
        anchors.right: parent.left
        anchors.top: parent.top
    }

    Connections {
        target: scope
        onRel_window_posChanged: {
            line_timeout.stop();
            if(scope.rel_window_pos < 0)
            {
                offscreen_arrow_left.visible = true;
                offscreen_time_left.visible = true;
                offscreen_arrow_right.visible = false;
                offscreen_time_right.visible = false;
                trigger_marker.visible = false;
            }
            else if(scope.rel_window_pos > scope.display_pnts)
            {
                offscreen_arrow_left.visible = false;
                offscreen_time_left.visible = false;
                offscreen_arrow_right.visible = true;
                offscreen_time_right.visible = true;
                trigger_marker.visible = false;
            }
            else
            {
                offscreen_arrow_left.visible = false;
                offscreen_time_left.visible = false;
                offscreen_arrow_right.visible = false;
                offscreen_time_right.visible = false;
                trigger_marker.visible = true;
            }

            horiz_trigger_canvas.paint_canvas();
            horiz_trigger_canvas.requestPaint();
        }
    }

    Connections {
        target: scope
        onTime_scaleChanged: {
            line_timeout.stop();
            horiz_trigger_canvas.clear_canvas();
            horiz_trigger_canvas.requestPaint();
        }
    }

    Timer {
        id: line_timeout
        interval: 1000 // 1s
        running: true
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            horiz_trigger_canvas.clear_canvas();
            horiz_trigger_canvas.requestPaint();
        }
    }

}
