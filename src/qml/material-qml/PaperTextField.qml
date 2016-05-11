import QtQuick 2.2

import "density.js" as Density

FocusScope {
  id: root
  implicitWidth: 320 * Density.dp
  implicitHeight: (floatingLabel ? 72 : 48) * Density.dp
  property color textColor: 'black'
  property color placeholderTextColor: "#54000000"
  property color focusedLineColor: "#2196F3"
  property color errorLineColor: "#D34336"
  property color disabledColor: "#42000000"
  property bool errorOccured: !textInput.acceptableInput
  property alias placeholderText: placeholder.text
  property alias text: textInput.text
  property alias inputMethodComposing: textInput.inputMethodComposing
  property alias inputMethodHints: textInput.inputMethodHints
  property alias displayText: textInput.displayText
  property alias textHorizontalAlignment: textInput.horizontalAlignment

  property alias tipText: tip.text
  property alias tipVisible: tip.visible
  // Подсказку можно вывести в любом месте относительно текстового поля
  property int tipOffset: 8 * Density.dp
  property alias tipHorizontalAlignment: tip.horizontalAlignment

  property alias acceptableInput: textInput.acceptableInput
  property alias validator: textInput.validator
  property alias inputMask: textInput.inputMask
  property bool floatingLabel: false

  property bool textReadOnly: false

  activeFocusOnTab: true

  property int __fontSize: 16 * Density.dp

  Text {
    id: placeholder
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    property bool possiblyHasText:!(textInput.text.length === 0 && placeholder.text.length !== 0 && !textInput.inputMethodComposing)
    anchors.topMargin: (floatingLabel && possiblyHasText) || !floatingLabel ? 14 * Density.dp : 37 * Density.dp
    color: enabled ? (possiblyHasText ? (errorOccured ? errorLineColor : root.focus ? focusedLineColor : "#8a000000")
                                      : placeholderTextColor)
                   : disabledColor
    opacity: (floatingLabel || !possiblyHasText) ? 1 : 0
    scale: (floatingLabel && possiblyHasText) ? 0.75 : 1
    transformOrigin: Item.TopLeft

    font.pixelSize: __fontSize
    font.family: "Roboto, sans-serif"
    elide: Text.ElideRight
    verticalAlignment: Qt.AlignVCenter

    Behavior on opacity { NumberAnimation { duration: 100 } }
    Behavior on color { ColorAnimation { duration: 100 } }
    Behavior on scale { NumberAnimation { duration: 100 } }
    Behavior on anchors.topMargin { NumberAnimation { duration: 100 } }
  }

  Rectangle {
    id: line
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: textInput.bottom
    anchors.topMargin: 8 * Density.dp

    height: 2 * Density.dp
    clip: true

    Rectangle {
      width: parent.width
      height: 1 * Density.dp
      color: enabled ? placeholderTextColor : disabledColor
      anchors.top: parent.top
    }

    Rectangle {
      id: raisedline

      visible: root.focus
      height: 2 * Density.dp
      color: enabled ? (errorOccured ? errorLineColor : focusedLineColor) : disabledColor

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.horizontalCenterOffset: mouseArea.lastPressX - root.width / 2

      SequentialAnimation {
        id: pressAnimation
        running: raisedline.visible
        PropertyAnimation { target: raisedline; properties: "width"; easing.type: Easing.InQuad; from: 0; to: 2 * parent.width; duration: 300 }
        PropertyAction { target: mouseArea; property: "lastPressX"; value: root.width / 2 }
      }
    }

    DashedLine {
      width: parent.width
      anchors.top: parent.top
      lineColor: enabled ? placeholderTextColor : disabledColor
      visible: !root.enabled
    }
  }

  TextInput {
    id: textInput

    anchors.top: parent.top
    anchors.topMargin: (floatingLabel ? 37 : 13) * Density.dp // QML TextInput adds 3sp space above the text
    width: parent.width

    readOnly: textReadOnly

    focus: root.focus
    selectByMouse: true

    font.family: "Roboto, sans-serif"
    font.pixelSize: __fontSize
    clip: contentWidth > width
    color: enabled ? (focus ? "#dd000000" : "#c0000000") : disabledColor
  }

  Text {
    id: tip
    width: parent.width
    anchors.top: line.top
    anchors.topMargin: root.tipOffset - 3 * Density.dp
    visible: false
    elide: Text.ElideRight
    font.family: "Roboto, sans-serif"
    font.pixelSize: 12 * Density.dp
    color: enabled ? (root.focus ? (errorOccured ? errorLineColor : focusedLineColor) : placeholderTextColor)
                   : disabledColor
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    enabled: !root.focus

    property int lastPressX: root.width / 2

    onPressed: {
      mouse.accepted = false
      lastPressX = mouse.x
    }
  }
}
