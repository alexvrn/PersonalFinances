// Local
#include "FinancesController.h"

// Qt
#include <QDebug>

FinancesController::FinancesController(QObject* parent)
  : QObject(parent)
{
}


void FinancesController::process(const QVariantMap& data)
{
  emit resultProcess(true);
}
