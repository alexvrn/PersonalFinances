import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Material.Dialog {
  id: timeDialog

  Rectangle {
    color: "#0277bd"
    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
    }
    height: 40*Density.dp

    Text {
      id: hourLabel
      color: "white"
      text: "02"
      anchors {
        right: parent.horizontalCenter
      }
      width: 20*Density.dp
      MouseArea {
        anchors.fill: hourLabel
        onClicked: time.selectHour()
      }
    }
    Text {
      id: minuteLabel
      color: "white"
      text: "04"
      anchors {
        left: parent.horizontalCenter
      }
      width: 20*Density.dp
      MouseArea {
        anchors.fill: minuteLabel
        onClicked: time.selectMinute()
      }
    }
  }

  Time {
    id: time
    anchors {
      bottom: okButton.top
      bottomMargin: 20*Density.dp
      horizontalCenter: parent.horizontalCenter
    }
  }

  Material.PaperButton {
    id: cancelButton

    width: 40*Density.dp
    anchors {
      right: okButton.left
      rightMargin: 3*Density.dp
      bottomMargin: 10*Density.dp
      bottom: parent.bottom
    }

    context: "dialog"
    text: "Отмена"

    onClicked: {
      time.clear()
      timeDialog.close()
    }
  }

  Material.PaperButton {
    id: okButton

    width: 60*Density.dp
    anchors {
      right: parent.right
      bottomMargin: 10*Density.dp
      bottom: parent.bottom
    }

    context: "dialog"
    text: "OK"

    onClicked: {
      time.clear()
      timeDialog.close()
    }
  }
}
