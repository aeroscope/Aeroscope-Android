import QtQuick 2.0
import Device_Settings 1.0

Rectangle {
    id: root
    border.color: root.button_highlight_color
    border.width: 2
    width: 100
    height: 200
    radius: 5
    color: root.button_bkgnd_color

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color
    property real scale_scrn_res

    Rectangle {
        id: run_stop_area
        radius: 5
        width: root.width - root.border.width*2
        height: root.height/2 - root.border.width
        anchors.top: root.top
        anchors.topMargin: root.border.width
        anchors.horizontalCenter: root.horizontalCenter
        color: root.button_bkgnd_color
    }

    Text {
        id: active_run_state
        anchors.top: run_stop_area.top
        anchors.topMargin: 15 * root.scale_scrn_res
        anchors.horizontalCenter: run_stop_area.horizontalCenter
        text: "Stop"
        font.pointSize: 14
        color: root.text_color
    }

    Text {
        id: inactive_run_state
        anchors.top: active_run_state.bottom
        anchors.topMargin: 10 * root.scale_scrn_res
        anchors.horizontalCenter: run_stop_area.horizontalCenter
        text: "Run"
        font.pointSize: 8
        color: Qt.darker(root.text_color, 1.2)
    }

    Rectangle {
        id:run_stop_area_mask
        width: root.width - root.border.width*2
        height: 20 * root.scale_scrn_res
        color: root.button_bkgnd_color
        anchors.bottom: run_stop_area.bottom
        anchors.horizontalCenter: run_stop_area.horizontalCenter
    }

    Rectangle {
        id: single_area
        radius: 5
        width: root.width - root.border.width*2
        height: root.height/2 - root.border.width
        anchors.bottom: root.bottom
        anchors.bottomMargin: root.border.width
        anchors.horizontalCenter: root.horizontalCenter
        color: scope.scope_run_state == Aero_Settings.SINGLE ? root.button_highlight_color : root.button_bkgnd_color;
    }

    Rectangle {
        id:single_area_mask
        width: root.width - root.border.width*2
        height: 20 * root.scale_scrn_res
        color: scope.scope_run_state == Aero_Settings.SINGLE ? root.button_highlight_color : root.button_bkgnd_color;
        anchors.top: single_area.top
        anchors.horizontalCenter: single_area.horizontalCenter
    }

    Text {
        id: single_text
        anchors.centerIn: single_area
        text: "Single"
        font.pointSize: 12
        color: root.text_color
    }

    Rectangle {
        id: border_rect
        border.color: root.text_color
        width: root.width
        height: 2
        color: root.text_color
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }

    MouseArea {
        id: run_stop_area_mouse
        anchors.fill: run_stop_area
        onClicked: {
            if(scope.scope_run_state === Aero_Settings.STOP) {
                scope.setscope_state(Aero_Settings.RUN)
            }
            else {
                scope.setscope_state(Aero_Settings.STOP);
            }
        }
    }

    MouseArea {
        id: single_area_mouse
        anchors.fill: single_area
        onClicked: {
            scope.setscope_state(Aero_Settings.SINGLE);
        }
    }

    Connections {
        target: scope
        onScope_stateChanged: {
            if(scope.scope_run_state === Aero_Settings.RUN || scope.scope_run_state === Aero_Settings.SINGLE) {
                run_stop_area.color = root.button_highlight_color;
                run_stop_area_mask.color = root.button_highlight_color;
                active_run_state.text = "Run";
                inactive_run_state.text = "Stop";
            }
            else {
                run_stop_area.color = root.button_bkgnd_color;
                run_stop_area_mask.color = root.button_bkgnd_color;
                active_run_state.text = "Stop";
                inactive_run_state.text = "Run";
            }
        }
    }


}
