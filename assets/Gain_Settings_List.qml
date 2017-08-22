import QtQuick 2.0
import Device_Settings 1.0

ListModel {
    id: gain_list_model
    ListElement {
        name: "100mV/div"
        setting: Aero_Settings.FE_100mv
    }
    ListElement
    {
        name: "200mV/div"
        setting: Aero_Settings.FE_200mv
    }
    ListElement
    {
        name: "500mV/div"
        setting: Aero_Settings.FE_500mv
    }
    ListElement
    {
        name: "1V/div"
        setting: Aero_Settings.FE_1v
    }
    ListElement
    {
        name: "2V/div"
        setting: Aero_Settings.FE_2v
    }
    ListElement
    {
        name: "5V/div"
        setting: Aero_Settings.FE_5v
    }
    ListElement
    {
        name: "10V/div"
        setting: Aero_Settings.FE_10v
    }
}
