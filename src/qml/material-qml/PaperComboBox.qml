import QtQuick 2.3


Rectangle {
  id:comboBox

  property variant items: ["Item 1", "Item 2", "Item 3"]
  property var overlayTarget
  property alias selectedIndex: listView.currentIndex
  signal comboClicked

  implicitWidth: 200
  implicitHeight: 50

  PaperItem {
    id: itemText
    anchors.fill: parent
    text: comboBox.items[0]


    onClicked: {
      comboBox.state = comboBox.state === "dropDown" ? "" : "dropDown"
      if (comboBox.state === "dropDown")
        showModal()
    }
  }


  Rectangle {
    id: dropDown
    width: 0
    height: 0
    anchors.top: itemText.bottom;

    GlowShadow {
      id: shadow
      anchors.fill: parent
      depth: 1
      z: dropDown.z - 1
      visible: false
    }

    ListView {
      id: listView
      anchors.fill: dropDown
      currentIndex: 0
      clip: true

      model: comboBox.items
      delegate: PaperItem {
        text: modelData
        height: comboBox.height
        width: comboBox.width

        onClicked: {
          comboBox.state = ""
          var prevSelection = itemText.text
          itemText.text = modelData
          if (itemText.text != prevSelection) {
            comboBox.comboClicked();
          }

          listView.currentIndex = index;
          close()
        }
      }
    }
  }

  states: State {
    name: "dropDown"
    PropertyChanges { target: shadow; visible: true }
    PropertyChanges { target: dropDown; height: listView.contentHeight; width: comboBox.width }
    PropertyChanges { target: overlay; opacity: 1 }
  }

  transitions: [
    Transition {
      to: "dropDown"

      NumberAnimation { target: dropDown; properties: "width"; easing.type: Easing.OutExpo; duration: 50 }
      NumberAnimation { target: dropDown; properties: "height"; easing.type: Easing.OutExpo; duration: 200 }
    },
    Transition {
      from: "dropDown"

      NumberAnimation { target: overlay; properties: "opacity"; from: 1.0; to: 0.0; easing.type: Easing.OutExpo; duration: 400 }
      ParallelAnimation {
        NumberAnimation { target: dropDown; properties: "width"; to: 200; easing.type: Easing.OutExpo; duration: 400 }
        NumberAnimation { target: dropDown; properties: "height"; to: 150; easing.type: Easing.OutExpo; duration: 400 }
      }
    }
  ]

  function showModal() {
    // Находим цель для оверлея и лезем к ней
    if (!overlayTarget) {
      var newTarget = parent
      do {
        overlayTarget = newTarget
        newTarget = overlayTarget.parent
      }
      while (newTarget && newTarget.width != 0 && newTarget.height != 0);
    }

    overlay.parent = overlayTarget
    overlay.x = overlayTarget.x
    overlay.y = overlayTarget.y
    //overlay.opacity = 1

    var mapped = overlayTarget.mapFromItem(dropDown, 0, 0)
    dropDown.parent = overlay
    dropDown.x = mapped.x
    dropDown.y = mapped.y

    dropDown.forceActiveFocus()
  }

  function close() {
    //overlay.opacity = 0
    comboBox.state =  ""
  }

  Item {
    id: overlay
    opacity: 0
    width: typeof overlayTarget !== 'undefined' ? overlayTarget.width : 0
    height: typeof overlayTarget !== 'undefined' ? overlayTarget.height : 0

    visible: opacity != 0

    Behavior on opacity { PropertyAnimation { duration: 150 } }
    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      preventStealing: true

      onClicked: {
        close()
      }
    }
  }
}

