// Copyright (C) 2017 Aeroscope Labs LLC

#include "settings.h"
#include <QtQml>

Settings::Settings(fe_mode fe, dc_mode dc, time_scale ts):
    fe_setting(fe), dc_setting(dc), connection_state(DISCONNECTED), time_setting(ts), charger_state(ABSENT), battery_state(BATT_DEAD),
    dac_setting(0x8000), settings_updated(0), window_pos(0x700), trigger_level(0x80), hor_trigger(0x800), scope_run_state(STOP),
    frame_length(512), display_pnts(512), frame_start_index(0), trigger_state(RISING|AUTO), reconnect_bt(false)
{
    qmlRegisterUncreatableType<Settings>("Device_Settings",1,0,"Aero_Settings","can't instantiate");//QML name must be capitalized!
}

Settings::~Settings()
{

}

float Settings::get_fs_voltage()
{
    float fs_voltage = 0.0;

    switch (fe_setting) {
    case FE_100mv:
        fs_voltage = (float)FS_100mv/1000.0;
        break;
    case FE_200mv:
        fs_voltage = (float)FS_200mv/1000.0;
        break;
    case FE_500mv:
        fs_voltage = (float)FS_500mv/1000.0;
        break;
    case FE_1v:
        fs_voltage = (float)FS_1v/1000.0;
        break;
    case FE_2v:
        fs_voltage = (float)FS_2v/1000.0;
        break;
    case FE_5v:
        fs_voltage = (float)FS_5v/1000.0;
        break;
    case FE_10v:
        fs_voltage = (float)FS_10v/1000.0;
        break;
    default:
        break;
    }

    return fs_voltage;
}

quint8 Settings::getfe_byte()
{
    return (dc_setting | fe_setting);
}

void Settings::setfe_setting(fe_mode setting)
{
    fe_setting = setting;
}

void Settings::fe_setting_touch(touch_cmd cmd)
{
    switch(fe_setting){
    case FE_100mv:
        if(cmd == INC)
        {
            fe_setting = FE_200mv;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_100mv;
        }
        break;
    case FE_200mv:
        if(cmd == INC)
        {
            fe_setting = FE_500mv;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_100mv;
        }
        break;
    case FE_500mv:
        if(cmd == INC)
        {
            fe_setting = FE_1v;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_200mv;
        }
        break;
    case FE_1v:
        if(cmd == INC)
        {
            fe_setting = FE_2v;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_500mv;
        }
        break;
    case FE_2v:
        if(cmd == INC)
        {
            fe_setting = FE_5v;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_1v;
        }
        break;
    case FE_5v:
        if(cmd == INC)
        {
            fe_setting = FE_10v;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_2v;
        }
        break;
    case FE_10v:
        if(cmd == INC)
        {
            fe_setting = FE_10v;
        }
        else if(cmd == DEC)
        {
            fe_setting = FE_5v;
        }
        break;
    default:
        break;

    }
}

quint32 Settings::time_btwn_smpl(time_scale time)
{
    quint32 sample_time = 0;

    switch(time){
    case TS_50n:
        sample_time = SR_50n;
        break;
    case TS_100n:
        sample_time = SR_100n;
        break;
    case TS_250n:
        sample_time = SR_250n;
        break;
    case TS_500n:
        sample_time = SR_500n;
        break;
    case TS_1u:
        sample_time = SR_1u;
        break;
    case TS_2u:
        sample_time = SR_2u;
        break;
    case TS_5u:
        sample_time = SR_5u;
        break;
    case TS_10u:
        sample_time = SR_10u;
        break;
    case TS_20u:
        sample_time = SR_20u;
        break;
    case TS_50u:
        sample_time = SR_50u;
        break;
    case TS_100u:
        sample_time = SR_100u;
        break;
    case TS_200u:
        sample_time = SR_200u;
        break;
    case TS_500u:
        sample_time = SR_500u;
        break;
    case TS_1m:
        sample_time = SR_1m;
        break;
    case TS_2m:
        sample_time = SR_2m;
        break;
    case TS_5m:
        sample_time = SR_5m;
        break;
    case TS_10m:
        sample_time = SR_10m;
        break;
    case TS_20m:
        sample_time = SR_20m;
        break;
    case TS_50m:
        sample_time = SR_50m;
        break;
    case TS_100m:
        sample_time = SR_100m;
        break;
    case TS_200m:
        sample_time = SR_200m;
        break;
    case TS_500m:
        sample_time = SR_500m;
        break;
    case TS_1s:
        sample_time = SR_1s;
        break;
    case TS_2s:
        sample_time = SR_2s;
        break;
    case TS_5s:
        sample_time = SR_5s;
        break;
    default:
        break;
    }

    return sample_time;
}

void Settings::setdc_setting(dc_mode dc)
{
    dc_setting = dc;
}

Settings::time_scale Settings::gettime_scale()
{
    if(time_setting == TS_50n || time_setting == TS_100n || time_setting == TS_250n)
    {
        return TS_500n;
    }
    else
    {
        return time_setting;
    }
}

void Settings::settime_scale(time_scale time)
{
   update_window_pos(time);
   time_setting = time;

   if(time == TS_50n)
   {
       display_pnts = 51;
       frame_start_index = 231;
   }
   else if(time == TS_100n)
   {
       display_pnts = 101;
       frame_start_index = 206;
   }
   else if(time == TS_250n)
   {
       display_pnts = 251;
       frame_start_index = 131;
   }
   else
   {
       display_pnts = 501;
       frame_start_index = 6;
   }
}

void Settings::time_scale_touch(touch_cmd cmd)
{
    time_scale time;

    switch(time_setting){
    case TS_50n:
        if(cmd == INC)
        {
            time = TS_100n;
        }
        else if(cmd == DEC)
        {
            time = TS_50n;
        }
        break;
    case TS_100n:
        if(cmd == INC)
        {
            time = TS_250n;
        }
        else if(cmd == DEC)
        {
            time = TS_50n;
        }
        break;
    case TS_250n:
        if(cmd == INC)
        {
            time = TS_500n;
        }
        else if(cmd == DEC)
        {
            time = TS_100n;
        }
        break;
    case TS_500n:
        if(cmd == INC)
        {
            time = TS_1u;
        }
        else if(cmd == DEC)
        {
            time = TS_250n;
        }
        break;
    case TS_1u:
        if(cmd == INC)
        {
            time = TS_2u;
        }
        else if(cmd == DEC)
        {
            time = TS_500n;
        }
        break;
    case TS_2u:
        if(cmd == INC)
        {
            time = TS_5u;
        }
        else if(cmd == DEC)
        {
            time = TS_1u;
        }
        break;
    case TS_5u:
        if(cmd == INC)
        {
            time = TS_10u;
        }
        else if(cmd == DEC)
        {
            time = TS_2u;
        }
        break;
    case TS_10u:
        if(cmd == INC)
        {
            time = TS_20u;
        }
        else if(cmd == DEC)
        {
            time = TS_5u;
        }
        break;
    case TS_20u:
        if(cmd == INC)
        {
            time = TS_50u;
        }
        else if(cmd == DEC)
        {
            time = TS_10u;
        }
        break;
    case TS_50u:
        if(cmd == INC)
        {
            time = TS_100u;
        }
        else if(cmd == DEC)
        {
            time = TS_20u;
        }
        break;
    case TS_100u:
        if(cmd == INC)
        {
            time = TS_200u;
        }
        else if(cmd == DEC)
        {
            time = TS_50u;
        }
        break;
    case TS_200u:
        if(cmd == INC)
        {
            time = TS_500u;
        }
        else if(cmd == DEC)
        {
            time = TS_100u;
        }
        break;
    case TS_500u:
        if(cmd == INC)
        {
            time = TS_1m;
        }
        else if(cmd == DEC)
        {
            time = TS_200u;
        }
        break;
    case TS_1m:
        if(cmd == INC)
        {
            time = TS_2m;
        }
        else if(cmd == DEC)
        {
            time = TS_500u;
        }
        break;
    case TS_2m:
        if(cmd == INC)
        {
            time = TS_5m;
        }
        else if(cmd == DEC)
        {
            time = TS_1m;
        }
        break;
    case TS_5m:
        if(cmd == INC)
        {
            time = TS_10m;
        }
        else if(cmd == DEC)
        {
            time = TS_2m;
        }
        break;
    case TS_10m:
        if(cmd == INC)
        {
            time = TS_20m;
        }
        else if(cmd == DEC)
        {
            time = TS_5m;
        }
        break;
    case TS_20m:
        if(cmd == INC)
        {
            time = TS_50m;
        }
        else if(cmd == DEC)
        {
            time = TS_10m;
        }
        break;
    case TS_50m:
        if(cmd == INC)
        {
            time = TS_100m;
        }
        else if(cmd == DEC)
        {
            time = TS_20m;
        }
        break;
    case TS_100m:
        if(cmd == INC)
        {
            time = TS_200m;
        }
        else if(cmd == DEC)
        {
            time = TS_50m;
        }
        break;
    case TS_200m:
        if(cmd == INC)
        {
            time = TS_500m;
        }
        else if(cmd == DEC)
        {
            time = TS_100m;
        }
        break;
    case TS_500m:
        if(cmd == INC)
        {
            time = TS_1s;
        }
        else if(cmd == DEC)
        {
            time = TS_200m;
        }
        break;
    case TS_1s:
        if(cmd == INC)
        {
            time = TS_2s;
        }
        else if(cmd == DEC)
        {
            time = TS_500m;
        }
        break;
    case TS_2s:
        if(cmd == INC)
        {
            time = TS_5s;
        }
        else if(cmd == DEC)
        {
            time = TS_1s;
        }
        break;
    case TS_5s:
        if(cmd == INC)
        {
            time = TS_5s;
        }
        else if(cmd == DEC)
        {
            time = TS_2s;
        }
        break;

    default:
        break;
    }

    settime_scale(time);
}

float Settings::get_dac_conversion(fe_mode fe_setting)
{
    float conversion = 0.0;
    switch (fe_setting) {
    case FE_100mv:
        conversion = (float)DAC_100mv;
        break;
    case FE_200mv:
        conversion = (float)DAC_200mv;
        break;
    case FE_500mv:
        conversion = (float)DAC_500mv;
        break;
    case FE_1v:
        conversion = (float)DAC_1v;
        break;
    case FE_2v:
        conversion = (float)DAC_2v;
        break;
    case FE_5v:
        conversion = (float)DAC_5v;
        break;
    case FE_10v:
        conversion = (float)DAC_10v;
        break;
    default:
        break;
    }

    return conversion;
}

float Settings::get_dac_sensitivity()
{
    float dac_sensitivity = 0.0;

    switch (fe_setting) {
    case FE_100mv:
        dac_sensitivity = (float)FS_100mv/((float)adc_fs_code * (float)DAC_100mv);
        break;
    case FE_200mv:
        dac_sensitivity = (float)FS_200mv/((float)adc_fs_code * (float)DAC_200mv);
        break;
    case FE_500mv:
        dac_sensitivity = (float)FS_500mv/((float)adc_fs_code * (float)DAC_500mv);
        break;
    case FE_1v:
        dac_sensitivity = (float)FS_1v/((float)adc_fs_code * (float)DAC_1v);
        break;
    case FE_2v:
        dac_sensitivity = (float)FS_2v/((float)adc_fs_code * (float)DAC_2v);
        break;
    case FE_5v:
        dac_sensitivity = (float)FS_5v/((float)adc_fs_code * (float)DAC_5v);
        break;
    case FE_10v:
        dac_sensitivity = (float)FS_10v/((float)adc_fs_code * (float)DAC_10v);
        break;
    default:
        break;
    }

    return dac_sensitivity;
}

void Settings::set_dac(quint16 dac)
{
    Settings::dac_setting = dac;
}

void Settings::set_window_pos(quint16 window)
{
    if(window < max_window_pos) {
        Settings::window_pos = window;
    }
    else
    {
        Settings::window_pos = max_window_pos;
    }
}

void Settings::update_window_pos(time_scale new_time_scale)
{
    time_scale current_time_scl = time_setting;
    qint32 current_win_sample_os;
    qint32 current_win_time_os;
    qint32 new_win_pos_os;
    qint32 new_win_pos;

    quint32 current_smpl_rate = 0;
    quint32 new_smpl_rate = 0;

    current_smpl_rate = time_btwn_smpl(current_time_scl);
    new_smpl_rate = time_btwn_smpl(new_time_scale);

    current_win_sample_os = Settings::hor_trigger - (Settings::window_pos + Settings::frame_length/2);
    current_win_time_os = current_win_sample_os * current_smpl_rate;//this is the current time offset of the hor trigger
    new_win_pos_os = current_win_time_os/(qint32)new_smpl_rate;

    new_win_pos = Settings::hor_trigger - (new_win_pos_os + Settings::frame_length/2);

    if(new_win_pos < 0)
    {
        set_window_pos(0);
    }
    else if(new_win_pos > max_window_pos)
    {
        set_window_pos(max_window_pos);
    }
    else
    {
        set_window_pos(new_win_pos);
    }
}

void Settings::set_trigger_level(quint8 trigger)
{
    Settings::trigger_level = trigger;
}

void Settings::set_trig_settings(quint8 trigger_byte)
{
    if(((trigger_byte & RISING) != 0) && ((trigger_byte & FALLING) != 0))
    {
        Settings::trigger_state = ANY;
    }
    else if((trigger_byte & FALLING) != 0)
    {
        Settings::trigger_state = FALLING;
    }
    else if((trigger_byte & RISING) != 0)
    {
        Settings::trigger_state = RISING;
    }

    if(Settings::trigger_state == ANY)
    {
        Settings::trigger_state |= (trigger_byte & AUTO);
    }
    else
    {
        Settings::trigger_state |= ((trigger_byte & AUTO) | (trigger_byte & NR));
    }
}

void Settings::set_hor_trigger(quint16 new_trig)
{
    Settings::hor_trigger = new_trig;
}

void Settings::set_frame_length(quint16 new_frame_len)
{
    Settings::frame_length = new_frame_len;
}

void Settings::setcharge_state(quint8 charge_byte)
{
    if (charge_byte != Settings::charger_state)
    {
        Settings::charger_state = (chrge_state)charge_byte;
        emit Settings::chrg_stateChanged();
    }
}

void Settings::setbatt_state(quint8 batt_byte)
{
    if(Settings::battery_level != batt_byte)
    {
        Settings::battery_level = batt_byte;
        emit Settings::batt_levelChanged();
    }

    if(batt_byte >= BATT_FULL && Settings::battery_state != BATT_FULL)
    {
        Settings::battery_state = BATT_FULL;
        emit batt_stateChanged();
    }
    else if(batt_byte >= BATT_MID && Settings::battery_state != BATT_MID)
    {
        Settings::battery_state = BATT_MID;
        emit batt_stateChanged();
    }
    else if(batt_byte >= BATT_LOW && Settings::battery_state != BATT_LOW)
    {
        Settings::battery_state = BATT_LOW;
        emit batt_stateChanged();
    }
    else if(Settings::battery_state != BATT_DEAD)
    {
        Settings::battery_state = BATT_DEAD;
        emit batt_stateChanged();
    }
}
