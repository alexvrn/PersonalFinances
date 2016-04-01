import QtQuick 2.3
import QtQuick.Controls 1.2

Item {
  id: root

  property Flickable flickable  : null
  property int size : 10
  property int orientation : Qt.Vertical
  property bool aaa: false

  // colors and opacity
  property color defaultColor : inactiveColor

  property color inactiveColor: "#aaaaaa"
  property color hoveredColor : "#909090"
  property color pressedColor : "#999999"
  property double activeOpacity : 0.85
  property double inactiveOpacity : 0.45

  anchors.margins: 3
  width: orientation == Qt.Vertical ? size : parent.width - anchors.leftMargin - anchors.rightMargin
  height: orientation == Qt.Vertical ? parent.height - anchors.topMargin - anchors.bottomMargin : size
  visible: (orientation == Qt.Vertical ? flickable.visibleArea.heightRatio < 1.0
                                       : flickable.visibleArea.widthRatio  < 1.0)

  Binding {
    target: scrollbox
    property: orientation == Qt.Vertical ? "y" : "x"
    value: orientation == Qt.Vertical
             ? (flickable.contentY - flickable.originY) / ((1 - flickable.visibleArea.heightRatio) * flickable.contentHeight) * scrollbox.yMaxvalue
             : (flickable.contentX - flickable.originX) / ((1 - flickable.visibleArea.widthRatio) * flickable.contentWidth) * scrollbox.xMaxValue
    when: !mouseArea.drag.active && !mouseArea.pressed
  }

  Item {
    id: scrollbox;
    clip: true;
    height: orientation == Qt.Vertical ? Math.max (15, (flickable.visibleArea.heightRatio * root.height)) : root.size;
    width: orientation == Qt.Vertical ? root.size : Math.max (15, (flickable.visibleArea.widthRatio * root.width))

    property real yMaxvalue: root.height - scrollbox.height
    property real xMaxvalue: root.width - scrollbox.width

    // HACK: При изменении размеров окна и перестроении Flickable, значение contentY сдвигается от нуля на originY (originX)
    onYChanged: {
      if (orientation == Qt.Vertical && (mouseArea.drag.active || mouseArea.pressed)) {
        var newY = flickable.contentHeight * (1 - flickable.visibleArea.heightRatio) * y / yMaxvalue;
        flickable.contentY = flickable.originY + newY;

        // HACK #2: При большом количестве данных ListView и GridView пересчитывают магическим образом contentY вместе с originY
        // Для них жестко вызываем сдвиг в начало (в конец) соответствующими методами.
        if (y === 0 && flickable.positionViewAtBeginning)
          flickable.positionViewAtBeginning()
        else if (y === xMaxvalue && flickable.positionViewAtEnd)
          flickable.positionViewAtEnd()
      }
    }
    onXChanged: {
      if (orientation == Qt.Horizontal && (mouseArea.drag.active || mouseArea.pressed)) {
        var newX = flickable.contentWidth * (1 - flickable.visibleArea.widthRatio) * x / xMaxvalue;
        flickable.contentX = flickable.originX + newX

        if (x === 0 && flickable.positionViewAtBeginning)
          flickable.positionViewAtBeginning()
        else if (x === xMaxvalue && flickable.positionViewAtEnd)
          flickable.positionViewAtEnd()
      }
    }

    anchors {
      top: orientation == Qt.Vertical ? undefined : parent.top
      right: orientation == Qt.Vertical ? parent.right : undefined
      bottom: orientation == Qt.Vertical ? undefined : parent.bottom
      left: orientation == Qt.Vertical ? parent.left : undefined
    }

    MouseArea {
      id: mouseArea;

      anchors.fill: parent;
      hoverEnabled: true

      drag {
        target: scrollbox;
        minimumY: 0
        maximumY: root.height - scrollbox.height
        minimumX: 0
        maximumX: root.width - scrollbox.width

        axis: orientation == Qt.Vertical ? Drag.YAxis : Drag.XAxis;
      }

      onEntered: root.defaultColor = root.hoveredColor
      onExited: root.defaultColor = root.inactiveColor
    }

    Rectangle {
      id: backHandle;
      color: (mouseArea.pressed ? pressedColor : defaultColor)
      opacity: (flickable.moving || mouseArea.pressed ? activeOpacity : inactiveOpacity)
      anchors.fill: parent
      radius: root.size / 2

      Behavior on opacity { NumberAnimation { duration: 150 } }
    }
  }
}
