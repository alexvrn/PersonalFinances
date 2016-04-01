#ifndef DENSITYCONTROLLER_H
#define DENSITYCONTROLLER_H

// Qt
#include <QObject>

class DensityController : public QObject
{
  Q_OBJECT
  Q_PROPERTY(qreal dp READ dp)
  Q_PROPERTY(qreal mm READ mm)

  public:
    explicit DensityController(QObject* parent = 0);

    qreal dp() const;
    qreal mm() const;

  private:
    qreal m_dp;
    qreal m_mm;
};

#endif // DENSITYCONTROLLER_H
