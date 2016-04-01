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
      left: parent.left
      bottom: parent.bottom
      bottomMargin: 1
    }
    width: parent.width * 0.67
  }
  SpinBox {
    id: summaSpinBox

    minimumValue: 0
    suffix: " руб."
    anchors {
      left: commentText.right
      leftMargin: Density.dp
      verticalCenter: commentText.verticalCenter
      right: parent.right
      rightMargin: Density.dp
    }
  }
}
