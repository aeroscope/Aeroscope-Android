import QtQuick 2.0

Item {
    id:root
    width: 40
    height: 500

    property int label_text_size: 12
    property int label_height: 50
    property int label_width: 275

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color
    property color bkgnd_color
    property color trace_color

    property real scale_scrn_res

    Gnd_Symb {
        anchors.left: root.left
        y: scope.rel_dc_offset/255*root.height
        pen_color: root.trace_color
        scale_scrn_res: root.scale_scrn_res
        visible: {
            if(scope.rel_dc_offset === 0 || scope.rel_dc_offset === 255) {
                false;
            }
            else {
                true;
            }
        }
    }

    Arrow {
        id: offscreen_arrow_top
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20
        visible: false
        rotation: 90
        pen_color: root.trace_color
        scale_scrn_res: root.scale_scrn_res
    }

    Arrow {
        id: offscreen_arrow_bottom
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        visible: false
        rotation: 270
        pen_color: root.trace_color
        scale_scrn_res: root.scale_scrn_res
    }

    Rectangle {
        id: offscreen_volt_top
        width: label_width*2
        height: label_height
        border.color: "transparent"
        visible: false
        color: "transparent"
        anchors.left: offscreen_arrow_top.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 20

        Label {
            id: offscreen_volt_top_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignLeft
            font.pointSize: label_text_size
            color: root.trace_color
            text: scope.offscrn_offset_val
        }
    }

    Rectangle {
        id: gnd_mask_bottom
        width: 40*root.scale_scrn_res
        height: 46*root.scale_scrn_res
        color: root.bkgnd_color
        anchors.left: parent.left
        anchors.top: parent.bottom
    }

    Rectangle {
        id: offscreen_volt_bot
        width: label_width*2
        height: label_height
        border.color: "transparent"
        visible: false
        color: "transparent"
        anchors.left: offscreen_arrow_bottom.right
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        Label {
            id: offscreen_volt_bot_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignLeft
            font.pointSize: label_text_size
            color: root.trace_color
            text: scope.offscrn_offset_val
        }
    }

    Connections {
        target: scope
        onRel_dc_offsetChanged: {
            if(scope.rel_dc_offset === 255)
            {
                offscreen_arrow_top.visible = false;
                offscreen_volt_top.visible = false;
                offscreen_arrow_bottom.visible = true;
                offscreen_volt_bot.visible = true;
            }
            else if(scope.rel_dc_offset === 0)
            {
                offscreen_arrow_top.visible = true;
                offscreen_volt_top.visible = true;
                offscreen_arrow_bottom.visible = false;
                offscreen_volt_bot.visible = false;
            }
            else
            {
                offscreen_arrow_top.visible = false;
                offscreen_volt_top.visible = false;
                offscreen_arrow_bottom.visible = false;
                offscreen_volt_bot.visible = false;
            }
        }
    }

}
