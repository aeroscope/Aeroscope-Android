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
        id: v_trigger_canvas
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

            trig_data_context.lineTo(0, height - scope.trigger_level/255 * height);
            trig_data_context.lineTo(width, height - scope.trigger_level/255 * height);

            trig_data_context.stroke();
            line_timeout.restart();
        }

        function clear_canvas() {
            var trig_data_context = v_trigger_canvas.getContext("2d");
            trig_data_context.reset();
        }
    }

    Trigger_Carrot {
        width: 40*root.scale_scrn_res
        height: 20*root.scale_scrn_res
        rotation: 90
        anchors.right: parent.right
        anchors.rightMargin: -height/2
        y: parent.height - scope.trigger_level/255 * parent.height - height/2
        pen_color: root.button_highlight_color
        scale_scrn_res: root.scale_scrn_res
    }

    Rectangle {
        id: trigger_marker_mask_top
        width: 20*root.scale_scrn_res
        height: 40*root.scale_scrn_res
        color: root.bkgnd_color
        anchors.right: parent.right
        anchors.bottom: parent.top
    }

    Rectangle {
        id: trigger_marker_mask_bottom
        width: 20*root.scale_scrn_res
        height: 40*root.scale_scrn_res
        color: root.bkgnd_color
        anchors.right: parent.right
        anchors.top: parent.bottom
    }

    Connections {
        target: scope
        onTrigger_levelChanged: {
            line_timeout.stop();
            v_trigger_canvas.paint_canvas();
            v_trigger_canvas.requestPaint();
        }
    }

    Timer {
        id: line_timeout
        interval: 1000 // 1s
        running: true
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            v_trigger_canvas.clear_canvas();
            v_trigger_canvas.requestPaint();
        }
    }
}
