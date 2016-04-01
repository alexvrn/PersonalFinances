import QtQuick 2.3
import "density.js" as Density

FocusScope {
  id: menu
  implicitWidth: 200 * Density.dp
  implicitHeight: listView.contentHeight

  z: 1001

  property alias model: listView.model

  signal itemClicked(var index)

  Overlay {
    id: overlay
    z: menu.z - 1
    maximumOpacity: 0
    onCloseRequested: menu.state = "hidden"
  }

  ImageShadow {
    id: shadow
    anchors.fill: menu
    depth: 2
  }

  Rectangle {
    id: background
    anchors.fill: parent

    ListView {
      id: listView
      anchors.fill: parent
      clip: true
      interactive: contentHeight > height

      delegate: PaperMenuItem {
        text: modelData
        width: menu.width

        onClicked: {
          menu.state = "hidden"
          menu.itemClicked(index)
        }
      }
    }
  }

  state: "hidden"
  states: [
    State {
      name: "hidden"
      PropertyChanges { target: menu; opacity: 0; width: 0; height: 0 }
    },
    State {
      name: "shown"
      PropertyChanges {
        target: overlay
        shown: true
      }
      PropertyChanges {
        target: menu
        parent: overlay.target
        focus: true
        opacity: 1
        width: implicitWidth
        height: implicitHeight
      }
    }
  ]

  onStateChanged: {
    // Tricky hack to return focus back to previously focused activity
    if (state == "hidden" && menu.activeFocus) {
      var f = nextItemInFocusChain(false);
      f.forceActiveFocus();
      f.focus = false;
    }
  }

  transitions: [
    Transition {
      SequentialAnimation {
        PropertyAction { target: overlay; property: "shown" }
        PropertyAction { target: menu; property: "parent" }
        ParallelAnimation {
          PropertyAnimation {
            target: menu
            properties: "width"
            duration: 150
            easing.type: Easing.InOutQuad
          }
          PropertyAnimation {
            target: menu
            properties: "height, opacity"
            duration: 250
            easing.type: Easing.InOutQuad
          }
        }
      }
    }
  ]


  Keys.onBackPressed: {
    if (menu.state == "shown") {
      menu.state = "hidden";
      event.accepted = true;
    } else {
      event.accepted = false;
    }
  }
}
