import QtQuick 2.3
import QtQuick.Controls 1.2


FocusScope {
  id: general
  implicitWidth: 77
  implicitHeight: 45

  signal clicked
  signal clickRippleFinished

  property color backgroundColor: "white"
  property color onColor: "#4285F4"
  property color offColor: "#5A5A5A"

  property bool checked: false
  property ExclusiveGroup exclusiveGroup: null

  activeFocusOnTab: true

  Keys.onPressed: {
    if ((event.key === Qt.Key_Space || event.key === Qt.Key_Return) && !event.isAutoRepeat)
      checked = !checked;
  }

  onExclusiveGroupChanged: {
    if (exclusiveGroup)
      exclusiveGroup.bindCheckable(root)
  }

  state: checked ? "On" : "Off"

  Rectangle {
    id: line
    anchors.centerIn: general
    width: 32
    height: circle.border.width * 3 / 5
    color: checked ? general.onColor : general.offColor
  }

  Rectangle {
    id: circle
    width: 15
    height: width
    color: general.backgroundColor
    radius: width / 2
    anchors.verticalCenter: line.verticalCenter
    border.color: general.offColor
    border.width: width / 8
    x: checked ? (line.x + line.width) : (line.x - circle.width)

    Behavior on x {
      NumberAnimation { duration: 100 }
    }

    z: line.z + 1
  }

  MouseArea {
    id: rippleArea
    anchors.fill: circle
    anchors.margins: -circle.width
    z: mouseArea.z+1

    property int min: line.x - circle.width
    property int max: line.x + line.width

    drag.target: circle
    drag.axis: Drag.XAxis
    drag.minimumX: min
    drag.maximumX: max
    drag.threshold: 0

    onReleased: {
      if (drag.active) {
        checked = (circle.x + circle.width / 2 - line.x/2 < max/2) ? false : true;
        general.state = ""
        general.state = checked ? "On" : "Off"
      }
      else {
        checked = (circle.x === max) ? false : true
      }
    }

    onPressed: {
      rippleWave.color = checked ? offColor : onColor
    }
  }

  Rectangle {
    id: focusCircle
    width: circle.width * 3
    height: width
    color: general.checked ? general.offColor : general.onColor
    radius: width / 2
    anchors.centerIn: circle
    opacity: general.focus ? 0.25 : 0
    z: circle.z + 1

    Behavior on opacity {
      NumberAnimation { duration: 200 }
    }
  }

  Ripple {
    id: rippleWave
    anchors.margins: -circle.width
    anchors.fill: circle
    mouseArea: rippleArea
    color: onColor
    radius: 3 * circle.radius
    z: circle.z + 2
    onRippleFinished: general.clickRippleFinished()
  }

  states: [
    State { name: "On" },
    State { name: "Off" }
  ]

  transitions: [
    Transition {
      to: "Off"

      SequentialAnimation {
        PropertyAnimation { target: click; property: "anchors.horizontalCenterOffset"; to: (- 0.5 * circle.width); duration: 0 }
        PropertyAnimation { target: circle; property: "x"; to: mouseArea.min; duration: 100 }
        ParallelAnimation {
          PropertyAnimation { target: circle; property: "color"; to: general.backgroundColor; duration: 0 }
          PropertyAnimation { target: circle; property: "border.color"; to: general.offColor; duration: 0 }
          PropertyAnimation { target: line; property: "color"; to: general.offColor; duration: 0 }
        }
      }
    },
    Transition {
      to: "On"

      SequentialAnimation {
        PropertyAnimation { target: click; property: "anchors.horizontalCenterOffset"; to: (0.5 * circle.width); duration: 0 }
        PropertyAnimation { target: circle; property: "x"; to: mouseArea.max; duration: 100 }
        PropertyAnimation { target: line; property: "color"; to: general.onColor; duration: 0 }
      }
    }
  ]

  Rectangle {
    id: click
    width: line.width + circle.width * 3
    height: circle.height * 3
    radius: circle.height * 1.5
    opacity: 0
    color: "lightblue"
    anchors.centerIn:  line
    anchors.horizontalCenterOffset: checked ? (0.5 * circle.width) : (- 0.5 * circle.width)
    z: line.z - 1

  }

  Rectangle {
    id: raisedCircle
    width: checked ? (circle.width + 2) : 0

    Behavior on width {
      NumberAnimation { duration: 100 }
    }

    height: width
    color: general.onColor
    radius: width / 2
    anchors.centerIn: circle
    z: line.z + 2

  }

  onCheckedChanged:  {
    general.state = checked ? "On" : "Off"
  }

  MouseArea {
    id: mouseArea
    property int min: line.x - circle.width
    property int max: line.x + line.width

    drag.target: circle
    drag.axis: Drag.XAxis
    drag.minimumX: min
    drag.maximumX: max
    drag.threshold: 0
    anchors.fill: click

    onReleased: {
      if (drag.active) {
        checked = (circle.x + circle.width / 2 - line.x/2 < max/2) ? false : true;
        general.state = ""
        general.state = checked ? "On" : "Off"
      }
      else {
        checked = (circle.x === max) ? false : true
      }
    }
  }
}
