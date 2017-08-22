import QtQuick 2.0
import Device_Settings 1.0
import QtGraphicalEffects 1.0


Rectangle {
    id: root
    border.color: root.text_color
    border.width: 2
    width: 132
    height: 50
    radius: 5
    color: root.button_bkgnd_color

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    Rectangle {
        id: pos_trig_bkgnd
        radius:5
        anchors.fill: pos_trig
        color: root.text_color
    }

    Image {
        id: pos_trig
        height: parent.height
        width: parent.width/3
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/icons/trigger/pos_edge_trig.svg"
        visible: true
        antialiasing: true
    }

    ColorOverlay {
        id: pos_trig_ovrly
        anchors.fill: pos_trig
        source: pos_trig
        color: root.button_bkgnd_color
        visible: true
    }

    Rectangle {
        id: neg_trig_bkgnd
        anchors.fill: neg_trig
        color: "transparent"
    }

    Image {
        id: neg_trig
        height: parent.height
        width: parent.width/3
        anchors.left: pos_trig.right
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/icons/trigger/neg_edge_trig.svg"
        visible: true
        antialiasing: true
    }

    ColorOverlay {
        id: neg_trig_ovrly
        anchors.fill: neg_trig
        source: neg_trig
        color: root.text_color
        visible: true
    }

    Rectangle {
        id: any_trig_bkgnd
        radius:5
        anchors.fill: any_trig
        color: "transparent"
    }

    Image {
        id: any_trig
        height: parent.height
        width: parent.width/3
        anchors.left: neg_trig.right
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/icons/trigger/any_edge_trigger.svg"
        visible: true
        antialiasing: true
    }

    ColorOverlay {
        id: any_trig_ovrly
        anchors.fill: any_trig
        source: any_trig
        color: root.text_color
        visible: true
    }

    Rectangle {
        border.width: 2
        border.color: root.text_color
        color: "transparent"
        width: 2
        height: parent.height
        anchors.left: pos_trig.right
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        border.width: 2
        border.color: root.text_color
        color: "transparent"
        width: 2
        height: parent.height
        anchors.left: neg_trig.right
        anchors.verticalCenter: parent.verticalCenter
    }

    MouseArea{
        id: pos_trig_mouse
        onClicked: {
            scope.settrigger_setting(Aero_Settings.RISING | (scope.trigger_setting & Aero_Settings.AUTO) | (scope.trigger_setting & Aero_Settings.NR))
            //console.log("pos trigger set")
        }
        anchors.fill: pos_trig
    }

    MouseArea{
        id: neg_trig_mouse
        onClicked: {
            scope.settrigger_setting(Aero_Settings.FALLING | (scope.trigger_setting & Aero_Settings.AUTO) | (scope.trigger_setting & Aero_Settings.NR))
            //console.log("neg trigger set")
        }
        anchors.fill: neg_trig
    }

    MouseArea{
        id: any_trig_mouse
        onClicked: {
            scope.settrigger_setting(Aero_Settings.ANY | (scope.trigger_setting & Aero_Settings.AUTO) | (scope.trigger_setting & Aero_Settings.NR))
            //console.log("any trigger set")
        }
        anchors.fill: any_trig
    }

    Connections {
        target: scope
        onTrigger_settingChanged: {
            //console.log("Trigger setting changed new setting = ", scope.trigger_setting," ",scope.trigger_setting & Aero_Settings.RISING);

            if(((scope.trigger_setting & Aero_Settings.RISING) != 0) && ((scope.trigger_setting & Aero_Settings.FALLING) != 0)) {
                pos_trig_bkgnd.color = "transparent";
                pos_trig.opacity = 1;
                pos_trig_ovrly.color = root.text_color;

                neg_trig_bkgnd.color = "transparent";
                neg_trig.opacity = 1;
                neg_trig_ovrly.color = root.text_color;

                any_trig_bkgnd.color = root.text_color;
                any_trig.opacity = 0;
                any_trig_ovrly.color = "transparent";

            }
            else if((scope.trigger_setting & Aero_Settings.FALLING) != 0) {
                pos_trig_bkgnd.color ="transparent";
                pos_trig.opacity = 1;
                pos_trig_ovrly.color = root.text_color;

                neg_trig_bkgnd.color = root.text_color;
                neg_trig.opacity = 0;
                neg_trig_ovrly.color = "transparent";

                any_trig_bkgnd.color = "transparent";
                any_trig.opacity = 1;
                any_trig_ovrly.color = root.text_color;
            }
            else {
                pos_trig_bkgnd.color = root.text_color;
                pos_trig.opacity = 0;
                pos_trig_ovrly.color = "transparent";

                neg_trig_bkgnd.color = "transparent";
                neg_trig.opacity = 1;
                neg_trig_ovrly.color = root.text_color;

                any_trig_bkgnd.color = "transparent";
                any_trig.opacity = 1;
                any_trig_ovrly.color = root.text_color;
            }
        }
    }
}
