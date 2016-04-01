import QtQuick 2.2

Rectangle {
  id: circle
  implicitWidth: 120
  height: width
  radius: width / 2

  opacity: 0.25

  property alias running: animation.running

  SequentialAnimation {
    id: animation
    running: circle.visible == true
    loops: Animation.Infinite
    PropertyAnimation { target: circle; property: "scale"; from: 0.97; to: 1.07; duration: 1000; easing.type: Easing.InOutQuad }
    PropertyAnimation { target: circle; property: "scale"; from: 1.07; to: 0.97; duration: 2000; easing.type: Easing.InOutQuad }
  }
}
