import QtQuick 2.0
import Device_Settings 1.0

Item {

    id:root
    width: 300
    height: 1000

    property color labelbordercolor: "transparent"
    property int label_text_size: 12
    property int label_height: 50
    property int label_width: 275
    property int cntrl_button_height: {150*scale_scrn_res}
    property int cntrl_button_width: {150*scale_scrn_res}
    property int ham_button_height: {250*scale_scrn_res}
    property int ham_button_width: {250*scale_scrn_res}
    property real scale_scrn_res

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color
    property color bkgnd_color

    signal clear_Trace_Data()
    signal sample_vector(bool enabled)
    signal sample_pnts(bool enabled)

    Run_Stop_Btn {
        id: scope_run_stop
        width: root.cntrl_button_width
        height: root.cntrl_button_height * 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: root.top
        anchors.topMargin: 50
        button_bkgnd_color: root.button_bkgnd_color
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
        scale_scrn_res: root.scale_scrn_res
    }

    Connection_Menu {
        id: connection_btn
        width: root.cntrl_button_width
        height: root.cntrl_button_height
        button_label_en: false
        button_height: root.cntrl_button_height
        button_width: root.cntrl_button_width
        button_bkgnd_color: root.button_bkgnd_color
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: hamburger.top
        anchors.bottomMargin: 20
        scale_scrn_res: root.scale_scrn_res
    }

    Hamburger_Menu {
        id: hamburger
        width: root.cntrl_button_width
        height: root.cntrl_button_height
        cntrl_button_height: root.cntrl_button_height
        cntrl_button_width: root.cntrl_button_width
        ham_button_height: root.ham_button_height
        ham_button_width: root.ham_button_width
        button_bkgnd_color: root.button_bkgnd_color
        text_color: root.text_color
        button_highlight_color: root.button_highlight_color
        bkgnd_color: root.bkgnd_color
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: root.bottom
        anchors.bottomMargin: 50
        onClear_Trace_Data: root.clear_Trace_Data();
        onSample_pnts: root.sample_pnts(enabled);
        onSample_vector: root.sample_vector(enabled);
        scale_scrn_res: root.scale_scrn_res
    }

}
