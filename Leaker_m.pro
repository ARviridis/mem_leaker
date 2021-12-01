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
#




#LIBS += -Wl,-Bdynamic
#LIBS += -Wl,-rpath libleaker/
#QMAKE_CXXFLAGS += -static-libgcc -static-libstdc++
#QMAKE_LFLAGS_RELEASE += -static -static-libgcc
#QMAKE_LFLAGS += -Wl,-rpath,"'lib/'"
#QMAKE_LFLAGS += -Wl,-dynamic-linker -Wl,/lib64/libdl.so
#unix:QMAKE_RPATHDIR += /lib
#QMAKE_LFLAGS += -s # Убрать все таблицы символов из результирующего бинарника ( man gcc ) # 3-rd party библиотеки, (boost, gmp, ... ) если есть статический вариант добавляем так:
#LIBS += -L/path/lib
# -static -static-libgcc
