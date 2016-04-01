// Local
#include "DBController.h"

// Qt
#include <QDebug>
#include <QFile>
#include <QVariantMap>
#include <QStandardPaths>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QDateTime>

namespace
{
  const char* const dataBaseName = "PersonalFinances.db";
}

DBWorker::DBWorker(const QString& dbFileName, QObject* parent)
  : QObject(parent)
{
  Q_UNUSED(dbFileName)
}


void DBWorker::insert(const QVariantMap& data)
{
  QString script("INSERT INTO PersonalFinances(summa, comment, date) VALUES (?,?,?)");
  QSqlQuery query;
  query.prepare(script);
  query.addBindValue(data["summa"]);
  query.addBindValue(data["comment"]);
  query.addBindValue(QDate::currentDate().toJulianDay());
  if (!query.exec())
  {
    qCritical("%s", query.lastError().text().toStdString().c_str());
    emit resultProcess(false);
  }
  else
  {
    emit resultProcess(true);
  }
}


void DBWorker::statistic(const QDate& date)
{
  QString script("SELECT * FROM PersonalFinances");
  if (!date.isNull()) // Если дата задана
  {
    QString month = QString("%1").arg(date.month(), 2, 10, QChar('0'));
    script += QString(" WHERE strftime('%m', date)='%1' AND strftime('%Y', date)='%2'").arg(month).arg(date.year());
  }

  QSqlQuery query;
  query.prepare(script);
  if (!query.exec())
  {
    qCritical("%s", query.lastError().text().toStdString().c_str());
    emit getStatistic(QVariantList());
  }
  else
  {
    QVariantList result;
    while (query.next())
    {
      QVariantMap v;
      v["id"] = query.value("id");
      v["summa"] = query.value("summa").toInt();
      v["comment"] = query.value("comment");
      v["date"] = QDate::fromJulianDay(query.value("date").toInt()).toString("dd.MM.yyyy");
      result.append(v);
    }
    emit getStatistic(result);
  }
}
