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
    void resultProcess(bool result, const QString& comment = QString());
    void totalData(const QVariantList& data);
    void getStatistic(const QVariantList& data);

  public slots:
    void insert(const QVariantMap& data);// TODO: переименовать
    void statistic(const QDate& date = QDate());// TODO: переименовать
};

#endif // DBWORKER_H
