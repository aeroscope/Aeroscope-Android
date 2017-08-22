import QtQuick 2.5
import QtQuick.Controls 2.1
import Device_Settings 1.0
//import QtQml.Models 2.2
//import QtQuick.Dialogs 1.2

Item {
    id:root
    property int button_height
    property int button_width
    property int setting_button_height: 150
    property int setting_button_width: 150

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    signal clear_Data()
    signal sample_vector(bool enabled)
    signal sample_pnts(bool enabled)

    MyImageButton {
        width: root.button_width
        height: root.button_height
        buttonLabelEn: true
        buttonLabelText: "Settings"
        labelSize: 12
        anchors.centerIn: parent
        image_location: "qrc:/images/icons/settings/settings_3x.png"
        fillColor: root.button_bkgnd_color
        borderColor: root.button_highlight_color
        textColor: root.text_color
        image_overlay_enabled: true
        image_overlay_color: root.text_color
        onButtonClick: {
            dialog_pop.open();
        }
    }

    Popup {
        id: dialog_pop
        x: -width
        y: -(2*root.button_height + 40)
        width: 2*root.button_width + 60
        height: root.button_height * 3 + 80
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
            //anchors.centerIn: parent
            color: root.button_bkgnd_color
            border.color: root.button_bkgnd_color
            radius: 15
        }

        contentItem: Rectangle {
            id: list_content
            anchors.fill: parent
            width: pop_background.width
            height: pop_background.height
            radius: pop_background.radius
            color: "transparent"

            Flickable {
                anchors.fill: list_content
                contentWidth: list_content.width
                contentHeight: root.button_height * 10


                MyButton {
                    id: clear_trace_btn
                    width: root.button_width*2
                    height: root.button_height/2
                    buttonLabelText: "Clear Trace"
                    labelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 50
                    fillColor: root.button_bkgnd_color
                    borderColor: root.text_color
                    textColor: root.text_color
                    onButtonClick: {clear_Data();}
                }

                MyButton {
                    id: cal_btn
                    width: root.button_width*2
                    height: root.button_height/2
                    buttonLabelText: "Calibrate"
                    labelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: clear_trace_btn.bottom
                    anchors.topMargin: 20
                    fillColor: root.button_bkgnd_color
                    borderColor: root.text_color
                    textColor: root.text_color
                    onButtonClick: scope.cal_scope()
                }

                MyButton {
                    id: clear_cal_btn
                    width: root.button_width*2
                    height: root.button_height/2
                    buttonLabelText: "Clear Cal Data"
                    labelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: cal_btn.bottom
                    anchors.topMargin: 20
                    fillColor: root.button_bkgnd_color
                    borderColor: root.text_color
                    textColor: root.text_color
                    onButtonClick: scope.clear_cal()
                }

                MyButton {
                    id: reset_btn
                    width: root.button_width*2
                    height: root.button_height/2
                    buttonLabelText: "Reset Hardware"
                    labelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: clear_cal_btn.bottom
                    anchors.topMargin: 20
                    fillColor: root.button_bkgnd_color
                    borderColor: root.text_color
                    textColor: root.text_color
                    onButtonClick: scope.scope_reset()
                }

                MyButton {
                    id: deep_sleep_btn
                    width: root.button_width*2
                    height: root.button_height/2
                    buttonLabelText: "Deep Sleep"
                    labelSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: reset_btn.bottom
                    anchors.topMargin: 20
                    fillColor: root.button_bkgnd_color
                    borderColor: root.text_color
                    textColor: root.text_color
                    onButtonClick: scope.deep_sleep()
                }

                Points_Vectors_Btn {
                    id: pnts_vctrs_btn
                    width: root.button_width*2
                    height: root.button_height*0.8
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: deep_sleep_btn.bottom
                    anchors.topMargin: 20
                    onSample_pnts: root.sample_pnts(enabled)
                    onSample_vector: root.sample_vector(enabled)
                    button_bkgnd_color: root.button_bkgnd_color
                    text_color: root.text_color
                    button_highlight_color: root.button_highlight_color
                }
            }
        }
    }
}
