import QtQuick 2.2
import QtQuick.Controls 1.2

import "density.js" as Density

StackViewDelegate {
  id: stackDelegate

  pushTransition: StackViewTransition {
    SequentialAnimation {
      ParallelAnimation {
        PropertyAnimation {
          target: enterItem
          property: "opacity"
          from: 0
          to: 1
          duration: 250
          easing.type: Easing.OutQuad
        }
        PropertyAnimation {
          target: enterItem
          property: "y"
          from: 100 * Density.dp
          to: 0
          duration: 250
          easing.type: Easing.OutQuad
        }
      }
      ScriptAction {
        script: {
          enterItem.focus = true;
          enterItem.forceActiveFocus();
        }
      }
    }
  }


  popTransition: StackViewTransition {
    SequentialAnimation {
      ParallelAnimation {
        PropertyAnimation {
          target: exitItem
          property: "opacity"
          from: 1
          to: 0
          duration: 250
          easing.type: Easing.InQuad
        }
        PropertyAnimation {
          target: exitItem
          property: "y"
          from: 0
          to: 100 * Density.dp
          duration: 250
          easing.type: Easing.InQuad
        }
      }
      ScriptAction {
        script: {
          enterItem.focus = true;
          enterItem.forceActiveFocus();
        }
      }
    }
  }

  // TODO: add replace transition
}
