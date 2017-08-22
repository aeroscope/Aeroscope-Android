import QtQuick 2.5
import Device_Settings 1.0
import QtGraphicalEffects 1.0

Item {
    id: root

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    Image {
        id: batt_image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/batt_images/batt_empty.svg"
        visible: false
    }

    ColorOverlay {
        id: batt_image_ovrly
        anchors.fill: batt_image
        source: batt_image
        color: root.text_color
        visible: false
    }

    Image {
        id: dead_batt
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/batt_images/batt_dead.svg"
        visible: false
    }

    Image {
        id: fully_chrgd_batt
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/batt_images/batt_fullcharge.svg"
        visible: false
    }

    Image {
        id: chrg_image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "qrc:/images/batt_images/batt_charging.svg"
        visible: false
    }

    Connections {
        target: scope
        onBatt_stateChanged: {
            switch(scope.batt_state) {
            case(Aero_Settings.BATT_FULL):
                batt_image.source = "qrc:/images/batt_images/batt_full.svg";
                dead_batt.visible = false;
                break;
            case(Aero_Settings.BATT_MID):
                batt_image.source = "qrc:/images/batt_images/batt_mid.svg";
                dead_batt.visible = false;
                break;
            case(Aero_Settings.BATT_LOW):
                batt_image.source = "qrc:/images/batt_images/batt_low.svg";
                dead_batt.visible = false;
                break;
            case(Aero_Settings.BATT_DEAD):
                batt_image.source = "qrc:/images/batt_images/batt_empty.svg";
                dead_batt.visible = true;
                break;
            default:
                batt_image.source = "qrc:/images/batt_images/batt_empty.svg";
                dead_batt.visible = false;
            }
        }
    }

    Connections {
        target: scope
        onCharge_stateChanged: {
            switch(scope.charge_state) {
            case(Aero_Settings.CHARGING):
                fully_chrgd_batt.visible = false;
                chrg_image.visible = true;
                break;
            case(Aero_Settings.FULL):
                fully_chrgd_batt.visible = true;
                chrg_image.visible = true;
                break;
            case(Aero_Settings.ABSENT):
                chrg_image.visible = false;
                fully_chrgd_batt.visible = false;
                break;
            default:
                chrg_image.visible = false;
                fully_chrgd_batt.visible = false;
            }
        }
    }

    Connections {
        target: scope
        onConnection_stateChanged: {
            if(scope.connection_state == Aero_Settings.DISCONNECTED) {
                batt_image.visible = false;
                batt_image_ovrly.visible = false;
                chrg_image.visible = false;
                dead_batt.visible = false;
                fully_chrgd_batt.visible = false;
            }
        }
    }

    Connections {
        target: scope
        onTelem_update: {
            if((scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) && batt_image.visible == false) {
                batt_image.visible = true;
                batt_image_ovrly.visible = true;
            }

            if((scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) && dead_batt.visible == false && scope.batt_state == Aero_Settings.BATT_DEAD) {
                dead_batt.visible = true;
            }

            if((scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) && chrg_image.visible == false && (scope.charge_state == Aero_Settings.CHARGING || scope.charge_state == Aero_Settings.FULL)) {
                chrg_image.visible = true;
            }

            if((scope.connection_state == Aero_Settings.CONNECTED || scope.connection_state == Aero_Settings.FPGA_OFF) && fully_chrgd_batt.visible == false && scope.charge_state == Aero_Settings.FULL) {
                fully_chrgd_batt.visible = true;
            }

        }
    }

}
