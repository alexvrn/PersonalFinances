import QtQuick 2.3
import "density.js" as Density

FocusScope {
  id: root

  signal clicked

  property bool checked: false
  activeFocusOnTab: true

  property bool __componentCompleted: false
  Component.onCompleted: root.__componentCompleted = true

  width: 48 * Density.dp
  height: 48 * Density.dp

  Keys.onPressed: {
    if ((event.key === Qt.Key_Space || event.key === Qt.Key_Return) && !event.isAutoRepeat)
    {
      checked = !checked;
      root.clicked()
    }
  }

  Rectangle {
    id: focusCircle
    width: 48
    height: width
    color: checked ? "#5A5A5A" : "#0f9d58"
    radius: width / 2
    anchors.centerIn: parent
    opacity: parent.focus ? 0.25 : 0

    Behavior on opacity {
      NumberAnimation { duration: 200 }
    }
  }

  MouseArea {
    id: ma
    anchors.fill: parent

    onClicked: {
      root.checked = !root.checked
      root.clicked()
    }
  }

  Ripple {
    id: ink
    anchors.fill: parent
    mouseArea: ma

    radius: width / 2
    color: '#0f9d58'

    recenteringTouch: true
  }

  Item {
    id: indicatorContainer
    anchors.centerIn: parent
    width: 18 * Density.dp
    height: 18 * Density.dp

    Rectangle {
      id: base
      width: 18 * Density.dp
      height: 18 * Density.dp
      border.width: 2 * Density.dp
      color: '#00000000'
      antialiasing: true
    }

    Item {
      id: checkmark
      x: 5 * Density.dp
      y: 13 * Density.dp
      width: 4 * Density.dp
      height: 4 * Density.dp
      rotation: 45
      visible: false

      Rectangle {
        id: checkLeft
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 2 * Density.dp
        color: '#0f9d58'
        antialiasing: true
      }

      Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: checkLeft.top
        width: 2 * Density.dp
        color: '#0f9d58'
        antialiasing: true
      }
    }

    states: [
      State {
        name: "checked"
        when: root.checked
        PropertyChanges {
          target: base;
          rotation: 45;
          x: 5 * Density.dp; y: 13 * Density.dp;
          width: 4 * Density.dp; height: 4 * Density.dp;
          visible: false
        }
        PropertyChanges {
          target: checkmark;
          x: 6 * Density.dp; y: -4 * Density.dp;
          width: 10 * Density.dp; height: 21 * Density.dp;
          visible: true
        }
        PropertyChanges { target: ink; color: '#5a5f5a' }
      }
    ]

    transitions: [
      Transition {
        to: "checked"
        enabled: root.__componentCompleted && root.visible
        SequentialAnimation {
          PropertyAnimation { target: base; properties: 'rotation, x, y, width, height'; duration: 140; easing.type: Easing.OutQuad }
          PropertyAction { target: base; property: 'visible' }
          PropertyAction { target: checkmark; property: 'visible' }
          PropertyAnimation { target: checkmark; properties: 'x, y, width, height'; duration: 140; easing.type: Easing.OutQuad }
          PropertyAction { target: ink; property: 'color' }
        }
      },

      Transition {
        from: "checked"
        enabled: root.__componentCompleted && root.visible
        SequentialAnimation {
          PropertyAnimation { target: checkmark; properties: 'x, y, width, height'; duration: 140; easing.type: Easing.OutQuad }
          PropertyAction { target: checkmark; property: 'visible' }
          PropertyAction { target: base; property: 'visible' }
          PropertyAnimation { target: base; properties: 'rotation, x, y, width, height'; duration: 140; easing.type: Easing.OutQuad }
          PropertyAction { target: ink; property: 'color' }
        }

      }
    ]
  }
}
