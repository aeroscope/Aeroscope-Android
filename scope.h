#ifndef SCOPE_H
#define SCOPE_H

#include <QObject>
#include "device.h"
#include "settings.h"

//class Device;
QT_FORWARD_DECLARE_CLASS(Device)

class Scope : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Settings::con_state connection_state READ connection_state NOTIFY connection_stateChanged)
    Q_PROPERTY(Settings::scope_state scope_run_state READ getscope_state WRITE setscope_state NOTIFY scope_stateChanged)
    Q_PROPERTY(QString fpga_rev READ getfpga_rev NOTIFY fpga_revChanged)
    Q_PROPERTY(QString fw_rev READ getfw_rev NOTIFY fw_revChanged)
    Q_PROPERTY(QString hwid READ gethwid NOTIFY hwidChanged)
    Q_PROPERTY(QString serial_num READ getserial_num NOTIFY serial_numChanged)
    Q_PROPERTY(Settings::chrge_state charge_state READ getcharge_state NOTIFY charge_stateChanged)
    Q_PROPERTY(Settings::batt_state batt_state READ getbatt_state NOTIFY batt_stateChanged)
    Q_PROPERTY(quint8 batt_level READ getbatt_level NOTIFY batt_levelChanged)
    Q_PROPERTY(QString temperature READ gettemperature NOTIFY temperatureChanged)
    Q_PROPERTY(QString fps READ getfps NOTIFY fpsChanged)

    Q_PROPERTY(Settings::fe_mode fe_setting READ getfe_setting WRITE setfe_setting NOTIFY fe_settingChanged)
    Q_PROPERTY(Settings::dc_mode input_cpl READ getinput_cpl WRITE setinput_cpl NOTIFY input_cplChanged)
    Q_PROPERTY(Settings::time_scale time_scale READ gettime_scale WRITE settime_scale NOTIFY time_scaleChanged)
    Q_PROPERTY(quint8 trigger_level READ gettrigger_level WRITE settrigger_level NOTIFY trigger_levelChanged)
    Q_PROPERTY(quint8 trigger_setting READ gettrigger_setting WRITE settrigger_setting NOTIFY trigger_settingChanged)
    Q_PROPERTY(qint16 rel_window_pos READ getrel_window_pos NOTIFY rel_window_posChanged)
    Q_PROPERTY(quint8 frame_start_index READ getframe_start_index NOTIFY time_scaleChanged)
    Q_PROPERTY(quint8 subtrig READ getsubtrig NOTIFY scope_frame_dataChanged)
    Q_PROPERTY(quint16 display_pnts READ getdisplay_pnts NOTIFY time_scaleChanged)
    Q_PROPERTY(QString time_delay READ gettime_delay NOTIFY time_delayChanged)
    Q_PROPERTY(quint8 rel_dc_offset READ getrel_dc_offset NOTIFY rel_dc_offsetChanged)
    Q_PROPERTY(QString dc_offset_val READ getdc_offset_val NOTIFY dc_offset_valChanged)
    Q_PROPERTY(QString offscrn_offset_val READ get_offscrn_offset_val NOTIFY dc_offset_valChanged)

    Q_PROPERTY(QVariantList scope_frame_data READ getframe_data NOTIFY scope_frame_dataChanged)

    Q_PROPERTY(QVariant devicesList READ getDevices NOTIFY devices_updated)
    //Q_PROPERTY(QVariant servicesList READ getServices NOTIFY services_updated)
    //Q_PROPERTY(QVariant characteristicList READ getCharacteristics NOTIFY characteristics_updated)
  //  Q_PROPERTY(QString update READ getUpdate WRITE setUpdate NOTIFY updateChanged)
  //  Q_PROPERTY(bool useRandomAddress READ isRandomAddress WRITE setRandomAddress NOTIFY randomAddressChanged)
  //  Q_PROPERTY(bool state READ state NOTIFY state_changed)
 //   Q_PROPERTY(bool controllerError READ controller_error)

public:

    Scope();
    ~Scope();
    Device *bt_device;
    Settings::scope_state getscope_state();
    QString getfpga_rev();
    QString getfw_rev();
    QString gethwid();
    QString getserial_num();
    Settings::chrge_state getcharge_state();
    Settings::batt_state getbatt_state();
    quint8 getbatt_level();
    QString gettemperature();
    QString getfps();
    void scope_Data_Update(QByteArray characteristic_data);
    void refresh_scope_out_char(QByteArray characteristic_data);

    QVariant getDevices();
    QVariant getServices();
    QVariant getCharacteristics();

    QVariantList getframe_data();

    //bool state();
    //bool controller_error();

    Settings *scope_settings;
    Settings::fe_mode getfe_setting();
    Settings::time_scale gettime_scale();
    Settings::dc_mode getinput_cpl();
    quint8 gettrigger_level();
    quint8 gettrigger_setting();
    qint16 getrel_window_pos();
    quint8 getframe_start_index();
    quint16 getdisplay_pnts();
    quint8 getsubtrig();

    quint8 getrel_dc_offset();
    QString getdc_offset_val();
    QString get_offscrn_offset_val();

    Settings::con_state connection_state();


signals:
   // void devices_updated();

public slots:
    void query_Telem();
    void query_Power();
    void query_Version();
    void setscope_state(quint8 state);
    void fps_timer_done();
    //void update_frame_data(QtCharts::QAbstractSeries *series, QtCharts::QAbstractSeries *trigger);
    void start_bt_scan();
    void stop_bt_scan();
    void scan_services(const QString &address);
    void update_fpga();
    QString gettime_delay();

    void setfe_setting(quint8 setting);
    void fe_setting_touch_handler(quint8 cmd);
    void settime_scale(quint8 setting);
    void time_scale_touch_handler(quint8 cmd);
    void setinput_cpl(quint8 setting);
    void setdc_offset(float delta_points);
    void setwindow_pos(float delta_points);
    void settrigger_level(quint8 setting);
    void settrigger_setting(quint8 setting);
    void toggle_trig_option(quint8 option);

    void device_connected();
    void device_disconnected();

    void cal_scope();
    void clear_cal();
    void deep_sleep();
    void scope_reset();

    void disconnect_device();
    bool connected_device(QString address);
    void connect_last_device();
    void forget_last_device();

private slots:

Q_SIGNALS:
    void scope_stateChanged();
    void fpga_revChanged();
    void fw_revChanged();
    void hwidChanged();
    void serial_numChanged();
    void charge_stateChanged();
    void batt_levelChanged();
    void batt_stateChanged();
    void temperatureChanged();
    void scope_frame_dataChanged();
    void fpsChanged();
    void rel_window_posChanged();

    void devices_updated();
    //void services_updated();
    //void characteristics_updated();
   // void state_changed();
    void connection_stateChanged();

    void fe_settingChanged();
    void time_scaleChanged();
    void input_cplChanged();
    void trigger_levelChanged();
    void trigger_settingChanged();
    void frame_lenChanged();
    void time_delayChanged();
    void rel_dc_offsetChanged();
    void dc_offset_valChanged();
    void telem_update();

private:
    float calc_offset();
    void setscope_run();
    void setscope_stop();
    void setscope_single();
    void update_version_info(QByteArray characteristic_data);
    void update_power_state(QByteArray characteristic_data);
    QString hwid;
    int hwid_index = 1;
    QString fpga_rev;
    int fpga_rev_index = 2;
    QString fw_rev;
    int fw_rev_index = 3;
    QString serial_num;
    int serial_num_index = 4;
    int serial_num_bytes = 4;

    void update_telem_info(QByteArray characteristic_data);
    int batt_level_index = 2;
    int charge_state_index = 1;

    QString temperature;
    int temperature_index = 3;
    int tempearture_num_bytes = 2;

    quint16 get_Frame_Length(quint8 length_char);

    //void set_FPGA_Default();

    QVector<quint8> m_data;
    QVector<quint8> frame_data;

    //QList<quint8> m_data;
    //QList<quint8> frame_data;

    quint16 packet_count;
    float frames_per_second;

};

#endif // SCOPE_H
