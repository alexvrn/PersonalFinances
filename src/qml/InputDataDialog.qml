import QtQuick 2.3
import QtQuick.Controls 1.2

import "material-qml" as Material
import "material-qml/density.js" as Density


Material.Dialog {
  id: root
  title: "Данные"

  property string comment: commentText.text
  property int summa: summaSpinBox.value

  signal profit(string comment, int summa) // Доход
  signal expenditure(string comment, int summa) // Расход

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

  Rectangle {
    color: "#80cbc4"

    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      bottom: cancelButton.top
      bottomMargin: 1*Density.dp
    }

    Material.PaperTextField {
      id: commentText

      //textColor: StyleColor.inputTextColor
      //placeholderTextColor: StyleColor.inputTextColor
      placeholderText: "Введите комментарий"
      anchors {
        left: parent.left
        leftMargin: 2*Density.dp
        right: parent.right
        rightMargin: 2*Density.dp
      }
      //width: root.width * 0.67
    }

    SpinBox {
      id: summaSpinBox

      minimumValue: 0
      suffix: " руб."
      anchors {
        top: commentText.bottom
        topMargin: 2*Density.dp
        horizontalCenter: parent.horizontalCenter
      }
      width: root.width * 0.4
    }

    Material.ActionButton {
      id: actionButtonPlus
      anchors {
        top: summaSpinBox.bottom
        topMargin: 2*Density.dp
        right: parent.horizontalCenter
        rightMargin: 10*Density.dp
      }

      Material.PaperAddButton {
        id: plus
        anchors.centerIn: parent
      }
      onClicked: {
        comment = commentText.text
        summa = summaSpinBox.value
        plus.state = "wait";
        profit(commentText.text, summaSpinBox.value)
        close()
      }
    }

    Material.ActionButton {
      id: actionButtonMinus
      anchors {
        top: summaSpinBox.bottom
        topMargin: 2*Density.dp
        left: parent.horizontalCenter
        leftMargin: 10*Density.dp
      }

      Material.PaperAddButton {
        id: minus
        type: "minus"
        anchors.centerIn: parent
      }
      onClicked: {
        comment = commentText.text
        summa = -summaSpinBox.value
        //plus.state = "wait";
        expenditure(commentText.text, summaSpinBox.value)
        close()
      }
    }
  }

  Material.PaperButton {
    id: cancelButton

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottomMargin: 10 * Density.dp
      bottom: parent.bottom
    }

    context: "dialog"
    text: "Отмена"

    onClicked: {
      root.close()
    }
  }
}
