import QtQuick 2.3

import "material-qml" as Material
import "picker" as Picker
import "material-qml/density.js" as Density


Material.Dialog {
  id: root
  title: "Календарь"

  property int month: materialCalendar.month
  property int year: materialCalendar.year

  signal dateSelected

  function date() {
    return new Date(year, month)
  }

  function setDate(date) {
    materialCalendar.month = date.getMonth() + 1
    materialCalendar.year = date.getFullYear()
  }

  anchors {
    fill: parent
    top: parent.top
    topMargin: 10*Density.mm
    left: parent.left
    leftMargin: 4*Density.mm
    right: parent.right
    rightMargin: 4*Density.mm
    bottom: parent.bottom
    bottomMargin: 10*Density.mm
  }

  MaterialDayYearEdit {
    id: materialCalendar

    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      bottom: okButton.top
      bottomMargin: 1*Density.dp
    }
  }

  Material.PaperButton {
    id: okButton

    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.bottomMargin: 10 * Density.dp
    anchors.bottom: parent.bottom

    context: "dialog"
    text: "Готово"

    onClicked: {
      dateSelected()
      root.close()
    }
  }
  Material.PaperButton {
    id: cancelButton

    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.bottomMargin: 10 * Density.dp
    anchors.bottom: parent.bottom

    context: "dialog"
    text: "Отмена"

    onClicked: {
      root.close()
    }
  }
}
