import QtQuick 2.5
import QtQuick.Controls 2.1

Item {
    id: root

    property int button_height
    property int button_width
    property string current_gain

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    property real scale_scrn_res


    MyLabelButton {
        width: root.button_width
        height: root.button_height
        buttonLabelText: current_gain
        buttonTitleText: "Vertical"
        labelSize: 12
        titleSize: 10
        anchors.centerIn: parent
        fillColor: root.button_bkgnd_color
        borderColor: root.button_highlight_color
        textColor: root.text_color
        onButtonClick: dialog_pop.open()
    }

    Popup {
        id: dialog_pop
        x: -width
        y: -height/2
        width: 500 * root.scale_scrn_res
        height: 600 * root.scale_scrn_res
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
            radius: 20 * root.scale_scrn_res
        }

        contentItem: Rectangle {
            anchors.fill: pop_background
            width: pop_background.width
            height: pop_background.height
            radius: pop_background.radius
            color: "transparent"

            Input_Couple_Btn {
                id: input_cpl_btn
                width: pop_background.width - 2
                height: root.button_height/2
                anchors.top: parent.top
                anchors.topMargin: 15 * root.scale_scrn_res
                anchors.horizontalCenter: parent.horizontalCenter
                button_bkgnd_color: root.button_bkgnd_color
                button_highlight_color: root.button_highlight_color
                text_color: root.text_color
                z: 5
            }

            ListView {
                id: gain_list
                anchors.top: input_cpl_btn.bottom
                anchors.topMargin: 10 * root.scale_scrn_res
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - input_cpl_btn.height
                model: Gain_Settings_List{}

                delegate: Rectangle {
                    id: root_delegate
                    height: 60 * root.scale_scrn_res
                    width: dialog_pop.width - 2
                    color: scope.fe_setting === setting ? root.button_highlight_color : "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {scope.setfe_setting(setting)}

                    }
                    Text {
                        id:delegate_text
                        anchors.centerIn: parent
                        color: root.text_color
                        text: name
                    }
                }

            }
        }
    }
}
