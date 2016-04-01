import QtQuick 2.0
import "density.js" as Density

Item {
  id: menuBackIcon
  width: 24 * Density.dp
  height: 24 * Density.dp

  Rectangle {
    id: bar1
    x: 2 * Density.dp
    y: 5 * Density.dp
    width: 20 * Density.dp
    height: 2 * Density.dp
    color: "#fff"
    antialiasing: true
  }

  Rectangle {
    id: bar2
    x: 2 * Density.dp
    y: 10 * Density.dp
    width: 20 * Density.dp
    height: 2 * Density.dp
    color: "#fff"
    antialiasing: true
  }

  Rectangle {
    id: bar3
    x: 2 * Density.dp
    y: 15 * Density.dp
    width: 20 * Density.dp
    height: 2 * Density.dp
    color: "#fff"
    antialiasing: true
  }

  property int __animationDuration: 350

  state: "menu"
  states: [
    State {
      name: "menu"
    },

    State {
      name: "back"
      PropertyChanges { target: menuBackIcon; rotation: 180 }
      PropertyChanges { target: bar1; rotation: 45; width: 13 * Density.dp; x: 9.5 * Density.dp; y: 8 * Density.dp }
      PropertyChanges { target: bar2; width: 17 * Density.dp; x: 3 * Density.dp; y: 12 * Density.dp }
      PropertyChanges { target: bar3; rotation: -45; width: 13 * Density.dp; x: 9.5 * Density.dp; y: 16 * Density.dp }
    }
  ]

  transitions: [
    Transition {
      RotationAnimation { target: menuBackIcon; direction: RotationAnimation.Clockwise; duration: __animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: bar1; properties: "rotation, width, x, y"; duration: __animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: bar2; properties: "rotation, width, x, y"; duration: __animationDuration; easing.type: Easing.InOutQuad }
      PropertyAnimation { target: bar3; properties: "rotation, width, x, y"; duration: __animationDuration; easing.type: Easing.InOutQuad }
    }
  ]
}
