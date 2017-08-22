import QtQuick 2.5
import QtQuick.Controls 2.1

Item {
    id: root

    property int button_height
    property int button_width
    property string current_ts

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    property real scale_scrn_res

    MyLabelButton {
        width: root.button_width
        height: root.button_height
        buttonLabelText: current_ts
        buttonTitleText: "Horizontal"
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
            border.color: root.button_highlight_color
            radius: 20 * root.scale_scrn_res
        }

        contentItem: Rectangle {
            anchors.fill: parent
            width: pop_background.width
            height: pop_background.height
            radius: pop_background.radius
            color: root.button_bkgnd_color
            ListView {
                id: ts_list
                anchors.fill: parent
                model: Time_Settings_List{}

                headerPositioning: ListView.OverlayHeader

                header: Rectangle {
                    id: headerItem
                    width: ts_list.width
                    height: 20 * root.scale_scrn_res
                    z: 2
                    color: "transparent"
                }

                delegate: Rectangle {
                    id: root_delegate
                    height: 60 * root.scale_scrn_res
                    width: dialog_pop.width
                    color: scope.time_scale === setting ? root.button_highlight_color : "transparent"
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {scope.settime_scale(setting)}

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
