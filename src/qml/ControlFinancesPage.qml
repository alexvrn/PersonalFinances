import QtQuick 2.3
import QtQuick.Controls 1.2

import "icons.js" as Icons

import "material-qml" as Material
import "material-qml/density.js" as Density
import "StyleColor.js" as StyleColor

Item {
  id: root

  function __clearComponent() {
    //comment.text = ""
    //summaSpinBox.value = 0;
    // текущее время
    //root.enabled = true
    //processIndicator.visible = false
    //iconResult.opacity = 0.0
  }

  function loadData() {
    return;
    var vList = DBController.statistic()// по умолчанию запрашиваем текущий месяц

    financesTotalModel.clear()
    financesAdditionModel.clear()
    financesDeletionModel.clear()

    for (var i = 0; i < vList.length; i++) {
      var v = vList[i]
      financesTotalModel.append({
        id: v["id"],
        comment: v["comment"],
        date: v["date"],
        summa: v["summa"],
        type: (v["summa"] > 0) ? 1 : 0
      });

      if (v["summa"] > 0)
        financesAdditionModel.append({
          id: v["id"],
          comment: v["comment"],
          date: v["date"],
          summa: v["summa"],
          type: 1
        });
      else
        financesDeletionModel.append({
          id: v["id"],
          comment: v["comment"],
          date: v["date"],
          summa: v["summa"],
          type: 0
        });
    }
  }

  onVisibleChanged: {
    __clearComponent()
  }

  property bool __resultCalculate: false

  property int __margin: 2*Density.dp

  signal back

  Component.onCompleted: {
    calendarDialog.setDate(new Date())
  }

  Connections {
    target: DBController

    onResultProcess: {
      __resultCalculate = result

      // Если операция прошла успешно, то запрашиваем обновление информации
      if (result)
      {
        if (dateCheck)
          DBController.statistic(new Date(calendarDialog.year, calendarDialog.month))
        else
          DBController.statistic()
      }
      else {
        console.error("ERROR")
      }
//      root.enabled = true
//      processIndicator.visible = false
//      iconResult.opacity = 1.0

//      if (__resultCalculate) {
//        cancelTimer.start()
    }

    onGetStatistic: {
      financesTotalModel.clear()
      financesAdditionModel.clear()
      financesDeletionModel.clear()

      for (var i = 0; i < data.length; i++) {
        var v = data[i]
        financesTotalModel.append({
          id: v["id"],
          comment: v["comment"],
          date: v["date"],
          summa: v["summa"],
          type: (v["summa"] > 0) ? 1 : 0
        });

        if (v["summa"] > 0)
          financesAdditionModel.append({
            id: v["id"],
            comment: v["comment"],
            date: v["date"],
            summa: v["summa"],
            type: 1
          });
        else
          financesDeletionModel.append({
            id: v["id"],
            comment: v["comment"],
            date: v["date"],
            summa: v["summa"],
            type: 0
          });
      }
    }
  }

  Timer {
    id: cancelTimer
    interval: 1000
    repeat: false
    onTriggered: {
      root.back()
    }
  }

  Image {
    id: background
    anchors.fill: root
    fillMode: Image.Tile
    horizontalAlignment: Image.AlignLeft
    verticalAlignment: Image.AlignTop
    source: "qrc:/icons/money.jpg"
    opacity: 0.15
  }

  Item {
    id: dateSettingItem
    anchors {
      top: root.top
      topMargin: 10*Density.dp
      left: root.left
      leftMargin: 2*Density.dp
      right: root.right
      rightMargin: 2*Density.dp
    }
    height: root.height / 15

    Material.PaperToogleButton {
      id: dateSwitch

      checked: false
      anchors {
        verticalCenter: dateSettingItem.verticalCenter
        left: dateSettingItem.left
        leftMargin: 2*Density.dp
      }

      onCheckedChanged: {
        // Отправляем запрос БД
        if (checked)
          DBController.statistic(new Date(calendarDialog.year, calendarDialog.month));
        else
          DBController.statistic();
      }
    }


  /*Material.PaperCheckBox {
    id: dateCheck

    checked: false
    anchors {
      top: root.top
      topMargin: 10*Density.dp
      left: root.left
      leftMargin: 2*Density.dp
      verticalCenter: calendarText.verticalCenter
    }
    //width: root.width / 20
    //height: root.width / 20

    onCheckedChanged: {
      // Отправляем запрос БД
      if (checked)
        DBController.statistic(new Date(calendarDialog.year, calendarDialog.month));
      else
        DBController.statistic();
    }
  }*/

    Item {
      id: calendarItem

      anchors {
        right: dateSettingItem.right
        rightMargin: 2*Density.dp
        verticalCenter: dateSwitch.verticalCenter
        left: dateSwitch.right
      }
      height: dateSwitch.height

      Material.AnimatedText {
        id: calendarText

        color: "#616161"
        text: Qt.formatDate(new Date, "MM.yyyy") // ставим текущюю дату
        font.pixelSize: 16*Density.dp
        font.bold: true
        anchors {
          verticalCenter: calendarItem.verticalCenter
          right: calendar.left
          rightMargin: 10*Density.dp
        }
        animation: calendarText.flipAnimation
        opacity: dateSwitch.checked ? 1.0 : 0.3
        Behavior on opacity { NumberAnimation { duration: 100 } }
      }

      Material.GlowShadow {
        id: calendarShadow
        anchors.fill: calendar
        radius: 1
        depth: 5
      }

      CalendarButton {
        id: calendar

        anchors {
          right: calendarItem.right
          rightMargin: 2*Density.dp
          verticalCenter: calendarItem.verticalCenter
        }
        height: dateSettingItem.height*0.8
        width: height

        z: 100

        opacity: dateSwitch.checked ? 1.0 : 0.3
        Behavior on opacity { NumberAnimation { duration: 100 } }

        onClicked: {
          if (dateSwitch.checked)
            calendarDialog.show()
        }
      }
    }// Item
  }// Item

  CalendarDayYearDialog {
    id: calendarDialog

    onDateSelected: {
      calendarText.text = Qt.formatDate(calendarDialog.date(), "MM.yyyy")

      // Отправляем запрос БД
      DBController.statistic(new Date(calendarDialog.year, calendarDialog.month))
    }
  }

  ListModel {
    id: financesTotalModel
  }

  ListModel {
    id: financesAdditionModel
  }

  ListModel {
    id: financesDeletionModel
  }

  FinancesDelegate {
    id: totalDelegate
  }

  FinancesDelegate {
    id: additionDelegate
  }

  FinancesDelegate {
    id: deletionDelegate
  }

  Material.PaperTabView {
    id: financesTabView

    tabBackgroundColor: StyleColor.mainFocusColor
    tabTextColor: "white"
    highlightColor: "yellow"
    cellWidth: width / 3
    tabFontSize: 8

    anchors {
      top: dateSettingItem.bottom
//      topMargin: __margin
      bottom: parent.bottom
//      bottomMargin: __margin
      left: parent.left
//      leftMargin: __margin
      right: parent.right
//      rightMargin: __margin
      bottomMargin: 10*Density.dp
      margins: __margin
    }

    Material.PaperTab {
      title: "Общий"
      Item {  // Rectangle
        id: rootTotal

        FinancesListView {
          id: financesTotalView
          anchors {
            left: rootTotal.left
            right: rootTotal.right
            top: rootTotal.top
            bottom: rootTotal.bottom
          }
          financesModel: financesTotalModel
          financesDelegate: totalDelegate
        }
        /*Material.PaperButton {
          id: financesAdditionButton
          text: "Добавить"
          color: StyleColor.mainColor
          focusColor: StyleColor.mainFocusColor
          pressedColor: StyleColor.mainPressedColor
          colored: true
          anchors {
            left: parent.left
            leftMargin: __margin
            right: parent.horizontalCenter
            rightMargin: 3 * Density.dp
            bottom: parent.bottom
            bottomMargin: __margin
          }
          height: parent.height / 10

          onClicked: {
            var data = {}
            //data["date"] = Qt.formatDate(calendarDialog.getDate(), "dd.MM.yyyy")
            data["comment"] = dataComponent.comment
            data["summa"] = dataComponent.summa
            DBController.insert(data)
          }

          Material.ActionButton {
            id: menuBackButton1
            y: -50

            Material.PaperAddButton {
              id: plus
              //anchors.fill: menuBackButton1
            }
            onClicked: {
              plus.state = "wait";
            }
          }
        }*/
      }
    }
    Material.PaperTab {
      title: "Доход"
      Item {
        id: rootAddition

        FinancesListView {
          id: financesAdditionView
          anchors {
            left: rootAddition.left
            right: rootAddition.right
            top: rootAddition.top
            bottom: rootAddition.bottom
          }
          financesModel: financesAdditionModel
          financesDelegate: additionDelegate
        }
      }
    }
    Material.PaperTab {
      title: "Расход"
      Item {
        id: rootDeletion

        FinancesListView {
          id: financesDeletionView
          anchors {
            left: rootDeletion.left
            right: rootDeletion.right
            top: rootDeletion.top
            bottom: rootDeletion.bottom
          }
          financesModel: financesDeletionModel
          financesDelegate: deletionDelegate
        }
      }
    }
  }// TabView

  InputDataDialog {
    id: inputDataDialog
  }

  Material.ActionButton {
    id: controlButton
    anchors {
      right: parent.right
      rightMargin: 15 * Density.dp
      bottomMargin: 15 * Density.dp
      bottom: parent.bottom
    }

    Material.MaterialShadow {
      anchors.fill: controlButton
      radius: controlButton.width
      depth: 1
      animated: true
    }

    Rectangle {
      id: control
      anchors {
        fill: controlButton
        leftMargin: 5*Density.dp
        topMargin: 5*Density.dp
      }
      color: "#2E7D32"
      radius: controlButton.width
      opacity: 0.9
    }

    Text {
     anchors.centerIn: control
     text: Icons.menu
     color: "white"
     font.pointSize: 15
    }

    onClicked: {
      inputDataDialog.show()
    }
  }
}
