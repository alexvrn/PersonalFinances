// Local
#include "DensityController.h"

// Qt
#include <QScreen>
#include <QApplication>
#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

DensityController::DensityController(QObject* parent)
  : QObject(parent)
  , m_dp(1.0)
  , m_mm(1.0)
{
#ifdef Q_OS_ANDROID
  QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
  QAndroidJniObject resource = activity.callObjectMethod("getResources","()Landroid/content/res/Resources;");
  QAndroidJniObject metrics = resource.callObjectMethod("getDisplayMetrics","()Landroid/util/DisplayMetrics;");

  m_dp = metrics.getField<float>("density");

  m_mm = displayMetrics.getField<int>("densityDpi");
#else
  QScreen *screen = qApp->primaryScreen();
  m_mm = screen->physicalDotsPerInch() * 2;
#endif
}


qreal DensityController::dp() const
{
  return m_dp;
}


qreal DensityController::mm() const
{
  return m_mm / 25.4;
}
