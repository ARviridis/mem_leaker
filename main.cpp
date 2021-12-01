#include <QCoreApplication>
#include <QTextStream>
#include "header.h"
#include <QTimer>
#include <QThread>
#include <QProcess>
#define macr  QTextStream cout(stdout), cin(stdin); cout.setCodec("cp-1251"); cin.setCodec("cp-1251");

at::at(QObject *parent) : QObject(parent) {
    macr
    pt = 0;
}

void at::slot_tread_mem1() {
    macr
        cout << '\r' << "new_pila";
    pt = pt + 1;
    cout << pt;
    float * uk;
    uk = new float[100000];
    if (pt % 2 > 0) {
        for (int i = 0; i < 100000; i++)
        {
            uk[i] = i * 2 + 1;
        }
        cout << " -- ";
    }
    if (pt % 2 == NULL) {
        cout << "  | ";
    }
    QThread::sleep(1);
    delete[] uk;
}
void at::slot_tread_mem2() {
    macr
        cout << '\r' << "new_pila";
    pt = pt + 1;
    cout << pt;
    char *uk = NULL;

    if (pt % 2 > 0) {
        for (int i = 0; i < 1000; i++) {
            uk = new char[1000];
        }
        cout << " -- ";
    }

    if (pt % 2 == NULL) {
        cout << "  | ";
    }
    delete[] uk;
}

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "Russian");
    macr
        QCoreApplication app(argc, argv);

    if (argc <= 1) {
        if (argv[0])
            cout << argv[0] << endl;
        else
            cout << "Net argv0" << endl;
    }

    if (argc == 1) {
        cout << "no arguments!" << endl;
    }

    cout << "PID__" << QCoreApplication::applicationPid() << endl;

    if (argc > 1) {

        cout << QObject::tr("Vivod dlya leaks mass") << endl;
        at *At = new at();
        QString var = QObject::tr(argv[1]);
        QThread *thread1 = new QThread;
        At->moveToThread(thread1);
        QTimer *timer = new QTimer;
        int aOutTime = 1500;
        timer->start(aOutTime);

        cout << "yes arg" << endl;
        for (int i = 1; i < argc; i++) {
            if (QObject::tr(argv[1]) == QString("-a")) {
                cout << argv[i] << " - zapusk piloobraznii neitralnii" << endl;
                QObject::connect(thread1, SIGNAL(started()), At, SLOT(slot_tread_mem1()));
                QObject::connect(timer, SIGNAL(timeout()), At, SLOT(slot_tread_mem1()));
            }
            if (QObject::tr(argv[1]) == QString("-b")) {
                cout << argv[i] << " - zapusk piloobraznii rastushii" << endl;
                QObject::connect(thread1, SIGNAL(started()), At, SLOT(slot_tread_mem2()));
                QObject::connect(timer, SIGNAL(timeout()), At, SLOT(slot_tread_mem2()));
            }
            if ((QObject::tr(argv[i]) != QString("-a")) && (QObject::tr(argv[i]) != QString("-b"))) {
                cout << "argument not found - '" << argv[i] << "'" << endl;
            }
        }
        thread1->start();
    }
    return app.exec();
}