import QtQuick 2.0

Item {
    id: root
    property color labelbordercolor: "transparent"
    property int label_text_size: 12
    property int label_height: 50
    property int label_width: 275

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    Rectangle {
        id: fps_label
        width: root.label_width
        height: root.label_height
        //anchors.bottom: scope_data_view.top
        anchors.left: parent.left
        border.color: root.labelbordercolor
        color: "transparent"

        Label {
            id: fps_label_txt
            anchors.left: parent.left
            horizontalAlignment: Text.AlignRight
            font.pointSize: root.label_text_size
            text: "FPS:"
            color:root.text_color
        }
    }

    Rectangle {
        id: fps_rect
        width: root.label_width
        height: root.label_height
       // anchors.bottom: scope_data_view.top
        anchors.left: fps_label.right
        border.color: root.labelbordercolor
        color: "transparent"

        Label {
            id: fps_txt
            //anchors.centerIn: parent.Center
            anchors.right: parent.right
            horizontalAlignment: Text.AlignLeft
            font.pointSize: root.label_text_size
            text: scope.fps
            color:root.text_color
        }
    }
}
