import QtQuick 2.3
import QtQuick.Controls 1.2
//import "icons.js" as Icons

import "material-qml" as Material

Item {
  id: root

  signal back

  function init() {
    var log = logController.read();
    logModel.clear()
    for(var i = 0; i < log.length; i++)
    {
      logModel.append(
        {
          fio: log[i]["fio"],
          documentNumber: log[i]["documentNumber"],
          access: log[i]["access"],
          dateOfBirth: log[i]["dateOfBirth"],
          timeControl: Qt.formatDateTime(log[i]["timeControl"], "dd.MM.yyyy, hh:mm"),
          verified: log[i]["verified"]
        }
      )
    }
  }

  function logAccesInfo(access, verified)
  {
    var person = {}
    person["timeControl"] = new Date;
    person["dateOfBirth"] = personPage._dateOfBirth
    person["documentNumber"] = personPage._documentNumber
    person["fio"] = personPage._fio
    person["access"] = access
    person["verified"] = verified

    logController.write(person)
  }

  function logVerified()
  {
    logController.verified()
  }

  Text {
    id: header

    anchors.horizontalCenter: historyRect.horizontalCenter
    anchors.top: historyRect.top
    anchors.topMargin: 10

    font.weight: Font.Light
    font.family: 'Roboto'
    font.pointSize: 12

    text: "История расходов-доходов"
    color: "black"
  }
  Text {
    id: filterLabel

    anchors.top: header.top
    anchors.topMargin: 10

    font.weight: Font.Light
    font.family: 'Roboto'
    font.pointSize: 10

    text: "Выберите дату:"
    color: "black"
  }

  Rectangle {
    id: historyRect
    anchors.top: root.top
    anchors.topMargin: 10//parent.height * 0.45
    anchors.left: root.left
    anchors.leftMargin: 10
    anchors.right: root.right
    anchors.rightMargin: 10
    anchors.bottom: root.bottom
    anchors.bottomMargin: 10

    color: "white"
    opacity: 0.2
  }

  /*Calendar {
    id: historyCalendar

    anchors {
      top: header.bottom
      topMargin: 10
      horizontalCenter: historyRect.horizontalCenter
    }
    frameVisible: true
  }*/

  Material.PaperTabView {
    id: historyTabView

    tabBackgroundColor: "#089795"
    tabTextColor: "white"
    highlightColor: "yellow"
    cellWidth: historyTabView.width / 3
    tabFontSize: 8

    anchors {
      top: header.bottom
      topMargin: 10
      bottom: historyRect.bottom
      bottomMargin: 10
      left: historyRect.left
      leftMargin: 10
      right: historyRect.right
      rightMargin: 10
    }

    Material.PaperTab {
      title: "Общий"
      Rectangle {
        color: "darkgray"
        ListView {
          id: totalView
          anchors {
            fill: parent
            bottom: parent.bottom
            bottomMargin: 40
          }
        }
        Text {
          id: addTotalText
          anchors {
            top: totalView.bottom
            topMargin: 1
            left: parent.left
            leftMargin: 10
          }
          color: "green"
          text: qsTr("Доход")
        }
        Text {
          id: delTotalText
          anchors {
            top: totalView.bottom
            topMargin: 1
            right: parent.right
            leftMargin: 10
          }
          color: "red"
          text: qsTr("Расход")
        }
        Text {
          id: totalText
          anchors {
            top: totalView.bottom
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
          }
          color: "blue"
          text: qsTr("Общий доход")
        }
      }
    }
    Material.PaperTab {
      title: "Доход"
      Rectangle {
        color: "darkgray"
        ListView {
          id: addView
          anchors {
            fill: parent
            bottom: parent.bottom
            bottomMargin: 40
          }
        }
        Text {
          id: addText
          anchors {
            top: addView.bottom
            topMargin: 1
            horizontalCenter: parent.horizontalCenter
          }
          color: "green"
          text: qsTr("Доход")
        }
      }
    }
    Material.PaperTab {
      title: "Расход"
      Rectangle {
        color: "darkgray"
        ListView {
          id: delView
          anchors {
            fill: parent
            bottom: parent.bottom
            bottomMargin: 40
          }
        }
        Text {
          id: delText
          anchors {
            top: delView.bottom
            topMargin: 1
            horizontalCenter: parent.horizontalCenter
          }
          color: "red"
          text: qsTr("Расход")
        }
      }
    }
  }

  ListModel {
    id: historyModel
  }

  Component {
    id: historyDelegate

    Item {
      id: item
      width: log.width
      height: 210//contactInfo.height

      Rectangle {
        id: wrapper
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: item.top
        anchors.bottom: item.bottom
        border.color: "#b4cce9"
        opacity: 0.8
        antialiasing: true

        Text {
          id: iconAccess
          anchors.right: parent.right
          anchors.rightMargin: 80
          anchors.verticalCenter: wrapper.verticalCenter
          anchors.verticalCenterOffset: 10

          text: access ? Icons.checked : Icons.close
          font.family: "Icons"
          font.pixelSize: 70 * 1.0//Density.dp

          color: access ? "#4CAF50" : "#F44336"

          scale: 1
          opacity: 1.0
        }

        Text {
          id: accessInfo
          text: (access  ? "Проход разрешен" : "Проход запрещен")
          color: access  ? "#4CAF50" : "#F44336"
          font.family: 'Roboto'
          font.pointSize: 14
          anchors.top: iconAccess.bottom
          anchors.topMargin: access ? -10 : -3
          anchors.horizontalCenter: iconAccess.horizontalCenter
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

        Column {
          spacing: access ? 16 : 22
          anchors.fill: wrapper
          anchors.margins: 5
          anchors.leftMargin: 30
          anchors.topMargin: 10

          Text {
            id: fioInfo
            text: fio
            color: "black"
            font.family: 'Roboto'
            font.weight: Font.Light
            font.pointSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
          }

          Row {
            Text {
              id: birthdayLabel
              text: "Дата рождения: "
              color: "black"
              font.family: 'Roboto'
              font.pointSize: 14
            }
            Text {
              id: birthdayInfo
              text: dateOfBirth
              color: "black"
              font.weight: Font.Light
              font.family: 'Roboto'
              font.pointSize: 14
            }
          }

          Row {
            Text {
              id: numberLabel
              text: "Номер документа: "
              color: "black"
              font.family: 'Roboto'
              font.pointSize: 14
            }
            Text {
              id: numberInfo
              text: documentNumber
              color: "black"
              font.weight: Font.Light
              font.family: 'Roboto'
              font.pointSize: 14
            }
          }

          Row {
            Text {
              id: timeControlLabel
              text: "Дата и время контроля: "
              font.family: 'Roboto'
              font.pointSize: 14
            }
            Text {
              id: timeControlInfo
              text: timeControl

              font.weight: Font.Light
              font.family: 'Roboto'
              font.pointSize: 14
            }
          }

          Text {
            id: textVerified
            text: (access ? (verified ? "Верификация пройдена" : "Верификация не пройдена") : "")

            font.weight: Font.Light
            font.family: 'Roboto'
            font.pointSize: 14
          }
        }
      }
    }
  }



  ListView {
    id: historyView
    anchors.top: historyRect.top
    anchors.topMargin: 70
    anchors.bottom: historyRect.bottom

    anchors.horizontalCenter: historyRect.horizontalCenter
    anchors.bottomMargin: 10

    width: 800

    spacing: 20

    model: historyModel
    delegate: historyDelegate

    boundsBehavior: Flickable.StopAtBounds
    clip: true
  }
}

