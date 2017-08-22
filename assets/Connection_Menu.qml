import QtQuick 2.5
import QtQuick.Controls 2.1
import Device_Settings 1.0
//import QtQml.Models 2.2
//import QtQuick.Dialogs 1.2

Item {
    id: root
    property int button_height
    property int button_width

    property real scale_scrn_res

    property bool button_label_en: true

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    MyImageButton {
        width: root.button_width
        height: root.button_height
        buttonLabelText: "Connection"
        buttonLabelEn: root.button_label_en
        labelSize: 12
        anchors.centerIn: parent
        image_location: "qrc:/images/wireless.png"
        fillColor: root.button_bkgnd_color
        borderColor: root.button_highlight_color
        textColor: root.text_color
        image_overlay_enabled: true
        image_overlay_color: root.text_color
        image_opacity: (scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) ? 1 : 0.3
        onButtonClick: {
            dialog_pop.open();
            scope.start_bt_scan();
        }
    }

    Popup {
        id: dialog_pop
        x: -width
        y: -height/2
        width: 700 * root.scale_scrn_res
        height: 400 * root.scale_scrn_res
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        dim: true
        clip: true
        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
        }
        onClosed: {
            scope.stop_bt_scan();
        }

        background: Rectangle {
            id: pop_background
            width:dialog_pop.width
            height: dialog_pop.height
            color: root.button_bkgnd_color
            border.color: root.button_bkgnd_color
            radius: 20
        }

        contentItem: Rectangle {
            anchors.fill: parent
            width: pop_background.width
            height: pop_background.height
            radius: pop_background.radius
            color: root.button_bkgnd_color

            ListView {
                id: connection_list
                anchors.fill: parent
                model: scope.devicesList

                headerPositioning: ListView.OverlayHeader

                header:
                    Rectangle {
                    id: headerItem
                    width: connection_list.width
                    height: 100 * root.scale_scrn_res
                    z: 2
                    color: "transparent"
                    radius: pop_background.radius

                    Rectangle {

                        anchors.fill: parent
                        color: root.button_bkgnd_color
                        radius: parent.radius

                        Text {
                            id:disconnect_button
                            anchors.centerIn: parent
                            color: Qt.darker(root.text_color, 2);
                            opacity: 0.75
                            text: "Disconnect"
                            horizontalAlignment: Text.AlignLeft
                            font.pointSize: 12
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                disconnect_button.color = Qt.darker(root.text_color, 2);
                                disconnect_button.opacity = 0.75;
                                scope.disconnect_device();
                                scope.forget_last_device();
                            }
                        }
                    }

                    Connections {
                        target: scope
                        onConnection_stateChanged: {
                            if(scope.connection_state == Aero_Settings.DISCONNECTED) {
                                disconnect_button.color = Qt.darker(root.text_color, 2);
                                disconnect_button.opacity = 0.75;
                            }
                            else {
                                disconnect_button.color = root.text_color;
                                disconnect_button.opacity = 1.0;
                            }
                        }
                    }
                }

                delegate: Rectangle {
                    id: root_delegate
                    height: 60
                    width: dialog_pop.width
                    color: ((scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) && (scope.connected_device(modelData.deviceAddress) === true)) ? root.button_highlight_color : "transparent";

                    Text {
                        id:delegate_text
                        anchors.centerIn: parent
                        color: root.text_color
                        text: modelData.deviceName
                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            delegate_text.color = Qt.darker(root.text_color, 2);
                            scope.scan_services(modelData.deviceAddress);
                        }
                    }

                    Connections {
                        target: scope
                        onConnection_stateChanged: {
                            if(scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) {
                                delegate_text.color = root.text_color;
                            }
                        }
                    }
                }
            }
        }
    }
}
