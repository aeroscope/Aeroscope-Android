import QtQuick 2.7
import Device_Settings 1.0

Item {
    id:root
    width: 800
    height: 800

    property int trigger_level

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color
    property color bkgnd_color
    property color trace_color

    property bool sample_pnts
    property bool sample_vectors

    property real scale_scrn_res

    Scope_Grid {
        id:scope_grid_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        button_bkgnd_color: root.button_bkgnd_color
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
    }

    Canvas {
        id:scope_data_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        renderStrategy: Canvas.Threaded
        renderTarget: Canvas.Image//Canvas.FramebufferObject <- smoother graphics but doesn't work on my galaxy s5

        function paint_data() {
            // Get drawing context
            var data_context = getContext("2d");
            var spacing = width/(scope.display_pnts - 1);
            var start_index = scope.frame_start_index;
            var subtrig = scope.subtrig;
            var data = scope.scope_frame_data;
            var ellipse_width = 6;
            data_context.save();
            data_context.reset();
            data_context.lineWidth = 3;
            data_context.strokeStyle = root.trace_color;
            data_context.beginPath();

            for ( var count = 0; count < scope.display_pnts; count++)//draw data
            {
                if(count == 0) {
                    data_context.moveTo(count + subtrig/64*spacing, height - data[count + start_index]/255 * height);
                }
                else {
                    data_context.moveTo((count - 1)*spacing + subtrig/64*spacing, height - data[(count - 1) + start_index]/255 * height)
                }

                if(sample_vectors) {
                    data_context.lineTo(count*spacing + subtrig/64*spacing, height - data[count + start_index]/255 * height);
                }
                if(sample_pnts) {
                    data_context.ellipse(count*spacing + subtrig/64*spacing - ellipse_width/2, height - data[count + start_index]/255 * height - ellipse_width/2, ellipse_width, ellipse_width);
                }
            }

            data_context.stroke();
            data_context.restore();
        }

        function clear_data() {
            var data_context = getContext("2d");
            data_context.reset();
        }
    }

    V_Trigger_View {
        anchors.fill: parent
        button_bkgnd_color: root.button_bkgnd_color
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
        bkgnd_color: root.bkgnd_color
        scale_scrn_res: root.scale_scrn_res
    }

    H_Trigger_View {
        anchors.fill: parent
        button_bkgnd_color: root.button_bkgnd_color
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
        bkgnd_color: root.bkgnd_color
        scale_scrn_res: root.scale_scrn_res
    }

    Gnd_View {
        anchors.left: parent.left
        height: parent.height
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
        bkgnd_color: root.bkgnd_color
        trace_color: root.trace_color
        scale_scrn_res: root.scale_scrn_res
    }

    Rectangle {
        id: border_color
        width: parent.width
        height: parent.height
        color: "transparent"
        border.color: root.button_highlight_color
        border.width: 2
    }

    PinchArea {
        anchors.fill: parent

        MultiPointTouchArea {
            anchors.fill: parent
            maximumTouchPoints: 1
            minimumTouchPoints: 1

            touchPoints: TouchPoint {id:point1}

            onGestureStarted: {
                gesture.grab()
            }

            onUpdated: {
                if(Math.abs(point1.previousX - point1.x) > Math.abs(point1.previousY - point1.y))
                {
                    console.log("update trigger time");
                    var window_offset = point1.previousX - point1.x;
                    window_offset = window_offset/root.width;
                    scope.setwindow_pos(window_offset);
                }
                else
                {
                    var offset = point1.previousY - point1.y;
                    offset = offset/root.height;
                    scope.setdc_offset(offset);
                }
            }

        }
        onPinchFinished: {
            root.handle_pinch_event(Math.abs(pinch.angle), pinch.scale)
        }
    }

    Connections {
        target: scope
        onScope_frame_dataChanged: {
                scope_data_canvas.paint_data();
                scope_data_canvas.requestPaint();
        }
    }

    function clear_scope_data()
    {
        scope_data_canvas.clear_data();
        scope_data_canvas.requestPaint();
    }

    function handle_pinch_event(angle, scale)
    {
        if(angle > 45 && angle < 135)
        {
            // console.log("Update Gain");
            if(scale < 1)
            {
                scope.fe_setting_touch_handler(Aero_Settings.INC);
            }
            else
            {
                scope.fe_setting_touch_handler(Aero_Settings.DEC);
            }

        }
        else if(angle < 45 || angle > 135)
        {
            //console.log("Update Time");

            if(scale < 1)
            {
                scope.time_scale_touch_handler(Aero_Settings.INC);
            }
            else
            {
                scope.time_scale_touch_handler(Aero_Settings.DEC);

            }
        }
    }

}


