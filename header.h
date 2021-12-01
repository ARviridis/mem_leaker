#ifndef header_H
#define header_H
#include <QTimer>
class at : public QObject {
    Q_OBJECT
public:
    at(QObject *parent = 0);
public slots:
    void slot_tread_mem2();
    void slot_tread_mem1();
private:
    int aOutTime;
    int pt;
};
#endif // header_H
