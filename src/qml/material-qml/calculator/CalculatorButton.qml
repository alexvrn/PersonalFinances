import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Material.PaperButton {
  id: root

  colored: true
  radius: Density.dp*7
  width: 0
  height: 0

  property bool isNumber: false

  Behavior on width { NumberAnimation { easing.type: Easing.InQuad; duration: 300 } }
  Behavior on height { NumberAnimation { easing.type: Easing.InQuad; duration: 300 } }

  onClicked: {
    calculator.calculation(isNumber, text)
  }
}
