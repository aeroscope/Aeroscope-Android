#include "scope.h"
#include "settings.h"

Scope::Scope():
    bt_device(new Device(this)), scope_settings(new Settings(Settings::FE_1v, Settings::DC, Settings::TS_500n))
{
    m_data.reserve(512);
    frames_per_second = 0;
    connect(bt_device, SIGNAL(devicesUpdated()),this, SIGNAL(devices_updated()));
    connect(bt_device, SIGNAL(service_details_discovered()), this, SLOT(device_connected()));
    connect(bt_device, SIGNAL(disconnected()), this, SLOT(device_disconnected()));

    connect(scope_settings, SIGNAL(batt_stateChanged()), this, SIGNAL(batt_stateChanged()));
    connect(scope_settings, SIGNAL(batt_levelChanged()), this, SIGNAL(batt_levelChanged()));
    connect(scope_settings, SIGNAL(chrg_stateChanged()), this, SIGNAL(charge_stateChanged()));
}

Scope::~Scope()
{
    delete bt_device;
    delete scope_settings;
}

quint16 Scope::get_Frame_Length(quint8 length_char)
{
    switch (length_char)
        {
            case 0x01:
                return 16;
                break;
            case 0x02:
                return 32;
                break;
            case 0x03:
                return 64;
                break;
            case 0x04:
                return 128;
                break;
            case 0x05:
                return 256;
                break;
            case 0x06:
                return 512;
                break;
            case 0x07:
                return 1024;
                break;
            case 0x08:
                return 2048;
                break;
            case 0x09:
                return 4096;
                break;

            default:
                return 512;
        }
}

void Scope::scope_Data_Update(QByteArray characteristic_data)
{
    char data_header = characteristic_data.at(0);
    Scope::packet_count++;
    if(data_header)
    {
        //if the header isn't 0 then this is start of frame packet
        qDebug() << "SOF";

        scope_settings->set_frame_length(get_Frame_Length(data_header));
        scope_settings->subtrig = characteristic_data.at(1);

        Scope::m_data.clear();
        for(int i = 2; i < characteristic_data.size(); i++)
        {
            Scope::m_data.append(characteristic_data.at(i));
        }
    }
    else//continuation of frame packet
    {
        for(int i = 1; i < characteristic_data.size(); i++)
        {
            if(m_data.size() < scope_settings->frame_length)
            {
                Scope::m_data.append(characteristic_data.at(i));
            }
        }
    }

    if(Scope::m_data.size() >= scope_settings->frame_length)
    {
        if(scope_settings->frame_length == 16)
        {
            if(frame_data.size() >= scope_settings->display_pnts) {
                Scope::frame_data.remove(0, 16);
            }

            Scope::frame_data += Scope::m_data.mid(0,16);
        }
        else
        {
            frame_data.swap(m_data);
            //Scope::frame_data.clear();
            //Scope::frame_data = Scope::m_data;
        }
        if(frame_data.size() >= scope_settings->display_pnts)
        {
            emit Scope::scope_frame_dataChanged();
        }
        if(scope_settings->scope_run_state == Settings::SINGLE)
        {
            scope_settings->scope_run_state = Settings::STOP;
            emit Scope::scope_stateChanged();
        }
    }
}

QVariantList Scope::getframe_data()
{
    QVariantList temp;

    foreach (const quint8 item, Scope::frame_data) {
        temp << item;

    }
    return temp;
}

quint8 Scope::getsubtrig()
{
    return scope_settings->subtrig;
}

void Scope::refresh_scope_out_char(QByteArray characteristic_data)
{
    char data_header = characteristic_data.at(0);

    switch (data_header) {
    case 'T':
        qDebug() << "Telemetry Update";
        Scope::update_telem_info(characteristic_data);
        break;
    case 'V':
        qDebug() << "Version Update";
        Scope::update_version_info(characteristic_data);
        break;
    case 'E':
        qDebug() << "Error Message Received";
        break;
    case 'C':
        qDebug() << "Cal Params Received";
        break;
    case 'B':
        qDebug() << "Button Press";
        if(scope_settings->scope_run_state == Settings::RUN || scope_settings->scope_run_state == Settings::SINGLE)
        {
            Scope::setscope_state(Settings::STOP);
        }
        else
        {
            Scope::setscope_state(Settings::RUN);
        }
        break;
    case 'P':
        qDebug() << "Power Message";
        Scope::update_power_state(characteristic_data);
        break;
    default:
        break;
    }
}

void Scope::update_version_info(QByteArray characteristic_data)
{
    if(Scope::fpga_rev != QString::number(characteristic_data.at(Scope::fpga_rev_index)))
    {
        Scope::fpga_rev = QString::number(characteristic_data.at(Scope::fpga_rev_index));
        emit fpga_revChanged();
    }

    if(Scope::fw_rev != QString::number(characteristic_data.at(Scope::fw_rev_index)))
    {
        Scope::fw_rev = QString::number(characteristic_data.at(Scope::fw_rev_index));
        emit fw_revChanged();
    }

    if(Scope::hwid != QString::number(characteristic_data.at(Scope::hwid_index)))
    {
        Scope::hwid = QString::number(characteristic_data.at(Scope::hwid_index));
        emit hwidChanged();
    }

    qint32 serial_number_new = 0;

    for (int i = 0; i < Scope::serial_num_bytes; i++)
    {
        serial_number_new |= characteristic_data[i + Scope::serial_num_index];
        if(i != (serial_num_bytes - 1))
            serial_number_new <<= 8;
    }

    if(Scope::serial_num != QString::number(serial_number_new))
    {
        Scope::serial_num = QString::number(serial_number_new);
        emit serial_numChanged();
    }
}

void Scope::update_power_state(QByteArray characteristic_data)
{
    quint8 power_state = characteristic_data.at(1);
    switch (power_state){
        case 'F':
            scope_settings->connection_state = Settings::CONNECTED;
            scope_settings->settings_updated = 1;

            Scope::update_fpga();
            if(scope_settings->scope_run_state == Settings::RUN)
            {
                setscope_run();
            }
            else if(scope_settings->scope_run_state == Settings::SINGLE)
            {
                setscope_single();
            }
            break;
        case 'O':
            scope_settings->connection_state = Settings::FPGA_OFF;
            QTimer::singleShot(100, this, SLOT(query_Power()));
            qDebug() << "FPGA not powered up, requery power";
            break;
       default:
            break;
    }

    emit connection_stateChanged();
}

QString Scope::getfpga_rev()
{
    return Scope::fpga_rev;
}

QString Scope::getfw_rev()
{
    return Scope::fw_rev;
}

QString Scope::gethwid()
{
    return Scope::hwid;
}

QString Scope::getserial_num()
{
    return Scope::serial_num;
}

void Scope::update_telem_info(QByteArray characteristic_data)
{
    quint8 charger = characteristic_data.at(Scope::charge_state_index);
    scope_settings->setcharge_state(charger);

    quint8 batt_byte = characteristic_data.at(Scope::batt_level_index);
    scope_settings->setbatt_state(batt_byte);

    quint16 temperature_new_byte = 0;
    float temperature_new_float;

    temperature_new_byte = characteristic_data.at(Scope::temperature_index);
    temperature_new_byte <<= 8;
    temperature_new_byte |= characteristic_data.at(Scope::temperature_index + 1);

    temperature_new_float = (float)temperature_new_byte/(float)10;

    if(Scope::temperature != QString::number(temperature_new_float,'f', 1))
    {
        Scope::temperature = QString::number(temperature_new_float,'f', 1);
        emit temperatureChanged();
    }

    emit telem_update();
}

QString Scope::gettemperature()
{
    return Scope::temperature;
}

quint8 Scope::getbatt_level()
{
    return Scope::scope_settings->battery_level;
}

Settings::batt_state Scope::getbatt_state()
{
    return Scope::scope_settings->battery_state;
}

Settings::chrge_state Scope::getcharge_state()
{
    return Scope::scope_settings->charger_state;
}

void Scope::cal_scope()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'C';
    ba[1] = 'F';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::clear_cal()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'C';
    ba[1] = 'X';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::deep_sleep()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'Z';
    ba[1] = 'Z';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::scope_reset()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'Z';
    ba[1] = 'R';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::query_Telem()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'Q';
    ba[1] = 'T';
    ba[2] = 'I';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::query_Power()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'Q';
    ba[1] = 'P';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::query_Version()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'Q';
    ba[1] = 'V';
    ba[2] = 'R';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
}

void Scope::update_fpga()
{
    if(scope_settings->settings_updated)
    {
        scope_settings->settings_updated = 0;
        QByteArray ba;
        ba.resize(20);
        ba.fill('\0');
        ba[0] = scope_settings->trigger_state;
        ba[1] = scope_settings->trigger_level;
        ba[2] = 0x00;
        ba[3] = scope_settings->getfe_byte();
        ba[4] = scope_settings->gettime_scale();
        ba[5] = (scope_settings->hor_trigger >> 8) & 0x0F;
        ba[6] = scope_settings->hor_trigger & 0xFF;
        ba[7] = scope_settings->window_pos >> 8;
        ba[8] = scope_settings->window_pos & 0xFF;
        ba[9] = 0x09;
        ba[10] = 0x06;
        ba[11] = scope_settings->dac_setting >> 8;
        ba[12] = scope_settings->dac_setting & 0xFF;

        Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_State_Char, ba);
    }
}

void Scope::setscope_run()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'R';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
    scope_settings->scope_run_state = Settings::RUN;
}

void Scope::setscope_stop()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'S';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
    scope_settings->scope_run_state = Settings::STOP;
}

void Scope::setscope_single()
{
    QByteArray ba;
    ba.resize(20);
    ba.fill('\0');
    ba[0] = 'F';
    Scope::bt_device->write_Characteristic(Scope::bt_device->Scope_In_Char, ba);
    scope_settings->scope_run_state = Settings::SINGLE;
}

void Scope::setscope_state(quint8 state)
{
    scope_settings->scope_run_state = (Settings::scope_state)state;

    if(state == Settings::RUN)
    {
        Scope::setscope_run();
    }
    else if(state == Settings::STOP)
    {
        Scope::setscope_stop();
    }
    else if(state == Settings::SINGLE)
    {
        Scope::setscope_stop();
        Scope::setscope_single();
    }

    emit scope_stateChanged();
}

Settings::scope_state Scope::getscope_state()
{
    return scope_settings->scope_run_state;
}

void Scope::setdc_offset(float delta_points)
{
    qint16 delta_dac = -1*delta_points*scope_settings->adc_fs_code*(float)scope_settings->get_dac_conversion(scope_settings->fe_setting)/((float)(1000));
    quint16 current_dac_setting = scope_settings->dac_setting;

    if (((current_dac_setting + delta_dac) > scope_settings->dac_limit_offset) && ((current_dac_setting + delta_dac) < (scope_settings->dac_fs_code - scope_settings->dac_limit_offset)))
    {
        scope_settings->set_dac(current_dac_setting + delta_dac);
    }
    else if((current_dac_setting + delta_dac) < (scope_settings->dac_limit_offset))
    {
        scope_settings->set_dac(scope_settings->dac_limit_offset);
    }
    else
    {
        scope_settings->set_dac(scope_settings->dac_fs_code - scope_settings->dac_limit_offset);
    }

    emit Scope::rel_dc_offsetChanged();
    emit Scope::dc_offset_valChanged();
    scope_settings->settings_updated = 1;
}

quint8 Scope::getrel_dc_offset()
{
    quint16 current_dac_setting = scope_settings->dac_setting;
    qint32 adc_ref_dac_setting = (current_dac_setting - scope_settings->dac_mid_scale);
    adc_ref_dac_setting = adc_ref_dac_setting * 1000/(scope_settings->get_dac_conversion(scope_settings->fe_setting));
    adc_ref_dac_setting += 127;

    if(adc_ref_dac_setting < 0)
    {
        return 0;
    }
    else if (adc_ref_dac_setting > 255)
    {
        return 255;
    }
    else
    {
        quint8 rel_dc_os = (quint8)adc_ref_dac_setting;
        return rel_dc_os;
    }
}

float Scope::calc_offset()
{
    float dac_sensitivity = scope_settings->get_dac_sensitivity();//mV per LSB of DAC
    quint16 current_dac_setting = scope_settings->dac_setting;
    float offset = (float)(current_dac_setting - scope_settings->dac_mid_scale) * dac_sensitivity;
    return offset;
}

QString Scope::getdc_offset_val()
{
    float offset = Scope::calc_offset();
    QString offset_val;

    if(qAbs(offset) < 1)
    {
        offset *= 1000;
        offset_val = QString::number(offset, 'f', 0);
        offset_val.append(" mV");
    }
    else
    {
        offset_val = QString::number(offset, 'f', 2);
        offset_val.append(" V");
    }

    return offset_val;

}

QString Scope::get_offscrn_offset_val()
{
    float offset = Scope::calc_offset();
    offset = qAbs(offset);
    offset -= (scope_settings->get_fs_voltage())/2.0;
    QString offset_val;

    if(qAbs(offset) < 1)
    {
        offset *= 1000;
        offset_val = QString::number(offset, 'f', 0);
        offset_val.append(" mV");
    }
    else
    {
        offset_val = QString::number(offset, 'f', 2);
        offset_val.append(" V");
    }

    return offset_val;
}

void Scope::setwindow_pos(float delta_points)
{
    qint16 delta_window = delta_points*500;

    if(scope_settings->time_setting == Settings::TS_250n)
    {
        delta_window = delta_window/2;
    }
    else if(scope_settings->time_setting == Settings::TS_100n)
    {
        delta_window = delta_window/3;
    }
    else if(scope_settings->time_setting == Settings::TS_50n)
    {
        delta_window = delta_window/4;
    }

    quint16 current_window_setting = scope_settings->window_pos;

    if((current_window_setting + delta_window) >= 0)
    {
        scope_settings->set_window_pos(current_window_setting + delta_window);
    }
    else
    {
        scope_settings->set_window_pos(0);
    }

    emit Scope::rel_window_posChanged();
    emit Scope::time_delayChanged();
    scope_settings->settings_updated = 1;
}

quint8 Scope::getframe_start_index()
{
    return scope_settings->frame_start_index;
}

qint16 Scope::getrel_window_pos()
{
    quint16 window = scope_settings->window_pos;
    quint16 hor_trig = scope_settings->hor_trigger;
    quint8 window_index = Scope::getframe_start_index();

    qint16 rel_pos = hor_trig - (window + window_index);
    return rel_pos;
}

QString Scope::gettime_delay()
{
    qint16 rel_pos = getrel_window_pos();
    quint32 sample_rate = scope_settings->time_btwn_smpl(scope_settings->time_setting);
    float delay = 0.0;
    QString delay_string;

    if(rel_pos < 0 or rel_pos > scope_settings->display_pnts)
    {
        if(rel_pos < 0)
        {
        rel_pos = qAbs(rel_pos);
        }
        else
        {
            rel_pos -= scope_settings->display_pnts;
        }

        delay = rel_pos * sample_rate;
    }


    if(delay > 1000000)
    {
        delay /= 1000000.0;
        delay_string = QString::number(delay,'f', 3);
        delay_string.append(" ms");
    }
    else if(delay > 1000)
    {
        delay /= 1000.0;
        delay_string = QString::number(delay,'f', 2);
        delay_string.append(" us");
    }
    else
    {
        delay_string = QString::number(delay,'f', 2);
        delay_string.append(" ns");
    }

    return delay_string;
}

void Scope::settrigger_level(quint8 setting)
{
    scope_settings->set_trigger_level(setting);
    emit Scope::trigger_levelChanged();
    scope_settings->settings_updated = 1;
}

quint8 Scope::gettrigger_level()
{
    return scope_settings->trigger_level;
}

void Scope::settrigger_setting(quint8 setting)
{
    qDebug() << "write trigger setting = " << setting;
    scope_settings->set_trig_settings(setting);
    emit Scope::trigger_settingChanged();
    scope_settings->settings_updated = 1;
}

void Scope::toggle_trig_option(quint8 option)
{
    qDebug() << "write trigger setting = " << option;

    if(option == Settings::AUTO)
    {
        if((scope_settings->trigger_state & Settings::AUTO) != 0) {
            qDebug() << "clear auto trig " << (quint8)(scope_settings->trigger_state & (~(Settings::AUTO)));

            scope_settings->set_trig_settings(scope_settings->trigger_state & (~(Settings::AUTO)));
        }
        else {
            qDebug() << "set auto trig";
            scope_settings->set_trig_settings(scope_settings->trigger_state | Settings::AUTO);
        }
    }
    else if(option == Settings::NR)
    {
        if((scope_settings->trigger_state & Settings::NR) != 0) {
            qDebug() << "clear nr";
            scope_settings->set_trig_settings(scope_settings->trigger_state & (~(Settings::NR)));
        }
        else {
            qDebug() << "set nr";
            scope_settings->set_trig_settings(scope_settings->trigger_state | Settings::NR);
        }
    }

    qDebug() << "New trigger state = " << scope_settings->trigger_state;

    emit Scope::trigger_settingChanged();
    scope_settings->settings_updated = 1;
}

quint8 Scope::gettrigger_setting()
{
    return scope_settings->trigger_state;
}

QString Scope::getfps()
{
    return QString::number(Scope::frames_per_second,'f', 1);
}

void Scope::fps_timer_done()
{
    Scope::frames_per_second = (float)Scope::packet_count/(float)26;
    Scope::packet_count = 0;
    emit Scope::fpsChanged();
}

Settings::dc_mode Scope::getinput_cpl()
{
    return scope_settings->dc_setting;
}

void Scope::setinput_cpl(quint8 setting)
{
    scope_settings->Settings::setdc_setting((Settings::dc_mode)setting);
    emit Scope::input_cplChanged();
    scope_settings->settings_updated = 1;
}

Settings::fe_mode Scope::getfe_setting()
{
    return scope_settings->fe_setting;
}

void Scope::setfe_setting(quint8 setting)
{
    scope_settings->Settings::setfe_setting((Settings::fe_mode)setting);
    emit Scope::fe_settingChanged();
    emit Scope::rel_dc_offsetChanged();
    emit Scope::dc_offset_valChanged();
    scope_settings->settings_updated = 1;
}

void Scope::fe_setting_touch_handler(quint8 cmd)
{
    scope_settings->Settings::fe_setting_touch((Settings::touch_cmd) cmd);
    emit Scope::fe_settingChanged();
    emit rel_dc_offsetChanged();
    emit Scope::dc_offset_valChanged();
    scope_settings->settings_updated = 1;
}

Settings::time_scale Scope::gettime_scale()
{
    return scope_settings->time_setting;
}

void Scope::settime_scale(quint8 setting)
{
    //qDebug() << "Set Time scale";
    scope_settings->Settings::settime_scale((Settings::time_scale)setting);
    emit Scope::time_scaleChanged();
    emit Scope::time_delayChanged();
    emit Scope::rel_window_posChanged();
    scope_settings->settings_updated = 1;
}

void Scope::time_scale_touch_handler(quint8 cmd)
{
    scope_settings->Settings::time_scale_touch((Settings::touch_cmd) cmd);
    emit Scope::time_scaleChanged();
    emit Scope::time_delayChanged();
    emit Scope::rel_window_posChanged();
    scope_settings->settings_updated = 1;
}

quint16 Scope::getdisplay_pnts()
{
    return scope_settings->Settings::display_pnts;
}

void Scope::start_bt_scan()
{
    Scope::bt_device->startDeviceDiscovery();
}

void Scope::stop_bt_scan()
{
    Scope::bt_device->stopDeviceDiscovery();
}

void Scope::scan_services(const QString &address)
{
    if(bt_device->connected == 0)
    {
        Scope::bt_device->scanServices(address);
    }
}

QVariant Scope::getDevices()
{
    return Scope::bt_device->getDevices();
}

QVariant Scope::getServices()
{
    return Scope::bt_device->getServices();
}

QVariant Scope::getCharacteristics()
{
    return Scope::bt_device->getCharacteristics();
}

void Scope::device_connected()
{
    Scope::scope_settings->connection_state = Settings::FPGA_OFF;
    Scope::scope_settings->reconnect_bt = true;
    query_Telem();
    query_Power();
    emit connection_stateChanged();
}

void Scope::device_disconnected()
{
    scope_settings->connection_state = Settings::DISCONNECTED;
    emit connection_stateChanged();
}

Settings::con_state Scope::connection_state()
{
    return scope_settings->connection_state;
}

void Scope::disconnect_device()
{
    if(bt_device->connected == true)
    {
        Scope::bt_device->disconnectFromDevice();
    }
}

void Scope::connect_last_device()
{
    if((scope_settings->connection_state == Settings::DISCONNECTED) && (scope_settings->reconnect_bt == true))
    {
        bt_device->scanServices(bt_device->currentDevice.getAddress());
    }
}

void Scope::forget_last_device()
{
    Scope::scope_settings->reconnect_bt = false;
}

bool Scope::connected_device(QString address)
{
    if(Scope::bt_device->currentDevice.getAddress() == address)
    {
        return true;
    }
    else
    {
        return false;
    }
}
