#ifndef FINANCESCONTROLLER_H
#define FINANCESCONTROLLER_H

// Qt
#include <QObject>

class FinancesController : public QObject
{
  Q_OBJECT

  public:
    explicit FinancesController(QObject* parent = 0);

  signals:
    void resultProcess(bool result);

  public slots:
    void process(const QVariantMap& data);
};

#endif // FINANCESCONTROLLER_H
