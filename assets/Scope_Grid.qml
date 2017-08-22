import QtQuick 2.0

Item {
    id:root
    width: 500
    height: 500
    //color:"transparent"

    property int dash_spacing: 5
    property int dash_length: 3

    property color button_bkgnd_color
    property color text_color
    property color button_highlight_color

    Canvas {
        id:scope_grid_canvas
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        onPaint: {
            // Get drawing context
            var context = getContext("2d");

            // Make canvas all white
            context.beginPath();
            context.clearRect(0, 0, width, height);
            context.fill();

            // Fill inside with black
            context.beginPath();
            context.fillStyle = "black"
            context.fillRect(0, 0, width, height);
            context.fill();

            // Horizontal Axis
            context.beginPath();
            context.lineWidth = 2;
            context.moveTo(0, height/2);
            context.strokeStyle = root.button_highlight_color
            context.lineTo(width, height/2);
            context.stroke();

            //Vertical Axis
            context.beginPath();
            context.lineWidth = 2;
            context.moveTo(width/2, 0);
            context.strokeStyle = root.button_highlight_color
            context.lineTo(width/2, height);
            context.stroke();

            for ( var x_minor = 1; x_minor < 50; x_minor++)//horizontal axis minor lines
            {
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(x_minor*(width)/50, height/2 - 5);
                context.strokeStyle = root.button_highlight_color
                context.lineTo(x_minor*(width)/50, height/2 + 5);
                if(x_minor % 5 != 0)
                {
                    context.stroke();
                }
            }

            for ( var x = 1; x < 10; x++)//horizontal axis major lines
            {
                context.beginPath();
                context.lineWidth = 2;
                context.strokeStyle = root.button_highlight_color
                context.moveTo(x*(width)/10, 0);

                var num_h_dashes = height/(dash_length + dash_spacing);
                var start_y = 0;

                if(x != 5)
                {
                    for (var h_dash = 0; h_dash < (num_h_dashes); h_dash++)
                    {
                        context.lineTo(x*(width)/10, start_y + dash_length);
                        context.moveTo(x*(width)/10, start_y + dash_length + dash_spacing);
                        start_y = start_y + dash_length + dash_spacing;
                    }

                context.stroke();
                }
            }

            for ( var y_minor = 1; y_minor < 40; y_minor++)//Vertical axis minor lines
            {
                context.beginPath();
                context.lineWidth = 2;
                context.moveTo(width/2 - 5, y_minor*(height)/40);
                context.strokeStyle = root.button_highlight_color
                context.lineTo(width/2 + 5, y_minor*(height)/40);
                if(y_minor % 5 != 0)
                {
                    context.stroke();
                }
            }

            for ( var y = 1; y < 8; y++)//Vertical axis major lines
            {
                context.beginPath();
                context.lineWidth = 2;
                context.strokeStyle = root.button_highlight_color
                context.moveTo(0, y*(height)/8);

                var num_v_dashes = width/(dash_length + dash_spacing);
                var start_x = 0;

                if(y != 4)
                {
                    for (var v_dash = 0; v_dash < (num_v_dashes); v_dash++)
                    {
                        context.lineTo(start_x + dash_length, y*(height)/8);
                        context.moveTo(start_x + dash_length + dash_spacing, y*(height)/8);
                        start_x = start_x + dash_length + dash_spacing;
                    }

                context.stroke();
                }
            }


        }
    }
}
