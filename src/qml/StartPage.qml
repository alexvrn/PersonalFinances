import QtQuick 2.3
import QtQuick.Controls 1.2

import "material-qml" as Material
import "material-qml/density.js" as Density
import "StyleColor.js" as StyleColor

Item {
  id: root

  signal openControlFinances
  signal openStatistic

  Material.PaperButton {
    id: controlFinancesButton

    radius: 12
    color: StyleColor.mainColor
    focusColor: StyleColor.mainFocusColor
    pressedColor: StyleColor.mainPressedColor
    colored: true
    text: "Управление\nфинансами"
    font.pixelSize: 20 * Density.dp

    anchors {
      left: root.left
      leftMargin: 4
      right: root.right
      rightMargin: 4
      top: root.top
      topMargin: 4
    }

    height: root.height / 2 - 2

    onClicked: {
      root.openControlFinances()
    }
  }

  Material.PaperButton {
    id: statisticButton

    radius: 12
    color: StyleColor.mainColor
    focusColor: StyleColor.mainFocusColor
    pressedColor: StyleColor.mainPressedColor
    colored: true
    text: "Статистика\nрасходов"
    font.pixelSize: 20 * Density.dp

    anchors {
      left: root.left
      leftMargin: 4
      right: root.right
      rightMargin: 4
      top: controlFinancesButton.bottom
      topMargin: 4
      bottom: root.bottom
      bottomMargin: 4
    }

    Image {
      id: statIcon
      fillMode: Image.Stretch
      //source: "qrc:/icons/stat.jpg"
      anchors.fill: parent
      opacity: 0.1
    }

//    height: root.height / 2 - 2

    onClicked: {
      root.openStatistic()
    }
  }
}
