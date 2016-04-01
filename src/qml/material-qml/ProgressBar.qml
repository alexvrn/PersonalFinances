import QtQuick 2.0
import QtQuick.Controls 1.3 as Controls
import "density.js" as Density


Controls.ProgressBar {
  property color color: "#2196F3"

  width: 200 * Density.dp
  height: 4 * Density.dp

  style: ProgressBarStyle {}
}
