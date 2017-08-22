import QtQuick 2.0

Item {
    id: root
    width: 200
    height: 400

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    signal sample_vector(bool enabled)
    signal sample_pnts(bool enabled)

    property bool sample_pnts_en: false
    property bool sample_vectors_en: true

    Rectangle {
        id: points_area
        width: bkgrnd.width/2
        height: bkgrnd.height
        radius: 10
        anchors.verticalCenter: bkgrnd.verticalCenter
        anchors.left: bkgrnd.left
        color: root.button_bkgnd_color

        Text {
            id: pointslabel_l1
            anchors.horizontalCenter: points_area.horizontalCenter
            anchors.bottom: points_area.verticalCenter
            text: "Show"
            font.pointSize: 12
            color: root.text_color
        }

        Text {
            id: pointslabel_l2
            anchors.horizontalCenter: points_area.horizontalCenter
            anchors.top: points_area.verticalCenter
            text: "Points"
            font.pointSize: 12
            color: root.text_color
        }
    }

    Rectangle {
        id: vector_area
        width: bkgrnd.width/2
        height: bkgrnd.height
        radius: 10
        anchors.verticalCenter: bkgrnd.verticalCenter
        anchors.right: bkgrnd.right
        color: root.text_color

        Text {
            id: vectorlabel_l1
            anchors.horizontalCenter: vector_area.horizontalCenter
            anchors.bottom: vector_area.verticalCenter
            text: "Show"
            font.pointSize: 12
            color: root.button_bkgnd_color
        }

        Text {
            id: vectorlabel_l2
            anchors.horizontalCenter: vector_area.horizontalCenter
            anchors.top: vector_area.verticalCenter
            text: "Vectors"
            font.pointSize: 12
            color: root.button_bkgnd_color
        }
    }

    Rectangle {
        id: lft_mask
        width: 15
        height: bkgrnd.height
        anchors.right: points_area.right
        anchors.verticalCenter: bkgrnd.verticalCenter
        color: {
            if(sample_pnts_en == true)
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
        height: bkgrnd.height
        anchors.left: vector_area.left
        anchors.verticalCenter: bkgrnd.verticalCenter
        color: {
            if(sample_vectors_en == true)
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
        id: bkgrnd
        width: root.width
        height: root.height - 20
        color: "transparent"
        border.color: root.text_color
        border.width: 2
        radius: 10
    }

    MouseArea{
        id: pnts_btn_area
        anchors.fill: points_area
        onClicked: {
            if(sample_vectors_en == false) {
                sample_pnts_en = true;
                points_area.color = root.text_color;
                pointslabel_l1.color = root.button_bkgnd_color;
                pointslabel_l2.color = root.button_bkgnd_color;
            }
            else if(sample_pnts_en == true) {
                sample_pnts_en = false;
                points_area.color = root.button_bkgnd_color;
                pointslabel_l1.color = root.text_color;
                pointslabel_l2.color = root.text_color;
            }
            else if(sample_pnts_en == false) {
                sample_pnts_en = true;
                points_area.color = root.text_color;
                pointslabel_l1.color = root.button_bkgnd_color;
                pointslabel_l2.color = root.button_bkgnd_color;
            }

            sample_pnts(sample_pnts_en);
        }
    }

    MouseArea{
        id: vector_btn_area
        anchors.fill: vector_area
        onClicked: {
            if(sample_pnts_en == false) {
                sample_vectors_en = true;
                vector_area.color = root.text_color;
                vectorlabel_l1.color = root.button_bkgnd_color;
                vectorlabel_l2.color = root.button_bkgnd_color;
            }
            else if(sample_vectors_en == true) {
                sample_vectors_en = false;
                vector_area.color = root.button_bkgnd_color;
                vectorlabel_l1.color = root.text_color;
                vectorlabel_l2.color = root.text_color;
            }
            else if(sample_vectors_en == false) {
                sample_vectors_en = true;
                vector_area.color = root.text_color;
                vectorlabel_l1.color = root.button_bkgnd_color;
                vectorlabel_l2.color = root.button_bkgnd_color;
            }

            sample_vector(sample_vectors_en);
        }
    }

}
