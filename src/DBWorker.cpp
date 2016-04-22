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


void DBWorker::insert(const QVariantMap& data, int year, int month, int day)
{
  QString script("INSERT INTO PersonalFinances(summa, comment, date) VALUES (?,?,?)");
  QSqlQuery query;
  query.prepare(script);
  query.addBindValue(data["summa"]);
  query.addBindValue(data["comment"]);
  QDate date;
  if (year == -1)
    date = QDate::currentDate();
  else
    date = QDate(year, month, day);
  query.addBindValue(date.toJulianDay());

  QVariantMap resultDate;
  resultDate["summa"] = data["summa"];
  resultDate["comment"] = data["comment"];
  resultDate["date"] = date.toString("dd.MM.yyyy");
  if (!query.exec())
  {
    qCritical("%s", query.lastError().text().toStdString().c_str());
    emit resultProcess(false, resultDate, query.lastError().text());
  }
  else
  {
    // Если добавление данных прошло успешно, то нужно посчитать статистику(общий, доход, расход)
    emit resultProcess(true, resultDate);
  }
}


void DBWorker::statistic(const QDate& date)
{
  QString script("SELECT * FROM PersonalFinances");
  if (!date.isNull()) // Если дата задана, то получаем всю инфу
  {
    // Сделано для того, чтобы месяц в запросе был в формате mm
    QString month = QString("%1").arg(date.month(), 2, 10, QChar('0'));
    script += QString(" WHERE strftime('%m', date)='%1' AND strftime('%Y', date)='%2'").arg(month).arg(date.year());
    qDebug() << script;
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
    int total = 0;
    int income = 0;
    int consumption = 0;
    while (query.next())
    {
      int summa = query.value("summa").toInt();
      QVariantMap v;
      v["id"] = query.value("id");
      v["summa"] = summa;
      v["comment"] = query.value("comment");
      v["date"] = QDate::fromJulianDay(query.value("date").toInt()).toString("dd.MM.yyyy");
      result.append(v);

      total += summa;
      if (summa >= 0)
        income += summa;
      else
        consumption += summa;
    }
    emit getStatistic(result, total, income, qAbs(consumption));
  }
}
