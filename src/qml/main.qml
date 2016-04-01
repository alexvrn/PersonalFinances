import QtQuick 2.3
import QtQuick.Window 2.2
import QtMultimedia 5.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import "."
import Qt.labs.settings 1.0

import "material-qml" as Material
import "material-qml/density.js" as Density
import "StyleColor.js" as StyleColor

Window {
  visible: true
  width: 280
  height: 500
  title: qsTr("Бухгалтерия")

  // Запуск в полноэкранном режиме
  //visible: true
  //visibility: settings.release ? Window.FullScreen : Window.Windowed

  FontLoader {
    source: "icons.ttf"
    name: "Icons"
  }

  Material.AppBar {
    id: appBar
    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
    }
    color: StyleColor.mainFocusColor

    Material.ActionButton {
      id: menuBackButton

      Material.MenuBackIcon {
        id: menuBackIcon
        anchors.centerIn: parent
        state: "menu"

        onStateChanged: {
          if (state === "back") {
            popupMenuButton.visible = true
          }
          else if (state === "menu") {
            popupMenuButton.visible = false
          }
        }
      }

      onClicked: {
        if (menuBackIcon.state == "back") {
          menuBackIcon.state = "menu"
          title.text = ""
          stack.pop()
        }
        else if (menuBackIcon.state == "menu") {
          console.debug("menu null")
        }

        //menuBackIcon.state = menuBackIcon.state == "menu" ? "back" : "menu"
        //animatedText.text = animatedText.text == "Example text" ? "Second example text" : "Example text"
      }
    }

    Material.ActionButton {
      id: popupMenuButton
      anchors.right: appBar.right

      Material.PopupMenuIcon {
        id: popupMenuIcon
        anchors.fill: parent
      }

      visible: false
    }

    Material.AnimatedText {
      id: title
      anchors.left: menuBackButton.right
      anchors.verticalCenter: menuBackButton.verticalCenter
      color: "white"
      font.pixelSize: 14 * Density.dp
      font.bold: true
      animation: 1
    }
  }

  Item {
    id: root
    anchors {
      left: parent.left
      right: parent.right
      top: appBar.bottom
      bottom: parent.bottom
    }

    state: "start"

    Item {
      id: backgroundItem
      anchors.fill: parent

      // Градиент
      Rectangle {
        id: backgroundGradient
        anchors.fill: parent

        gradient: Gradient {
          GradientStop {color: "#e0e0e0" ; position: 0}
          GradientStop {color: "#757575" ; position: 1}
        }
      }

      // Фоновая картинка
      /*Image {
        id: backgroundImage
        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop

        opacity: 0.12
        source: "icons/airport.jpg"
      }*/
    }

    StackView {
      id: stack
      anchors.fill: parent
      initialItem: startPage // начальная страница
      delegate: delegate

      opacity: 1.0
      visible: opacity !== 0.0
    }
    StackAnimatedDelegate { id: delegate }

    // Начальная страница
    StartPage {
      id: startPage
      visible: false

      onOpenControlFinances: {
        menuBackIcon.state = "back"
        title.text = qsTr("Управление")

        DBController.statistic()

        stack.push(controlFinancesPage)
      }
      onOpenStatistic: {
        menuBackIcon.state = "back"
        title.text = "Статистика"
        stack.push(statisticPage)
      }
    }

    ControlFinancesPage {
      id: controlFinancesPage
      visible: false

      onBack: {
        stack.pop()
        menuBackIcon.state = "menu"
      }
    }

    StatisticPage {
      id: statisticPage
      visible: false
    }
  }
}
