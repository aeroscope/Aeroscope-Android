
import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1

Item {
    id: root

    property int cntrl_button_height
    property int cntrl_button_width
    property int ham_button_height
    property int ham_button_width

    property real scale_scrn_res

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color
    property color bkgnd_color

    signal clear_Trace_Data()
    signal sample_vector(bool enabled)
    signal sample_pnts(bool enabled)

    MyImageButton {
        width: root.cntrl_button_width
        height: root.cntrl_button_height
        buttonLabelText: "hamburger menu"
        labelSize: 12
        buttonLabelEn: false
        image_location: "qrc:/images/icons/hamburger.svg"
        anchors.centerIn: parent
        fillColor: root.button_bkgnd_color
        borderColor: root.button_highlight_color
        textColor: root.text_color
        image_overlay_enabled: true
        image_overlay_color: root.text_color
        onButtonClick: dialog_pop.open()
    }

    Popup {
        id: dialog_pop
        x: -width-20
        y: -height
        width: (root.ham_button_width*3 + 100)
        height: (root.ham_button_height*2 + 100)
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        dim: true
        clip: true
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        }

        background: Rectangle {
            id: pop_background
            width:dialog_pop.width
            height: dialog_pop.height
            color: root.bkgnd_color
            radius: 20
        }

        contentItem: Rectangle {
            anchors.fill: pop_background
            width: pop_background.width
            height: pop_background.height
            radius: pop_background.radius
            color: "transparent"
            border.color: root.button_highlight_color

            Rectangle {
                id: grid_bkgrnd
                width: pop_background.width - 20
                height: pop_background.height - 20
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 10
                color:"transparent"

                GridLayout {
                    id: grid
                    columns: 3
                    Layout.margins: 20
                    anchors.centerIn: grid_bkgrnd

                    Gain_Cntrls_Pop {
                        id: gain_cntrl_menu
                        width: root.ham_button_width
                        height: root.ham_button_height
                        button_height: root.ham_button_height
                        button_width: root.ham_button_width
                        current_gain: "1V/div"
                        button_bkgnd_color: root.button_bkgnd_color
                        text_color: root.text_color
                        button_highlight_color: root.button_highlight_color
                        scale_scrn_res: root.scale_scrn_res
                    }

                    Time_Cntrls_Pop {
                        id: time_cntrl_menu
                        width: root.ham_button_width
                        height: root.ham_button_height
                        button_height: root.ham_button_height
                        button_width: root.ham_button_width
                        current_ts: "500ns/div"
                        button_bkgnd_color: root.button_bkgnd_color
                        text_color: root.text_color
                        button_highlight_color: root.button_highlight_color
                        scale_scrn_res: root.scale_scrn_res
                    }

                    Trigger_Menu_Pop {
                        id: trigger_cntrl_menu
                        width: root.ham_button_width
                        height: root.ham_button_height
                        button_height: root.ham_button_height
                        button_width: root.ham_button_width
                        button_bkgnd_color: root.button_bkgnd_color
                        text_color: root.text_color
                        button_highlight_color: root.button_highlight_color
                        scale_scrn_res: root.scale_scrn_res
                    }

                    Connection_Menu {
                        id: connection_btn
                        width: root.ham_button_width
                        height: root.ham_button_height
                        button_height: root.ham_button_height
                        button_width: root.ham_button_width
                        button_label_en: true
                        button_bkgnd_color: root.button_bkgnd_color
                        text_color: root.text_color
                        button_highlight_color: root.button_highlight_color
                        scale_scrn_res: root.scale_scrn_res
                    }

                    Settings_Menu {
                        id: settings_btn
                        width: root.ham_button_width
                        height: root.ham_button_height
                        button_height: root.ham_button_height
                        button_width: root.ham_button_width
                        button_bkgnd_color: root.button_bkgnd_color
                        text_color: root.text_color
                        button_highlight_color: root.button_highlight_color
                        onClear_Data: clear_Trace_Data();
                        onSample_pnts: root.sample_pnts(enabled);
                        onSample_vector: root.sample_vector(enabled);
                    }
                }
            }
        }
    }

    Connections {
        target: scope
        onTime_scaleChanged: {
            time_cntrl_menu.current_ts = time_scale_to_txt(scope.time_scale);
        }
    }

    Connections {
        target: scope
        onFe_settingChanged: {
            gain_cntrl_menu.current_gain = gain_scale_to_txt(scope.fe_setting);
        }
    }
}
