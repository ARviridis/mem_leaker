QT -= gui

CONFIG += c++11 console
CONFIG -= app_bundle

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        main.cpp

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    header.h

QMAKE_LFLAGS += -s
QMAKE_LFLAGS += -Wl,-Bstatic,-rpath,"'libleaker/'"

LIBS += -Wl,-Bdynamic
QMAKE_LFLAGS += -Wl,-dynamic-linker -Wl,./libleaker/lib64/ld-2.28.so