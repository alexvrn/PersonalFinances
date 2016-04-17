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

  property bool __process: false

  signal back

  Component.onCompleted: {
    calendarDialog.setDate(new Date())
  }

  Connections {
    target: DBController

    onResultProcess: {
      __resultCalculate = result

      __process = false;
      var currentState = result ? "main" : "error";

      // Если операция прошла успешно, то запрашиваем обновление информации
      if (result)
      {
        if (plus.state !== "main")
          plus.state = currentState;
        else if (minus.state !== "main")
          minus.state = currentState

        if (dateSwitch.checked)
          DBController.statistic(new Date(calendarDialog.year, calendarDialog.month))
        else
          DBController.statistic()
      }
      else {
        if (plus.state !== "main")
          plus.state = currentState;
        else if (minus.state !== "main")
          minus.state = currentState;

        console.error("error: " + comment)
      }
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
    height: 30*Density.dp

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
    cellHeight: 30*Density.dp
    tabFontSize: 8

    anchors {
      top: dateSettingItem.bottom
      bottom: parent.bottom
      left: parent.left
      right: parent.right
      bottomMargin: 54*Density.dp
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

  Rectangle {
    id: inputData

    anchors {
      top: financesTabView.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }

    Material.PaperTextField {
      id: commentText

      //textColor: StyleColor.inputTextColor
      //placeholderTextColor: StyleColor.inputTextColor
      placeholderText: "Введите комментарий"
      anchors {
        left: parent.left
        right: parent.right
        rightMargin: parent.width*0.4
        verticalCenter: parent.verticalCenter
      }
      //width: root.width * 0.67
    }

    SpinBox {
      id: summaSpinBox

      minimumValue: 0
      suffix: " руб."
      anchors {
        left: commentText.right
        right: actionButtonPlus.left
        //rightMargin: parent.width*0.2
        verticalCenter: parent.verticalCenter
      }
      width: root.width
    }

    Material.ActionButton {
      id: actionButtonPlus
      anchors {
        top: parent.top
        left: parent.right
        leftMargin: -Density.dp*30
        right: parent.right
        bottom: parent.verticalCenter
      }

      Material.PaperAddButton {
        id: plus
        anchors.centerIn: parent
      }
      onClicked: {
        if (__process)
          return;

        plus.state = "wait";
        __process = true;

        var data = {}
        if (dateSwitch.checked) {
          var currentDate = new Date();
          // Если выбранная дата не совпадает с текущим месяцем, то считаем что это первый день выбранного месяца(01.xx.xxxx)
          if (currentDate.getMonth() != calendarDialog.month || currentDate.getFullYear() != calendarDialog.year)
            data["date"] = Qt.formatDate(calendarDialog.date(), "01.MM.yyyy")
        }
        data["comment"] = commentText.text
        data["summa"] = summaSpinBox.value
        DBController.insert(data)
      }
    }

    Material.ActionButton {
      id: actionButtonMinus
      anchors {
        top: parent.verticalCenter
        right: parent.right
        leftMargin: -Density.dp*30
        left: parent.right
        bottom: parent.bottom
      }

      Material.PaperAddButton {
        id: minus
        type: "minus"
        anchors.centerIn: parent
      }
      onClicked: {
        if (__process)
          return;

        minus.state = "wait";
        __process = true;

        var data = {}
        if (dateSwitch.checked) {
          var currentDate = new Date();
          // Если выбранная дата не совпадает с текущей датой, то считаем что это первый день выбранного месяца(01.xx.xxxx)
          if (currentDate.getMonth() != calendarDialog.month || currentDate.getFullYear() == calendarDialog.year)
          data["date"] = Qt.formatDate(calendarDialog.date(), "01.MM.yyyy")
        }
        data["comment"] = commentText.textColor
        data["summa"] = -summaSpinBox.value
        DBController.insert(data)
      }
    }
  }
}
