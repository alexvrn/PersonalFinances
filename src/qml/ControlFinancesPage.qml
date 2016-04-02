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

    Component.onCompleted: {
      /*append({
               comment: "покупка в перекрестке",
               date: "21.06.2012",
               summa: 34,
               type: 1
             });
      append({
               comment: "в кафе",
               date: "24.06.2012",
               summa: -34,
               type: 0
             });*/
    }
  }

  ListModel {
    id: financesAdditionModel
  }

  ListModel {
    id: financesDeletionModel
  }

  FinancesDelegate {
    id: totalDelegate
    //modelType: 2
    //widthDelegate: rootTotal.width
  }

  FinancesDelegate {
    id: additionDelegate
    //modelType: 1
  }

  FinancesDelegate {
    id: deletionDelegate
   // modelType: 0
  }

  Material.PaperTabView {
    id: financesTabView

    tabBackgroundColor: StyleColor.mainFocusColor
    tabTextColor: "white"
    highlightColor: "yellow"
    сellWidth: financesTabView.width / 3
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
      bottomMargin: 20
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
            bottom: totalDataComponent.top
          }
          financesModel: financesTotalModel
          financesDelegate: totalDelegate
        }
        InputDataComponent {
          id: totalDataComponent
          anchors {
            left: parent.left
            right: parent.right
            bottom: financesAdditionButton.top
            bottomMargin: Density.dp
          }
        }
        Material.PaperButton {
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
            data["comment"] = totalDataComponent.comment
            data["summa"] = totalDataComponent.summa
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
        }
        Material.PaperButton {
          id: financesDeletionButton
          text: "Удалить"
          color: StyleColor.mainColor
          focusColor: StyleColor.mainFocusColor
          pressedColor: StyleColor.mainPressedColor
          colored: true
          anchors {
            left: parent.horizontalCenter
            right: parent.right
            rightMargin: __margin
            bottom: parent.bottom
            bottomMargin: __margin
          }
          height: parent.height / 10

          onClicked: {
            var data = {}
            data["date"] = Qt.formatDate(calendarDialog.date(), "dd.MM.yyyy")
            data["comment"] = totalDataComponent.comment
            data["summa"] = -totalDataComponent.summa
            //DBController.insert(data)
            plus.state = "error";
          }
        }
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
            bottom: additionDataComponent.top
          }
          financesModel: financesAdditionModel
          financesDelegate: additionDelegate
        }
        InputDataComponent {
          id: additionDataComponent
          anchors {
            left: parent.left
            right: parent.right
            bottom: financesAdditionButton2.top
            bottomMargin: Density.dp
          }
        }
        Material.PaperButton {
          id: financesAdditionButton2
          text: "Добавить"
          color: StyleColor.mainColor
          focusColor: StyleColor.mainFocusColor
          pressedColor: StyleColor.mainPressedColor
          colored: true
          anchors {
            left: parent.left
            leftMargin: __margin
            right: parent.right
            rightMargin: __margin
            bottom: parent.bottom
            bottomMargin: __margin
          }
          height: parent.height / 10
        }
      }
    }
    //Material.MaterialAdditionButton {
    //  id: idd
      //anchors.left: parent.left
      //anchors.top: parent.top
    //  anchors.centerIn: financesAdditionButton
    //}
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
            bottom: deletionDataComponent.top
          }
          financesModel: financesDeletionModel
          financesDelegate: deletionDelegate
        }
        InputDataComponent {
          id: deletionDataComponent
          anchors {
            left: parent.left
            right: parent.right
            bottom: financesDeletionButton2.top
            bottomMargin: Density.dp
          }
        }
        Material.PaperButton {
          id: financesDeletionButton2
          color: StyleColor.mainColor
          focusColor: StyleColor.mainFocusColor
          pressedColor: StyleColor.mainPressedColor
          colored: true
          text: "Удалить"
          anchors {
            left: parent.left
            leftMargin: __margin
            right: parent.right
            rightMargin: __margin
            bottom: parent.bottom
            bottomMargin: __margin
          }
          height: parent.height / 10
        }
      }
    }
  }

  /*Material.PaperTextField {
    id: comment

    placeholderText: "Комментарий"
    anchors {
      left: root.left
      leftMargin: 20
      right: root.right
      rightMargin: 20
      top: calendarText.bottom
      topMargin: 20
    }
  }

  Text {
    id: summaLabel

    text: "Сумма:"
    anchors {
      left: root.left
      leftMargin: 20
      top: comment.bottom
      topMargin: 20
    }
  }

  SpinBox {
    id: summaSpinBox

    minimumValue: 0
    suffix: " руб."
    anchors {
      left: summaLabel.right
      leftMargin: 15
      verticalCenter: summaLabel.verticalCenter
      right: root.right
      rightMargin: 20
    }
  }

  BusyIndicator {
    id: processIndicator
    width: 35
    height: 35
    anchors {
      horizontalCenter: root.horizontalCenter
      bottom: okButton.top
      bottomMargin: 10
    }
    visible: false
  }

  Text {
    id: iconResult
    width: 35
    height: 35
    anchors {
      horizontalCenter: root.horizontalCenter
      bottom: okButton.top
      bottomMargin: 35
      horizontalCenterOffset: -15
    }

    text: __resultCalculate ? Icons.checked : Icons.close
    color: __resultCalculate ? "#4CAF50" : "#F44336"

    font.family: "Icons"
    font.pixelSize: 70 * Density.dp

    scale: 1
    opacity: 1.0

    Behavior on opacity {
      NumberAnimation { duration: 300 }
    }
  }

  Material.PaperButton {
    id: okButton

    radius: 3
    color: "#4789c5"
    colored: true
    text: "OK"

    anchors {
      left: root.left
      leftMargin: 2
      right: root.right
      rightMargin: 2
      bottom: root.bottom
      bottomMargin: 2
    }

    height: root.height / 10

    onClicked: {
      root.enabled = false
      iconResult.opacity = 0.0
      processIndicator.visible = true

      var data = {}
      data["date"] = calendarDialog.getDate();
      data["comment"] = comment.text
      data["summa"] = (state == "Addition") ? summaSpinBox.value : -summaSpinBox.value
      data["type"] = state
      DBController.insert(data)
    }
  }*/
}
