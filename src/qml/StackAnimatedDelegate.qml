import QtQuick 2.0
import QtQuick.Controls 1.1


StackViewDelegate {
  id: root

  function getTransition(properties) {
    return horizontalTransition
  }

  function transitionFinished(properties) {
    properties.exitItem.x = 0
    properties.exitItem.y = 0
    properties.exitItem.opacity = 1.0
  }

  property Component horizontalTransition: StackViewTransition {
    property int hideDuration: 120
    property int showDuration: 250
    property bool toRight: enterItem.Stack.index > exitItem.Stack.index

    ParallelAnimation {
      PropertyAnimation {
        target: exitItem
        property: "x"
        from: 0
        to: toRight ? -target.width / 8 : target.width / 8
        duration: hideDuration
        easing.type: Easing.OutCubic
      }

      PropertyAnimation {
        target: exitItem
        property: "opacity"
        from: 1.0
        to: 0.0
        duration: hideDuration
        easing.type: Easing.OutCubic
      }

      PropertyAnimation {
        target: enterItem
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: showDuration
        easing.type: Easing.InQuad
      }

      PropertyAnimation {
        target: enterItem
        property: "x"
        from: toRight ? target.width / 8 : -target.width / 8
        to: 0
        duration: showDuration
        easing.type: Easing.OutQuad
      }
    }
  }
}
