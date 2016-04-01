import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.1

import "." as Material
import "density.js" as Density

Window {
  id: window1
  title: qsTr("Hello World")
  width: 1280
  height: 1000

  AppBar {
    id: appBar
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    ActionButton {
      id: menuBackButton

      MenuBackIcon {
        id: menuBackIcon
        anchors.centerIn: parent
      }

      onClicked: {
        menuBackIcon.state = menuBackIcon.state == "menu" ? "back" : "menu"
        animatedText.text = animatedText.text == "Example text" ? "Second example text" : "Example text"
      }
    }

    AnimatedText {
      id: animatedText
      anchors.left: menuBackButton.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: 8 * Density.dp

      text: "Example text"
      animation: animatedText.flipAnimation

      color: 'white'
      font.family: "Roboto, sans-serif"
      font.pixelSize: 24 * Density.dp
    }
  }

  Column {
    anchors.top: appBar.bottom
    anchors.left: parent.left
    anchors.margins: 20
    spacing: 20

    Row {
      spacing: 30
      PaperMenu  {
      }

      PaperComboBox {
      }

      // Radiobutton Group
      Column {
        spacing: 22
        Text {
          id: textWiFi
          text: "Keep Wi-Fi on during sleep"
          font.family: "Roboto, sans-serif"
          font.pixelSize: 16
          color: "#000000"
        }

        ColumnLayout {
          ExclusiveGroup { id: wifiGroup }
          PaperRadioButton {
            text: "Always"
            checked: true
            exclusiveGroup: wifiGroup
          }
          PaperRadioButton {
            text: "Only"
            exclusiveGroup: wifiGroup
          }
          PaperRadioButton {
            text: "Never"
            exclusiveGroup: wifiGroup
          }
        }
      }
      // End of Radiobutton Group
    }


    Row {
      spacing: 20
      PaperTextField {
        placeholderText: "Type something"
      }

      PaperTextField {
        tipVisible: true
        placeholderText: "Type something"
        tipText: "Please enter something"
      }

      PaperTextField {
        floatingLabel: true
        placeholderText: "Floating label"
      }
    }

    Row {
      spacing: 20

      PaperTextField {
        enabled: false
        placeholderText: "I'm disabled"
      }

      PaperTextField {
        text: "Prefilled value"
        placeholderText: "Type something"
      }

      PaperTextField {
        tipVisible: text.length == 0
        tipText: "This input requires a value!"
//        tipVerticalCenterOffset: 25
        placeholderText: "Type something"
        focusedLineColor: text.length == 0 ? "#D34336" : "#2196F3"
      }
    }

    Row {
      spacing: 20

      Material.PaperButton {
        text: "Button"
        flat: true
      }

      PaperButton {
        text: "Colored"
        flat: true
        colored: true
      }

      PaperButton {
        text: "Disabled"
        flat: true
        enabled: false
      }

      PaperButton {
        text: "Disabled"
        flat: true
        colored: true
        enabled: false
      }

      PaperCheckBox {
        checked: true
      }
    }

    Row {
      spacing: 20

      PaperButton {
        text: "Button"
      }

      PaperButton {
        text: "Colored"
        colored: true
      }

      PaperButton {
        text: "Disabled"
        enabled: false
      }

      PaperButton {
        text: "Disabled"
        colored: true
        enabled: false
      }

      PaperToogleButton {
        checked: true
        onColor: "#0F9D58"
      }

      PaperToogleButton {
        checked: false
      }
    }


    Row {
      spacing: 20

      ListView {
        width: 350
        height: count * 48 * Density.dp
        model: ['Item 1', 'Item 2']
        delegate: PaperItem {
          text: modelData
        }
      }

      ListView {
        width: 350
        height: count * 56 * Density.dp
        model: ['Item with icon 1', 'Item with icon 2']
        delegate: PaperItem {
          text: modelData
          icon: Rectangle {
            width: 40
            height: 40
            radius: 20
            color: '#989898'
          }
        }
      }

      ListView {
        width: 350
        height: count * 72 * Density.dp
        model: ['Item with icon 1', 'Item with icon 2']
        delegate: PaperItem {
          text: modelData
          secondaryText: 'Secondary text'
          icon: Rectangle {
            width: 40
            height: 40
            radius: 20
            color: '#989898'
          }
        }
      }
    }

    Row {
      spacing: 10

      Rectangle {
        width: 100
        height: 100

        property int step: 1

        ImageShadow {
          id: squareShadow
          anchors.fill: square
          depth: 1
        }

        Rectangle {
          id: square
          anchors.fill: parent
          anchors.margins: 25
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            squareShadow.depth += parent.step;
            if (squareShadow.depth == 5 || squareShadow.depth == 1)
              parent.step = -parent.step;
          }
        }
      }

      Rectangle {
        width: 100
        height: 100

        property int step: 1

        MaterialShadow {
          id: squareShaderShadow
          anchors.fill: square2
          radius: square.radius
          depth: 1
          animated: true
        }

        Rectangle {
          id: square2
          anchors.fill: parent
          anchors.margins: 25
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            squareShaderShadow.depth += parent.step;
            if (squareShaderShadow.depth == 5 || squareShaderShadow.depth == 1)
              parent.step = -parent.step;
          }
        }
      }

      Rectangle {
        width: 100
        height: 100

        property int step: 1

        GlowShadow {
          id: glowShadow
          anchors.fill: square3
          radius: square.radius
          depth: 1

          animation: NumberAnimation {
            duration: 1000
            easing.type: Easing.InOutQuad
          }
        }

        Rectangle {
          id: square3
          anchors.fill: parent
          anchors.margins: 25
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            glowShadow.depth += parent.step;
            if (glowShadow.depth == 5 || glowShadow.depth == 1)
              parent.step = -parent.step;
          }
        }
      }

      Rectangle {
        width: 100
        height: 100

        property int step: 1

        MaterialShadow {
          id: circleShadow
          anchors.fill: circle
          radius: circle.radius
          depth: 1
          animated: true
        }

        Rectangle {
          id: circle
          anchors.fill: parent
          anchors.margins: 25
          radius: width / 2
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            circleShadow.depth += parent.step;
            if (circleShadow.depth == 5 || circleShadow.depth == 1)
              parent.step = -parent.step;
          }
        }
      }

      Rectangle {
        width: 100
        height: 100

        property int step: 1

        GlowShadow {
          id: circleShadow2
          anchors.fill: circle2
          radius: circle2.radius
          depth: 1
//          animated: true
        }

        Rectangle {
          id: circle2
          anchors.fill: parent
          anchors.margins: 25
          radius: width / 2
        }

        MouseArea {
          anchors.fill: parent

          onClicked: {
            circleShadow2.depth += parent.step;
            if (circleShadow2.depth == 5 || circleShadow2.depth == 1)
              parent.step = -parent.step;
          }
        }
      }
    }

    /*Row {
      spacing: 10

      MaterialTabView {
        id: mytabs
        height: 400
        width: 700
        tabBackgroundColor: "#089795"
        tabTextColor: "white"
        highlightColor: "yellow"
        MaterialTab {
          title: "Tab 1"
          Rectangle {
            color: "darkgray"
            PaperButton {
              id: btnMove
              text: "Button"
            }
            PaperButton {
              text: "Button"
              anchors.top: btnMove.bottom
            }
          }
        }
        MaterialTab {
          title: "Tab 2"
          Rectangle {
            color: "lightgray"
            PaperButton {
              text: "Button"
            }
          }
        }
        MaterialTab {
          title: "Tab 3"
          Rectangle {
            color: "pink"
          }
        }
      }
    }*/
  }
}
