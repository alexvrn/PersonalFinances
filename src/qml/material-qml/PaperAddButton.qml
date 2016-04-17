import QtQuick 2.0
import "density.js" as Density

Item {
  id: addButton

  property int __side: 24 * Density.dp
  property int __shift: 4 * Density.dp

  property int __minSide: __side / 9
  property int __maxSide: __side / 2 - __shift
  property color __color: "#fff"

  property string type: "add"

  width: __side
  height: __side

  Rectangle {
    id: background
    color: type == "add" ? "#0F9D58" : "#ef5350"
    width: __side
    height: __side
    radius:__side
    anchors.fill: addButton
  }

  Item {
    id: mainContainer;

    width: addButton.width
    height: addButton.height

    anchors {
      centerIn: addButton
    }

    Rectangle {
      id: horizontalMainItem
      anchors {
        verticalCenter: mainContainer.verticalCenter
        left: mainContainer.left
        right: mainContainer.right
        leftMargin: __shift
        rightMargin: __shift
      }
      height: __minSide
      color: __color
      antialiasing: true
    }

    Rectangle {
      id: verticalMainItem
      anchors {
        horizontalCenter: mainContainer.horizontalCenter
        top: mainContainer.top
        bottom: mainContainer.bottom
        topMargin: __shift
        bottomMargin: __shift
      }
      visible: type == "add"
      width: __minSide
      color: __color
      antialiasing: true
    }
  }

  Item {
    id: errorContainer;

    width: 0
    height: 0
    anchors {
      centerIn: addButton
    }
    rotation: 45

    Rectangle {
      id: horizontalItem
      height: __minSide
      anchors {
        verticalCenter: errorContainer.verticalCenter
        left: errorContainer.left
        right: errorContainer.right
        leftMargin: __shift
        rightMargin: __shift
      }
      color: "red"
    }

    Rectangle {
      id: verticalItem
      width: __minSide
      anchors {
        horizontalCenter: errorContainer.horizontalCenter
        top: errorContainer.top
        bottom: errorContainer.bottom
        topMargin: __shift
        bottomMargin: __shift
      }
      color: "red"
    }
  }


  property int __animationDuration: 350
  property int __animationDurationRotation: 550

  Timer {
    id: stateTimer
    interval: 1000
    onTriggered: {
      if (state == "error" || state == "success")
      {
        state = "main";
        stop();
      }
    }
  }

  onStateChanged: {
    // Если установили сво-во error или success, то через секунду устанавливаем в исходное состояние main
    if (state == "error" || state == "success") {
      stateTimer.start()
    }
  }

  state: "main"
  states: [
    State {
      name: "main"
    },

    State {
      name: "wait"
      PropertyChanges { target: mainContainer; rotation: 360 }
    },

    State {
      name: "success"
    },

    State {
      name: "error"
      PropertyChanges { target: mainContainer; width: 0; height: 0; }
      PropertyChanges { target: errorContainer; width: addButton.width; height: addButton.height; }
    }
  ]

  transitions: [
    Transition {
      to: "error"

      SequentialAnimation {
        PropertyAnimation { target: mainContainer; properties: "width, height"; duration: __animationDuration; easing.type: Easing.InQuad }
        PropertyAnimation { target: errorContainer; properties: "width, height"; duration: __animationDuration; easing.type: Easing.InQuad }
      }

      //RotationAnimation { target: addButton; direction: RotationAnimation.Clockwise; duration: __animationDurationRotation; easing.type: Easing.Linear }
      //PropertyAnimation { target: leftSide;   properties: "color, rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
      //PropertyAnimation { target: topSide;    properties: "color, rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
      //PropertyAnimation { target: rightSide;  properties: "color, rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
      //PropertyAnimation { target: bottomSide; properties: "color, rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
    },

    Transition {
      to: "wait"

      RotationAnimation { target: mainContainer; loops: Animation.Infinite; direction: RotationAnimation.Clockwise; duration: __animationDurationRotation; easing.type: Easing.InQuad }
      //PropertyAnimation { target: leftSide;   properties: "rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
      //PropertyAnimation { target: topSide;    properties: "rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
      //PropertyAnimation { target: rightSide;  properties: "rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
      //PropertyAnimation { target: bottomSide; properties: "rotation, width, x, y"; duration: __animationDurationRotation; easing.type: Easing.InOutQuad }
    },

    Transition {
      to: "main"
      from: "error"

      SequentialAnimation {
        PropertyAnimation { target: errorContainer; properties: "width, height"; duration: __animationDuration; easing.type: Easing.InQuad }
        PropertyAnimation { target: mainContainer; properties: "width, height"; duration: __animationDuration; easing.type: Easing.InQuad }
      }
    }
  ]
}
