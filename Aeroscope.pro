TARGET = Aeroscope
INCLUDEPATH += .

QT += core qml quick bluetooth widgets svg xml

DESTDIR +=  ./build

CONFIG += c++11

SOURCES += main.cpp \
    device.cpp \
    deviceinfo.cpp \
    serviceinfo.cpp \
    characteristicinfo.cpp \
    scope.cpp \
    settings.cpp

OTHER_FILES += assets/*.qml

HEADERS += \
    device.h \
    deviceinfo.h \
    serviceinfo.h \
    characteristicinfo.h \
    scope.h \
    settings.h

RESOURCES += \
    resources.qrc

DISTFILES += \
    #assets/* \
    assets/Arrow.qml \
    assets/Ascope_Home.qml \
    assets/Batt_Icon.qml \
    assets/Cntrl_Btns.qml \
    assets/Connection_Menu.qml \
    assets/Fps_Calc.qml \
    assets/Gain_Cntrls_Pop.qml \
    assets/Gain_Settings_List.qml \
    assets/Gnd_Symb.qml \
    assets/Gnd_View.qml \
    assets/H_Trigger_View.qml \
    assets/Hamburger_Menu.qml \
    assets/Input_Couple_Btn.qml \
    assets/Label.qml \
    assets/MyButton.qml \
    assets/MyImageButton.qml \
    assets/MyLabelButton.qml \
    assets/Run_Stop_Btn.qml \
    assets/Scope_Canvas.qml \
    assets/Scope_Grid.qml \
    assets/Settings_Menu.qml \
    assets/Time_Cntrls_Pop.qml \
    assets/Time_Settings_List.qml \
    assets/Trig_Sel_Button.qml \
    assets/Trigger_Carrot.qml \
    assets/Trigger_Menu_Pop.qml \
    assets/Trigger_Slider.qml \
    assets/V_Trigger_View.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    images/icon-76@2x.png \
    images/batt_images/batt_background.svg \
    images/batt_images/batt_charging.svg \
    images/batt_images/batt_dead.svg \
    images/batt_images/batt_empty.svg \
    images/batt_images/batt_full.svg \
    images/batt_images/batt_fullcharge.svg \
    images/batt_images/batt_low.svg \
    images/batt_images/batt_mid.svg \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
#QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

target.path = /Users/alexa/Dropbox/qt_code/Aeroscope/build
INSTALLS += target

# Default rules for deployment.
#qnx: target.path = /tmp/$${TARGET}/bin
#else: unix:!android: target.path = /opt/$${TARGET}/bin
#!isEmpty(target.path): INSTALLS += target
