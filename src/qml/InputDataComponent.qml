import QtQuick 2.0
import QtQuick.Controls 1.2

import "material-qml/density.js" as Density
import "material-qml" as Material
import "StyleColor.js" as StyleColor

Item {
  id: root

  property string comment: commentText.text
  property int summa: summaSpinBox.value

  height: commentText.height // TODO: чтобы высота была не нулевой (наверно это КОСТЫЛЬ)

  Material.PaperTextField {
    id: commentText

    //textColor: StyleColor.inputTextColor
    //placeholderTextColor: StyleColor.inputTextColor
    placeholderText: "Введите комментарий"
    anchors {
      left: root.left
      leftMargin: Density.dp
      bottom: root.bottom
      bottomMargin: Density.dp
    }
    width: root.width * 0.67
  }
  SpinBox {
    id: summaSpinBox

    minimumValue: 0
    suffix: " руб."
    anchors {
      left: commentText.right
      leftMargin: Density.dp
      verticalCenter: commentText.verticalCenter
      right: root.right
      rightMargin: 40*Density.dp
    }
  }
}
