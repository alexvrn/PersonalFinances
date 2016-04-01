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
    void resultProcess(bool result, const QString& comment = QString());
    void totalData(const QVariantList& data);
    void getStatistic(const QVariantList& data);

  public slots:
    void insert(const QVariantMap& data);// TODO: переименовать
    void statistic(const QDate& date = QDate());// TODO: переименовать

  private:
    void loadFromFile(const QString& dbFileName);

    DBWorker* m_dbWorker;
    QThread* m_thread;
};

#endif // DBCONTROLLER_H
