#ifndef DBCONTROLLER_H
#define DBCONTROLLER_H

// Qt
#include <QObject>
#include <QDate>
#include <QVariantList>
#include <QThread>

// DB
#include <DBWorker.h>

class DBController : public QObject
{
  Q_OBJECT

  public:
    explicit DBController(const QString& dbFileName = QString(), QObject *parent = 0);
    ~DBController();

  signals:
    void resultProcess(bool result, const QVariantMap& resultData = QVariantMap(), const QString& comment = QString());
    void totalData(const QVariantList& data);
    void getStatistic(const QVariantList& data, int total = 0, int income = 0, int consumption = 0);

  public slots:
    void insert(const QVariantMap& data, int year = -1, int month = -1, int day = -1);// TODO: переименовать
    void statistic(const QDate& date = QDate());// TODO: переименовать

  private:
    void loadFromFile(const QString& dbFileName);

    DBWorker* m_dbWorker;
    QThread* m_thread;
};

#endif // DBCONTROLLER_H
