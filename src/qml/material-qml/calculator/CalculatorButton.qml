import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

//Material.PaperButton {
Item {
  id: root

  property bool isNumber: false
  property string type: ""

  property color color: "white"
  property string text: ""

  width: 40*Density.dp
  height: 40*Density.dp

  function setSize(size) {
    button.width = size
    button.height = size
  }

  Material.PaperButton {
    id: button
    colored: true
    radius: Density.dp*7
    color: parent.color
    text: parent.text

    width: 0
    height: 0

    anchors.centerIn: parent

    Behavior on width { NumberAnimation { easing.type: Easing.InQuad; duration: 300 } }
    Behavior on height { NumberAnimation { easing.type: Easing.InQuad; duration: 300 } }

    onClicked: {
      calculator.calculation(isNumber, text, type)
    }
  }
}
