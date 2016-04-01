import QtQuick 2.0
//import Material 0.1

import QtQuick.Controls 1.2

Rectangle {
  id: root
  property variant tabs: []
  property int selectedIndex: tabbar.selectedIndex
  property color backgroundColor
  property color tabTextColor
  property color highlightColor
  property int tabFontSize
  property double сellWidth

  /*!
  This is the standard function to use for accessing device-independent pixels. You should use
  this anywhere you need to refer to distances on the screen.
  */
  function dp(number) {
    var __pixelDensity = 4.5 // pixels/mm
    return number * __pixelDensity * 1.4 * 0.15875
  }

  onWidthChanged: {
    selectionIndicator.width = 0
  }

  clip: true //TODO - КОСТЫЛЬ
  color: backgroundColor
  height: dp(48)
  Row {
    id: tabbar
    width: root.width
    height: root.height
    property int selectedIndex: 0
    anchors {
      left: root.left
      right: root.right
    }

    Loader {
      id: loaderRepeater
      onLoaded: {
          console.debug("load")
      }
    }

    Repeater {
      id: repeater
      model: root.tabs

      delegate: Rectangle {
        id: tabItem
        width: сellWidth
        //width: root.width / root.tabs.length
        //width: Math.max(label.contentWidth +dp(48), 88 * dp(1.0))
        height: tabbar.height
        color: root.backgroundColor
        radius: 0
        property bool selected: index == tabbar.selectedIndex

        MouseArea {
          id: ink
          anchors.fill: parent
          property var xPrevIndicator //для запоминания координаты x и ширины Индикатора, для возвращени на предыдущее место
          property var widthPrevIndicator
          onClicked: {
            tabbar.selectedIndex = index;
            selectionIndicator.x = tabItem.x;
            selectionIndicator.width = tabItem.width;
          }
          onPressed: {
            //запоминаем x и width
            xPrevIndicator = selectionIndicator.x
            widthPrevIndicator = selectionIndicator.width
            if(index > tabbar.selectedIndex) {
              selectionIndicator.width = tabItem.x + tabItem.width - selectionIndicator.x
            }
            else {
              selectionIndicator.width = selectionIndicator.x + selectionIndicator.width - tabItem.x
              selectionIndicator.x = tabItem.x;
            }
          }
          onReleased: {
            selectionIndicator.x = xPrevIndicator
            selectionIndicator.width = widthPrevIndicator
          }
        }
        Ripple {
          id: ripple
          anchors.fill: parent
          mouseArea: ink
        }
        Row {
          id: row
          anchors.centerIn: parent
          spacing: dp(10)

          Text {
            id: label
            text: modelData
            horizontalAlignment: Text.AlignRight //modelData.hasOwnProperty("text") ? modelData.text : modelData
            color: (tabbar.selectedIndex === index) ? root.tabTextColor : Qt.tint(root.tabTextColor, "#AAAAAA")
            font {
              pointSize: tabFontSize
              bold: true
              capitalization: Font.AllUppercase
            }
            z: ink.z + 1
            anchors.verticalCenter: parent.verticalCenter
          }
        }
      }
    }
  }

  //Индикатор выбора закладки
  Rectangle {
    id: selectionIndicator
      anchors {
    }
    y: root.height - dp(2)
    height: dp(2)
    color: root.highlightColor

    Behavior on opacity {
      NumberAnimation { duration: 200 }
    }
    Behavior on x {
      NumberAnimation { duration: 200 }
    }
    Behavior on width {
      NumberAnimation { duration: 200 }
    }
  }
}
