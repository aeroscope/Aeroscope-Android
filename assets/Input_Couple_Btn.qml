import QtQuick 2.0
import Device_Settings 1.0

Rectangle {
    id: root
    width: 200
    height: 400
    color:button_bkgnd_color

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    Rectangle {
    width: parent.width - 20
    height: parent.height - 20
    anchors.centerIn: parent
    color: "transparent"
    border.color: text_color
    radius: 10

    Rectangle {
        id: dc_area
        width: parent.width/2
        height: parent.height
        radius: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        color: {
            if(scope.input_cpl == Aero_Settings.DC)
            {
                root.text_color;
            }
            else
            {
                "transparent";
            }
        }

        Text {
            id: dclabel
            anchors.centerIn: dc_area
            text: "DC"
            font.pointSize: 12
            color: {
                if(scope.input_cpl == Aero_Settings.DC)
                {
                    root.button_bkgnd_color;
                }
                else
                {
                    root.text_color;
                }
            }
        }
    }

    Rectangle {
        id: ac_area
        width: parent.width/2
        height: parent.height
        radius: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        color: {
            if(scope.input_cpl == Aero_Settings.AC)
            {
                root.text_color;
            }
            else
            {
                "transparent";
            }
        }

        Text {
            id: aclabel
            anchors.centerIn: ac_area
            text: "AC"
            font.pointSize: 12
            color: {
                if(scope.input_cpl == Aero_Settings.AC)
                {
                    root.button_bkgnd_color;
                }
                else
                {
                    root.text_color;
                }
            }
        }
    }

    Rectangle {
        id: lft_mask
        width: 15
        height: parent.height
        anchors.right: dc_area.right
        anchors.verticalCenter: parent.verticalCenter
        color: {
            if(scope.input_cpl == Aero_Settings.DC)
            {
                 root.text_color;
            }
            else
            {
                "transparent";
            }
        }
    }

    Rectangle {
        id: rt_mask
        width: 15
        height: parent.height
        anchors.left: ac_area.left
        anchors.verticalCenter: parent.verticalCenter
        color: {
            if(scope.input_cpl == Aero_Settings.AC)
            {
                 root.text_color;
            }
            else
            {
                "transparent";
            }
        }
    }

    MouseArea{
        id: dc_btn_area
        anchors.fill: dc_area
        onClicked: {
            scope.setinput_cpl(Aero_Settings.DC);
        }
    }

    MouseArea{
        id: ac_btn_area
        anchors.fill: ac_area
        onClicked: {
            scope.setinput_cpl(Aero_Settings.AC);
        }
    }

}
}
