/***************************************************************************
**
** Copyright (C) 2013 BlackBerry Limited. All rights reserved.
** Copyright (C) 2015 The Qt Company Ltd.
** Copyright (C) 2017 Aeroscope Labs LLC
**
** Contact: http://www.qt.io/licensing/
**
** This file is part of the QtBluetooth module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "device.h"
#include "scope.h"
#include <qbluetoothaddress.h>
#include <qbluetoothdevicediscoveryagent.h>
#include <qbluetoothlocaldevice.h>
#include <qbluetoothdeviceinfo.h>
#include <qbluetoothservicediscoveryagent.h>
#include <QtCharts/QXYSeries>
#include <QtCharts/QAreaSeries>
#include <QDebug>
#include <QList>
#include <QTimer>

#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QtCore/QtMath>

//Q_DECLARE_METATYPE(QtCharts::QAbstractSeries *)

Device::Device(Scope *scope_t=0):
    connected(false), parent(scope_t), controller(0), m_deviceScanState(false)/*, randomAddress(false)*/
{
    //! [les-devicediscovery-1]
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    connect(discoveryAgent, SIGNAL(deviceDiscovered(const QBluetoothDeviceInfo&)),
            this, SLOT(addDevice(const QBluetoothDeviceInfo&)));
    connect(discoveryAgent, SIGNAL(error(QBluetoothDeviceDiscoveryAgent::Error)),
            this, SLOT(deviceScanError(QBluetoothDeviceDiscoveryAgent::Error)));
    connect(discoveryAgent, SIGNAL(finished()), this, SLOT(deviceScanFinished()));
    //! [les-devicediscovery-1]
    aeroscope_Uuid = QBluetoothUuid(QStringLiteral("{F9541234-91B3-BD9A-F077-80F2A6E57D00}"));
    Data_Out_Uuid = QBluetoothUuid(QStringLiteral("{00001239-0000-1000-8000-00805f9b34fb}"));
}

Device::~Device()
{
    delete discoveryAgent;
    delete controller;
    qDeleteAll(devices);
    qDeleteAll(m_services);
    qDeleteAll(m_characteristics);
    devices.clear();
    m_services.clear();
    m_characteristics.clear();
}

void Device::startDeviceDiscovery()
{
    qDeleteAll(devices);
    devices.clear();
    emit devicesUpdated();

    if(connected)
    {
        Device::addDevice(Device::currentDevice.getDevice());
    }

    setUpdate("Scanning for devices ...");
    //! [les-devicediscovery-2]
    discoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    //! [les-devicediscovery-2]

    if (discoveryAgent->isActive()) {
        m_deviceScanState = true;
        //Q_EMIT stateChanged();
    }
}

void Device::stopDeviceDiscovery()
{
    discoveryAgent->stop();
}

//! [les-devicediscovery-3]
void Device::addDevice(const QBluetoothDeviceInfo &info)
{// F9541234-91B3-BD9A-F077-80F2A6E57D00
    qDebug() << "Device Discovered with UUIDs:" << info.serviceUuids();
    QList<QBluetoothUuid> device_uuid = info.serviceUuids();
    if ((info.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) && (device_uuid[0] == aeroscope_Uuid)) {
        DeviceInfo *d = new DeviceInfo(info);
        devices.append(d);
        setUpdate("Last device added: " + d->getName());
        emit devicesUpdated();
    }
}
//! [les-devicediscovery-3]

void Device::deviceScanFinished()
{
    emit devicesUpdated();
    m_deviceScanState = false;
    emit stateChanged();
    if (devices.isEmpty())
        setUpdate("No Low Energy devices found...");
    else
        setUpdate("Done! Scan Again!");
}

QVariant Device::getDevices()
{

    return QVariant::fromValue(devices);
}

QVariant Device::getServices()
{
    return QVariant::fromValue(m_services);
}

QVariant Device::getCharacteristics()
{
    return QVariant::fromValue(m_characteristics);
}

void Device::reconnect()
{
    QString address = currentDevice.getAddress();
    scanServices(address);
}

void Device::scanServices(const QString &address)
{
    // We need the current device for service discovery.
    //qDebug() << "stopping scan";
    discoveryAgent->stop();
    qDebug() << "scan stopped";

    for (int i = 0; i < devices.size(); i++) {
        if (((DeviceInfo*)devices.at(i))->getAddress() == address )
            currentDevice.setDevice(((DeviceInfo*)devices.at(i))->getDevice());
    }

    if (!currentDevice.getDevice().isValid()) {
        qWarning() << "Not a valid device";
        return;
    }

    qDeleteAll(m_characteristics);
    m_characteristics.clear();
    emit characteristicsUpdated();
    qDeleteAll(m_services);
    m_services.clear();
    emit servicesUpdated();

    setUpdate("Back\n(Connecting to device...)");

    if (controller && m_previousAddress != currentDevice.getAddress()) {
        controller->disconnectFromDevice();
        delete controller;
        controller = 0;
    }

    //! [les-controller-1]
    if (!controller) {
        // Connecting signals and slots for connecting to LE services.
        controller = new QLowEnergyController(currentDevice.getDevice());
        connect(controller, SIGNAL(connected()),
                this, SLOT(deviceConnected()));
        connect(controller, SIGNAL(error(QLowEnergyController::Error)),
                this, SLOT(errorReceived(QLowEnergyController::Error)));
        connect(controller, SIGNAL(disconnected()),
                this, SLOT(deviceDisconnected()));
        connect(controller, SIGNAL(serviceDiscovered(QBluetoothUuid)),
                this, SLOT(addLowEnergyService(QBluetoothUuid)));
        connect(controller, SIGNAL(discoveryFinished()),
                this, SLOT(serviceScanDone()));
    }

    controller->setRemoteAddressType(QLowEnergyController::PublicAddress);
    controller->connectToDevice();
    //! [les-controller-1]

    m_previousAddress = currentDevice.getAddress();
}

void Device::addLowEnergyService(const QBluetoothUuid &serviceUuid)
{
    //! [les-service-1]
    QLowEnergyService *service = controller->createServiceObject(serviceUuid);
    qDebug() << "Discovered Service, Name =" << service->serviceName() << "UUID = " << service->serviceUuid();

    if (!service) {
        qWarning() << "Cannot create service for uuid";
        return;
    }
    //! [les-service-1]
    ServiceInfo *serv = new ServiceInfo(service);
    m_services.append(serv);

    emit servicesUpdated();
}
//! [les-service-1]

void Device::serviceScanDone()
{
    setUpdate("Back\n(Service scan done!)");
    qDebug() << "Service scan complete!";
    // force UI in case we didn't find anything
    if (m_services.isEmpty())
        emit servicesUpdated();
    Device::connectToService(Primary_Service_Uuid);
}

void Device::connectToService(const QString &uuid)
{
    qDebug() << "Connecting to service:" << uuid;
    QLowEnergyService *service = 0;
    for (int i = 0; i < m_services.size(); i++) {
        ServiceInfo *serviceInfo = (ServiceInfo*)m_services.at(i);
        if (serviceInfo->getUuid() == uuid) {
            service = serviceInfo->service();
            break;
        }
    }

    if (!service)
        return;

    qDeleteAll(m_characteristics);
    m_characteristics.clear();
    emit characteristicsUpdated();

    if (service->state() == QLowEnergyService::DiscoveryRequired) {
        //! [les-service-3]
        connect(service, SIGNAL(stateChanged(QLowEnergyService::ServiceState)),
                this, SLOT(serviceDetailsDiscovered(QLowEnergyService::ServiceState)));
        connect(service, SIGNAL(characteristicChanged(QLowEnergyCharacteristic,QByteArray)),
                this, SLOT(scope_out_updated(QLowEnergyCharacteristic,QByteArray)));
        service->discoverDetails();
        setUpdate("Back\n(Discovering details...)");
        //! [les-service-3]
        return;
    }

    //discovery already done
    const QList<QLowEnergyCharacteristic> chars = service->characteristics();
    foreach (const QLowEnergyCharacteristic &ch, chars) {
        CharacteristicInfo *cInfo = new CharacteristicInfo(ch);
        m_characteristics.append(cInfo);
    }

    QTimer::singleShot(0, this, SIGNAL(characteristicsUpdated()));
}

void Device::scope_out_updated(QLowEnergyCharacteristic characteristic_obj,QByteArray characteristic_data)
{
    qDebug() << "Characteristic Updated - UUID:" << characteristic_obj.uuid() << "Data:" << characteristic_data;

    QBluetoothUuid char_uuid = characteristic_obj.uuid();

    if(char_uuid.toUInt16() == Scope_Out_Char)//scope out characteristic updated
    {
        parent->Scope::refresh_scope_out_char(characteristic_data);
    }
    else if(char_uuid.toUInt16() == Scope_Data_Char)//scope data characteristic is only other output characteristic
    {
        parent->Scope::scope_Data_Update(characteristic_data);
    }
    else
    {
        qDebug() << "unknown characteristic updated!";
    }
}

void Device::deviceConnected()
{
    setUpdate("Back\n(Discovering services...)");
    qDebug() << "Connected to Device!";
    connection_retry = 5;
    connected = true;
    emit connect_signal();
    //! [les-service-2]
    controller->discoverServices();
    //! [les-service-2]
}

void Device::errorReceived(QLowEnergyController::Error /*error*/)
{
    qWarning() << "Error: " << controller->errorString();
    setUpdate(QString("Back\n(%1)").arg(controller->errorString()));

    if(Device::connection_retry != 0)
    {
        connection_retry--;
        QTimer::singleShot(500, this, SLOT(reconnect()));
    }
}

void Device::setUpdate(QString message)
{
    m_message = message;
    qDebug() << m_message;
    emit updateChanged();
}

void Device::disconnectFromDevice()
{
    // UI always expects disconnect() signal when calling this signal
    // TODO what is really needed is to extend state() to a multi value
    // and thus allowing UI to keep track of controller progress in addition to
    // device scan progress

    qDebug() << "Disconnected from Device!";

    if (controller->state() != QLowEnergyController::UnconnectedState)
        controller->disconnectFromDevice();
    else
        deviceDisconnected();
}

void Device::deviceDisconnected()
{
    qWarning() << "Disconnect from device";
    connected = false;
    emit disconnected();
    if(discoveryAgent->isActive())
    {
        discoveryAgent->stop();
        Device::startDeviceDiscovery();
    }
}

void Device::serviceDetailsDiscovered(QLowEnergyService::ServiceState newState)
{
    if (newState != QLowEnergyService::ServiceDiscovered) {
        // do not hang in "Scanning for characteristics" mode forever
        // in case the service discovery failed
        // We have to queue the signal up to give UI time to even enter
        // the above mode
        if (newState != QLowEnergyService::DiscoveringServices) {
            QMetaObject::invokeMethod(this, "characteristicsUpdated",
                                      Qt::QueuedConnection);
        }
        return;
    }

    QLowEnergyService *service = qobject_cast<QLowEnergyService *>(sender());
    if (!service)
        return;

    //! [les-chars]
    const QList<QLowEnergyCharacteristic> chars = service->characteristics();
    foreach (const QLowEnergyCharacteristic &ch, chars) {
        CharacteristicInfo *cInfo = new CharacteristicInfo(ch);
        qDebug() << "Characteristic Discovered - Name:" << ch.name() << "UUID:" << ch.uuid();

        m_characteristics.append(cInfo);
    }
    //! [les-chars]

    QLowEnergyCharacteristic scope_Out = service->characteristic(QBluetoothUuid(Device::Scope_Out_Char));
    QLowEnergyDescriptor scope_Out_notification = scope_Out.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);

    QLowEnergyCharacteristic scope_Data = service->characteristic(QBluetoothUuid(Device::Scope_Data_Char));
    QLowEnergyDescriptor scope_Data_notification = scope_Data.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);

    service->writeDescriptor(scope_Out_notification, QByteArray::fromHex("0100"));
    service->writeDescriptor(scope_Data_notification, QByteArray::fromHex("0100"));

    emit characteristicsUpdated();

    QTimer::singleShot(100, this, SIGNAL(service_details_discovered()));
    //emit service_details_discovered();
}

void Device::deviceScanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
        setUpdate("The Bluetooth adaptor is powered off, power it on before doing discovery.");
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
        setUpdate("Writing or reading from the device resulted in an error.");
    else
        setUpdate("An unknown error has occurred.");

    m_deviceScanState = false;
    emit devicesUpdated();
    //emit stateChanged();
}

bool Device::state()
{
    return m_deviceScanState;
}

bool Device::hasControllerError() const
{
    if (controller && controller->error() != QLowEnergyController::NoError)
        return true;
    return false;
}

void Device::write_Characteristic(quint16 characteristic_uuid, QByteArray characteristic_data)
{
    if (connected)
    {
        QLowEnergyService *service = 0;
        QLowEnergyCharacteristic characteristic;

        for (int i = 0; i < m_services.size(); i++) {
            ServiceInfo *serviceInfo = (ServiceInfo*)m_services.at(i);
            if (serviceInfo->getUuid() == Primary_Service_Uuid) {
                service = serviceInfo->service();
                break;
            }
        }

        for (int i = 0; i < m_characteristics.size(); i++) {
            CharacteristicInfo *charInfo = (CharacteristicInfo*)m_characteristics.at(i);
            characteristic = charInfo->getCharacteristic();
            QBluetoothUuid char_uuid = characteristic.uuid();
            if(characteristic_uuid == char_uuid.toUInt16())
            {
                break;
            }
        }

        qDebug() << "Tx - UUID" << characteristic_uuid << "Tx - Data" << characteristic_data;

        service->writeCharacteristic(characteristic, characteristic_data, QLowEnergyService::WriteWithoutResponse);
    }
}
