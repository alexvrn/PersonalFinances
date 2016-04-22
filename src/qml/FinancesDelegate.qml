import QtQuick 2.3
import QtQuick.Controls 1.2

import "material-qml/density.js" as Density
import "material-qml" as Material

Component {
  id: root

  //property int modelType: 2 // [0(Расход), 1(Доход), 2(Общее)] - тип модели

  // Модель:
  // type - тип расхода (Доход(1), Расход(0))
  // comment - комментарий
  // date - дата операции

  Item { // TODO: нужен ли этот элемент
    id: item
    width: parent.width
    height: 24 * Density.dp//contactInfo.height

    Material.MaterialShadow {
      id: sh1
      anchors.fill: wrapper
    }

    Rectangle {
      id: wrapper

      anchors {
        left: item.left
        leftMargin: 10*Density.dp
        right: item.right
        rightMargin: 10*Density.dp
        top: item.top
        bottom: item.bottom
      }

      //border.width: 1
      //border.color: type == 0 ? "#ef9a9a" : "#a5d6a7"
      color: type == 0 ? "#ef9a9a" : "#a5d6a7"
      opacity: 1.9
      radius: 3
      //antialiasing: true

      /*Text {
        id: iconResult
        anchors.right: parent.right
        anchors.rightMargin: 80
        anchors.verticalCenter: wrapper.verticalCenter
        anchors.verticalCenterOffset: 10

        text: result ? Icons.checked : Icons.close
        font.family: "Icons"
        font.pointSize: 3
        font.pixelSize: 70 * 1.0//Density.dp

        color: result ? "#4CAF50" : "#F44336"

        scale: 1
        opacity: 1.0
      }*/

      Text {
        id: commentText
        text: summa + "; " + comment
        color: "black"
        font.family: 'Roboto'
        font.pointSize: 10*Density.dp
        anchors.left: wrapper.left
        anchors.leftMargin: 10*Density.dp
        anchors.verticalCenter: wrapper.verticalCenter
      }

//      BusyIndicator {
//        id: bubble
//        anchors {
//          right: dateText.left
//        }

//        height: dateText.height / 2
//        width: height
//        anchors.verticalCenter: wrapper.verticalCenter
//        opacity: 1.0
//        visible: opacity !== 0.0
//      }

      Text {
        id: dateText
        text: date
        color: "black"
        font.family: 'Roboto'
        font.pointSize: 10*Density.dp
        anchors.right: wrapper.right
        anchors.rightMargin: 10*Density.dp
        anchors.verticalCenter: wrapper.verticalCenter
      }
//        Text {
//          id: textVerified
//          text: (access  ? (verified === "true" ? "Верификация пройдена" : "Верификация не пройдена") : "")
//          color: "#4CAF50"
//          font.family: 'Roboto'
//          font.pointSize: 13
//          anchors.top: accessInfo.bottom
//          anchors.horizontalCenter: iconAccess.horizontalCenter
//        }
    }
  }
}
