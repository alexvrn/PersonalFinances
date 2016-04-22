#ifndef DBWORKER_H
#define DBWORKER_H

// Qt
#include <QObject>
#include <QDate>
#include <QVariantList>

class DBWorker : public QObject
{
  Q_OBJECT

  public:
    explicit DBWorker(const QString& dbFileName = QString(), QObject* parent = 0);

  signals:
    void resultProcess(bool result, const QVariantMap& resultData = QVariantMap(), const QString& comment = QString());
    void totalData(const QVariantList& data);
    void getStatistic(const QVariantList& data, int total = 0, int income = 0, int consumption = 0);

  public slots:
    void insert(const QVariantMap& data, int year = -1, int month = -1, int day = -1);// TODO: переименовать
    void statistic(const QDate& date = QDate());// TODO: переименовать
};

#endif // DBWORKER_H
