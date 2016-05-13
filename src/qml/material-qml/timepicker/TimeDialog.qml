import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Material.Dialog {
  id: timeDialog

  Time {
    id: time
    anchors {
      bottom: parent.bottom
      horizontalCenter: parent.horizontalCenter
    }
  }
}
