// Qt
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>

// Controllers
#include "FinancesController.h"
#include "DensityController.h"
#include "DBController.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  QCoreApplication::setApplicationName("PersonalFinances");

  qSetMessagePattern("[%{function}:%{line}] %{type}: %{message}");

  FinancesController financesController;
  DensityController densityController;
  DBController dbController;

  QQmlApplicationEngine engine;
  QQmlContext* objectContext = engine.rootContext();
  objectContext->setContextProperty("FinancesController", &financesController);
  objectContext->setContextProperty("DensityController", &densityController);
  objectContext->setContextProperty("DBController", &dbController);

  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
