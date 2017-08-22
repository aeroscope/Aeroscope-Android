import QtQuick 2.5
import Device_Settings 1.0
import QtQuick.Controls 2.1
import QtQuick.Window 2.0

ApplicationWindow {
    id: ascope_screen
    visible: true

    property color labelbordercolor: "transparent"
    property int label_text_size: 12
    property int label_height: 50 * scale_scrn_res
    property int label_width: 250 * scale_scrn_res

    property color button_bkgnd_color: "firebrick"
    property color text_color: "white"
    property color button_highlight_color: "red"
    property color trace_color: "lime"
    property color bkgnd_color: "#282828"

    property real ref_screen_res: 22.1489
    property real curr_screen_res
    property real scale_scrn_res

    Component.onCompleted: {
        curr_screen_res = Screen.pixelDensity;
        scale_scrn_res = curr_screen_res/ref_screen_res;
    }

    background: Rectangle {
        color: ascope_screen.bkgnd_color
        }

    Cntrl_Btns {
        id: scope_btns
        width: 200 * ascope_screen.scale_scrn_res
        height: parent.height
        anchors.right: parent.right
        anchors.top: parent.top
        button_bkgnd_color: ascope_screen.button_bkgnd_color
        text_color: ascope_screen.text_color
        button_highlight_color: ascope_screen.button_highlight_color
        onClear_Trace_Data: scope_data_view.clear_scope_data()
        onSample_pnts: scope_data_view.sample_pnts = enabled
        onSample_vector: scope_data_view.sample_vectors = enabled
        bkgnd_color: ascope_screen.bkgnd_color
        scale_scrn_res: ascope_screen.scale_scrn_res
    }

    Rectangle {
        id: inpt_cpl_rect
        width: label_width/2 * ascope_screen.scale_scrn_res
        height: label_height
        anchors.bottom: scope_data_view.top
        anchors.left: parent.left
        anchors.leftMargin: 20
        border.color: labelbordercolor
        color: ascope_screen.bkgnd_color

        Label {
            id: inpt_cpl_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignLeft
            color: text_color
            font.pointSize: label_text_size
            text: "DC"
        }
    }

    Rectangle {
        id: volt_scale_rect
        width: label_width
        height: label_height
        anchors.bottom: scope_data_view.top
        anchors.left: inpt_cpl_rect.right
        anchors.leftMargin: 10
        border.color: labelbordercolor
        color: ascope_screen.bkgnd_color

        Label {
            id: volt_scale_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignLeft
            color: text_color
            font.pointSize: label_text_size
            text: "1V/div"
        }
    }

    Rectangle {
        id: time_scale_rect
        width: label_width
        height: label_height
        anchors.bottom: scope_data_view.top
        anchors.left: volt_scale_rect.right
        anchors.leftMargin: 10
        border.color: labelbordercolor
        color: ascope_screen.bkgnd_color

        Label {
            id: time_scale_txt
            anchors.centerIn: parent.Center
            horizontalAlignment: Text.AlignLeft
            color: text_color
            font.pointSize: label_text_size
            text: "500ns/div"
        }
    }

//    Fps_Calc {
//        id: fps
//        width: ascope_screen.label_width*2
//        height: ascope_screen.label_height
//        anchors.bottom: scope_data_view.top
//        anchors.left: parent.horizontalCenter
//        labelbordercolor: labelbordercolor
//        label_text_size: label_text_size
//        label_height: label_height
//        label_width: label_width
//        button_bkgnd_color: ascope_screen.button_bkgnd_color
//        text_color: ascope_screen.text_color
//        button_highlight_color: ascope_screen.button_highlight_color
//    }

    Trigger_Slider {
        id: trigger_slider_ctrl
        anchors.right:scope_btns.left
        anchors.rightMargin: 20 * ascope_screen.scale_scrn_res
        anchors.bottom: scope_data_view.bottom
        height: scope_data_view.height
        width: 100*ascope_screen.scale_scrn_res
        button_highlight_color: ascope_screen.button_highlight_color
        button_bkgnd_color: ascope_screen.button_bkgnd_color
    }

    Scope_Canvas {
        id: scope_data_view
        anchors.left: parent.left
        anchors.leftMargin: 25 * ascope_screen.scale_scrn_res
        anchors.right: trigger_slider_ctrl.left
        anchors.rightMargin: 40 * ascope_screen.scale_scrn_res
        anchors.top: parent.top
        anchors.topMargin: 100 * ascope_screen.scale_scrn_res
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25 * ascope_screen.scale_scrn_res
        button_bkgnd_color: ascope_screen.button_bkgnd_color
        text_color: ascope_screen.text_color
        button_highlight_color: ascope_screen.button_highlight_color
        bkgnd_color: ascope_screen.bkgnd_color
        trace_color: ascope_screen.trace_color
        sample_pnts: false
        sample_vectors: true
        scale_scrn_res: ascope_screen.scale_scrn_res
    }

    Batt_Icon {
        id: battery_indicator
        anchors.right: scope_data_view.right
        anchors.bottom: scope_data_view.top
        anchors.bottomMargin: 10 * ascope_screen.scale_scrn_res
        width: 60 * ascope_screen.scale_scrn_res
        height: 30 * ascope_screen.scale_scrn_res
        button_bkgnd_color: ascope_screen.button_bkgnd_color
        text_color: ascope_screen.text_color
        button_highlight_color: ascope_screen.button_highlight_color
    }

    Connections {
        target: scope
        onTime_scaleChanged: {
            time_scale_txt.text = time_scale_to_txt(scope.time_scale);
        }
    }

    Connections {
        target: scope
        onFe_settingChanged: {
            volt_scale_txt.text = gain_scale_to_txt(scope.fe_setting);
        }
    }

    Connections {
        target: Qt.application
        onStateChanged: {
              if(Qt.application.state === Qt.ApplicationActive)
              {
                 scope.connect_last_device();
              }
              else
              {
                 scope.disconnect_device();
              }
           }
    }

    Connections {
        target: scope
        onInput_cplChanged: {
            if(scope.input_cpl == Aero_Settings.DC)
            {
                inpt_cpl_txt.text = "DC";
            }
            else
            {
                inpt_cpl_txt.text = "AC";
            }
        }
    }

    function time_scale_to_txt(tscale)
    {
        var time;

        for(var i = 0; i < time_list.count; i++) {
            var elemCur = time_list.get(i);
            if(tscale === elemCur.setting) {
                time = elemCur.name;
                break;
            }
        }

        return time;
    }

    function gain_scale_to_txt(gsetting)
    {
        var gain;

        for(var i = 0; i < gain_list.count; i++) {
            var elemCur = gain_list.get(i);
            if(gsetting === elemCur.setting) {
                gain = elemCur.name;
                break;
            }
        }

        return gain;
    }

//    Timer {
//        id: fps_timer
//        interval: 1000 // 1s
//        running: true
//        repeat: true
//        onTriggered: {
//           scope.fps_timer_done();
//        }
//    }

    Timer {
        id: sample_settings_timer
        interval: 150
        running: true
        repeat: true
        onTriggered: {
           scope.update_fpga();
        }
    }

    Time_Settings_List {
        id: time_list
    }

    Gain_Settings_List {
        id: gain_list
    }

}


