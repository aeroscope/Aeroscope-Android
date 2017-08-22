#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings : public QObject
{
    Q_OBJECT
    Q_ENUMS(fe_mode)
    Q_ENUMS(dc_mode)
    Q_ENUMS(time_scale)
    Q_ENUMS(touch_cmd)
    Q_ENUMS(batt_state)
    Q_ENUMS(chrge_state)
    Q_ENUMS(trigger_setting)
    Q_ENUMS(trigger_options)
    Q_ENUMS(scope_state)
    Q_ENUMS(con_state)

public:

    enum con_state
    {
        DISCONNECTED = 0x00,
        CONNECTED = 0x01,
        FPGA_OFF = 0x02
    };

    enum fe_mode
    {//cmd
        //AC mode definitions, DC_EN bit set to 0
        FE_100mv = 0x60,
        FE_200mv = 0x41,
        FE_500mv = 0x20,
        FE_1v = 0x22,
        FE_2v = 0x03,
        FE_5v = 0x04,
        FE_10v = 0x05
    };

    enum dc_mode
    {//cmd
        AC = 0x00,
        DC = 0x80
    };

    enum time_scale
    {//cmd
        TS_50n = 0x01,
        TS_100n = 0x02,
        TS_250n = 0x03,
        TS_500n = 0x00,
        TS_1u = 0x10,
        TS_2u = 0x20,
        TS_5u = 0x09,
        TS_10u = 0x11,
        TS_20u = 0x21,
        TS_50u = 0x0A,
        TS_100u = 0x12,
        TS_200u = 0x22,
        TS_500u = 0x0B,
        TS_1m = 0x13,
        TS_2m = 0x23,
        TS_5m = 0x0C,
        TS_10m = 0x14,
        TS_20m = 0x24,
        TS_50m = 0x0D,
        TS_100m = 0x15,
        TS_200m = 0x25,
        TS_500m = 0xE7,
        TS_1s = 0xEF,
        TS_2s = 0xF7,
        TS_5s = 0xFF
    };

    enum sample_rate
    {//ns
        SR_50n = 10,
        SR_100n = 10,
        SR_250n = 10,
        SR_500n = 10,
        SR_1u = 20,
        SR_2u = 40,
        SR_5u = 100,
        SR_10u = 200,
        SR_20u = 400,
        SR_50u = 1000,
        SR_100u = 2000,
        SR_200u = 4000,
        SR_500u = 10000,
        SR_1m = 20000,
        SR_2m = 40000,
        SR_5m = 100000,
        SR_10m = 200000,
        SR_20m = 400000,
        SR_50m = 1000000,
        SR_100m = 2000000,
        SR_200m = 4000000,
        SR_500m = 10000000,
        SR_1s = 20000000,
        SR_2s = 40000000,
        SR_5s = 100000000
    };

    enum dac_conversion
    {//dac conversion multiplied by 1000, divide by 1000 when used
        DAC_100mv = 2048,
        DAC_200mv = 4096,
        DAC_500mv = 10240,
        DAC_1v = 20480,
        DAC_2v = 40960,
        DAC_5v = 102400,
        DAC_10v = 204800
    };

    enum adc_fs_volt
    {//full scale range in mV
        FS_100mv = 800,
        FS_200mv = 1600,
        FS_500mv = 4000,
        FS_1v = 8000,
        FS_2v = 16000,
        FS_5v = 40000,
        FS_10v = 80000
    };

    enum touch_cmd
    {//for incrementing or decrementing settings based on gesture input
        INC = 1,
        DEC = 0
    };

    enum batt_state
    {
        BATT_FULL = 238,
        BATT_MID = 226,
        BATT_LOW = 220,
        BATT_DEAD = 219
    };

    enum chrge_state
    {
        CHARGING = 0xC0,
        FULL = 0x80,
        ABSENT = 0x00
    };

    enum trigger_setting
    {
        RISING = 0x02,
        FALLING = 0x04,
        ANY = 0x06
    };

    enum trigger_options
    {
        AUTO = 0x01,
        NR = 0x20
    };

    enum scope_state
    {
        RUN = 0x01,
        SINGLE = 0x02,
        STOP = 0x00
    };

    Settings(fe_mode fe, dc_mode dc, time_scale ts);
    ~Settings();

    void setfe_setting(fe_mode setting);
    void fe_setting_touch(touch_cmd cmd);
    quint8 getfe_byte();

    void setdc_setting(dc_mode dc);

    time_scale gettime_scale();
    void settime_scale(time_scale time);
    void time_scale_touch(touch_cmd cmd);
    quint32 time_btwn_smpl(time_scale time);

    float get_dac_conversion(fe_mode fe_setting);
    void set_dac(quint16 dac);

    void set_window_pos(quint16 window);
    void update_window_pos(time_scale new_time_scale);

    void set_trigger_level(quint8 trigger);

    void set_hor_trigger(quint16 new_trig); 

    void set_frame_length(quint16 new_frame_len);

    float get_dac_sensitivity();
    float get_fs_voltage();

    void setcharge_state(quint8 charge_byte);
    void setbatt_state(quint8 batt_byte);

    void set_trig_settings(quint8 trigger_byte);

    fe_mode fe_setting;
    dc_mode dc_setting;
    con_state connection_state;
    time_scale time_setting;
    chrge_state charger_state;
    batt_state battery_state;
    quint8 battery_level;
    quint16 dac_setting;
    bool settings_updated;
    quint16 window_pos;
    quint8 trigger_level;
    quint16 hor_trigger;
    scope_state scope_run_state;
    quint16 frame_length;
    quint16 subtrig;
    quint16 display_pnts;
    quint8 frame_start_index;
    quint8 trigger_state;
    bool reconnect_bt;
    const quint16 dac_mid_scale = 32768;
    const quint8 adc_fs_code = 255;    
    const quint16 max_window_pos = 3584;
    const quint16 dac_limit_offset = 3277;
    const quint16 dac_fs_code = 0xFFFF;

Q_SIGNALS:
    void batt_stateChanged();
    void batt_levelChanged();
    void chrg_stateChanged();
};

#endif // SETTINGS_H
