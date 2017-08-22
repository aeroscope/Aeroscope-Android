import QtQuick 2.5
import QtQuick.Controls 2.1
import Device_Settings 1.0

Item {
    id:root
    property int button_height
    property int button_width
    property int trig_button_width: 360 * root.scale_scrn_res
    property int trig_button_height: 120 * root.scale_scrn_res
    property int trig_option_button_width: 120 * root.scale_scrn_res
    property int trig_option_button_height: 120 * root.scale_scrn_res

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    property real scale_scrn_res

    MyButton {
        width: root.button_width
        height: root.button_height
        buttonLabelText: "Trigger"
        labelSize: 12
        fillColor: root.button_bkgnd_color
        borderColor: root.button_highlight_color
        textColor: root.text_color
        anchors.centerIn: parent
        onButtonClick: dialog_pop.open()
    }

    Popup {
        id: dialog_pop
        x: -width
        y: 0
        width: trig_button_width + (2*trig_option_button_width) + (80 * root.scale_scrn_res)
        height: trig_option_button_height + (20 * root.scale_scrn_res)
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
            color: root.button_bkgnd_color
            border.color: root.button_bkgnd_color
            radius: 15 * root.scale_scrn_res
        }

        contentItem: Rectangle {
            anchors.fill: parent
            width: pop_background.width
            height: pop_background.height
            radius: pop_background.radius
            color: "transparent"

            Trig_Sel_Button {
                id: trig_sel
                anchors.left: parent.left
                anchors.leftMargin: 20 * root.scale_scrn_res
                anchors.verticalCenter: parent.verticalCenter
                height: root.trig_button_height
                width: root.trig_button_width
                button_bkgnd_color: root.button_bkgnd_color
                text_color: root.text_color
                button_highlight_color: root.button_highlight_color

            }

            MyImageButton {
                id: auto_trig_btn
                width: root.trig_option_button_width
                height: root.trig_option_button_height
                buttonLabelEn: false
                anchors.left: trig_sel.right
                anchors.leftMargin: 20 * root.scale_scrn_res
                anchors.verticalCenter: parent.verticalCenter
                fillColor: root.button_bkgnd_color
                borderColor: root.text_color
                textColor: root.text_color
                image_location: "qrc:/images/icons/trigger/auto_trigger_sel.png"
                image_overlay_enabled: true
                image_overlay_color: root.text_color
                onButtonClick: {
                    //console.log("Toggle Auto option");
                    scope.toggle_trig_option(Aero_Settings.AUTO);
                }
            }

            MyImageButton {
                id: nr_btn
                width: root.trig_option_button_width
                height: root.trig_option_button_height
                buttonLabelEn: false
                anchors.left: auto_trig_btn.right
                anchors.leftMargin: 20 * root.scale_scrn_res
                anchors.verticalCenter: parent.verticalCenter
                fillColor: root.button_bkgnd_color
                borderColor: root.text_color
                textColor: root.text_color
                image_location: "qrc:/images/icons/trigger/nr_trigger.png"
                image_overlay_enabled: true
                image_overlay_color: root.text_color
                onButtonClick: {
                    //console.log("Toggle NR option");
                    scope.toggle_trig_option(Aero_Settings.NR);
                }
            }
        }
    }

    Connections {
        target: scope
        onTrigger_settingChanged: {

            if((scope.trigger_setting & Aero_Settings.AUTO) != 0) {
                auto_trig_btn.image_location = "qrc:/images/icons/trigger/auto_trigger_sel.png";
            }
            else {
                auto_trig_btn.image_location = "qrc:/images/icons/trigger/auto_trigger.png";
            }

            if((scope.trigger_setting & Aero_Settings.NR) != 0) {
                nr_btn.image_location = "qrc:/images/icons/trigger/nr_trigger_sel.png";
            }
            else {
                nr_btn.image_location = "qrc:/images/icons/trigger/nr_trigger.png";
            }
        }
    }
}
