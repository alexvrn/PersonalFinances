import QtQuick 2.2
import "density.js" as Density

FocusScope {
  id: root
  width: 320 * Density.dp
  height: 320 * Density.dp

  anchors.centerIn: parent
  z: 1000

  opacity: 0
  visible: opacity != 0

  signal opened
  signal closed

  property bool shown

  property alias overlayTarget: overlay.target
  default property alias children : container.children

  property bool canClose: true
  property bool showCloseButton: false

  property string title
  property int level: 0

  function show() {
    shown = true
  }

  function close() {
    shown = false
  }

  Overlay {
    id: overlay
    z: root.z - 1
    animationDuration: 250

    onCloseRequested: canClose && close()
  }

  MouseArea {
    anchors.fill: parent
  }

  ImageShadow {
    anchors.fill: contentBackground
    depth: 4
  }

  Rectangle {
    id: contentBackground
    anchors.fill: parent
    radius: 3 * Density.dp
  }

  Item {
    id: container
    enabled: root.shown
    anchors.fill: parent
    anchors.topMargin: (caption.visible ? 40 * Density.dp + caption.height : 24 * Density.dp)

    Keys.onEscapePressed: {
      if (shown) {
        canClose && close()
      } else {
        event.accepted = false
      }
    }

    Keys.onBackPressed: {
      if (shown) {
        canClose && close()
      } else {
        event.accepted = false
      }
    }
  }

  // Close button
  Text {
    text: "×"
    anchors.top: root.top
    anchors.right: root.right
    anchors.margins: 24 * Density.dp

    font.pixelSize: 20 * Density.dp
    font.weight: Font.DemiBold

    visible: root.canClose && root.showCloseButton
    opacity: 0.87

    Behavior on opacity { PropertyAnimation { duration: 150 } }

    // Mouse area: slightly larger than a text
    MouseArea {
      id: closeMouseArea
      anchors.fill: parent
      anchors.margins: -6 * Density.dp
      enabled: root.canClose && root.showCloseButton
      onClicked: root.close()
    }
  }

  Text {
    id: caption
    text: root.title
    visible: root.title != ""
    opacity: 0.87

    anchors.left: root.left
    anchors.top: root.top
    anchors.topMargin: 24 * Density.dp
    anchors.leftMargin: 24 * Density.dp

    font.family: "Roboto, sans-serif"
    font.pixelSize: 20 * Density.dp
    font.weight: Font.Normal
  }

  states: [
    State {
      name: ""
      when: !root.shown
      PropertyChanges { target: overlay; shown: false }
      PropertyChanges { target: root; opacity: 0 }
    },

    State {
      name: "shown"
      when: root.shown

      PropertyChanges { target: overlay; shown: true }
      PropertyChanges { target: root; parent: overlay.target; opacity: 1 }
    }
  ]

  transitions: [
    Transition {
      to: ""

      SequentialAnimation {
        ParallelAnimation {
          PropertyAction { target: overlay; property: "shown" }

          PropertyAnimation {
            target: root
            property: "anchors.verticalCenterOffset"
            from: 0
            to: 200 * Density.dp
            duration: 250
          }

          PropertyAnimation {
            target: root
            property: "opacity"
            duration: 250
          }

          PropertyAnimation {
            target: root
            property: "scale"
            from: 1; to: 0.5
            duration: 250
          }
        }
        ScriptAction { script: { root.focus = false; root.closed(); } }
      }
    },
    Transition {
      to: "shown"

      SequentialAnimation {
        PropertyAction { target: overlay; property: "shown" }
        PropertyAction { target: root; property: "parent" }
        ParallelAnimation {
          PropertyAnimation {
            target: root
            property: "anchors.verticalCenterOffset"
            from: 320 * Density.dp
            to: 0
            duration: 250
            easing.type: Easing.OutQuad
          }

          PropertyAnimation {
            target: root
            property: "opacity"
            duration: 250
          }

          PropertyAnimation {
            target: root
            property: "scale"
            from: 0.5; to: 1
            duration: 250
            easing.type: Easing.InQuad
          }
        }
        ScriptAction { script: { root.forceActiveFocus(); root.opened(); } }
      }
    }
  ]
}
