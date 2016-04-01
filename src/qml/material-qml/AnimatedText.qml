import QtQuick 2.2

Item {
  id: root

  implicitWidth: state == "text1" ? text1.implicitWidth : text2.implicitWidth
  implicitHeight: state == "text1" ? text1.implicitHeight : text2.implicitHeight

  property alias baseUrl: text1.baseUrl
  property alias color: text1.color

  property real contentWidth: state == "text1" ? text1.contentWidth : text2.contentWidth
  property real contentHeight: state == "text1" ? text1.contentHeight : text2.contentHeight

  property alias elide: text1.elide
  property alias font: text1.font
  property alias fontSizeMode: text1.fontSizeMode
  property alias horizontalAlignment: text1.horizontalAlignment

  property alias wrapMode: text1.wrapMode
  // TODO: more Text properties

  property string text

  property bool __componentComplete: false

  onTextChanged: {
    if (state == "text1") {
      text2.text = text
      state = "text2"
    } else {
      text1.text = text
      state = "text1"
    }
  }

  readonly property int opacityAnimation: 0
  readonly property int flipAnimation: 1
  property int animation: opacityAnimation


  Text {
    id: text1
    width: parent.width
    height: parent.height
  }

  Text {
    id: text2
    width: parent.width
    height: parent.height

    opacity: 0

    baseUrl: text1.baseUrl
    color: text1.color
    elide: text1.elide
    font: text1.font
    fontSizeMode: text1.fontSizeMode
    horizontalAlignment: text1.horizontalAlignment

    wrapMode: text1.wrapMode
  }

  state: "text1"
  states: [
    State {
      name: "text1"
    },
    State {
      name: "text2"
      PropertyChanges { target: text1; opacity: 0 }
      PropertyChanges { target: text2; opacity: 1 }
    }
  ]

  transitions: [
    Transition {
      id: t1
      enabled: root.animation == root.opacityAnimation && root.__componentComplete

      SequentialAnimation {
        NumberAnimation { target: root.state == "text2" ? text1 : text2; property: "opacity"; duration: 300; easing.type: Easing.InQuad }
        NumberAnimation { target: root.state == "text2" ? text2 : text1; property: "opacity"; duration: 300; easing.type: Easing.OutQuad }
      }
    },
    Transition {
      id: t2
      enabled: root.animation == root.flipAnimation && root.__componentComplete

      NumberAnimation { target: root.state == "text2" ? text1 : text2; property: "opacity"; duration: 400; easing.type: Easing.OutQuad }
      NumberAnimation { target: root.state == "text2" ? text1 : text2; property: "y"; duration: 400; from: 0; to: -target.implicitHeight; easing.type: Easing.OutQuad }
      NumberAnimation { target: root.state == "text2" ? text2 : text1; property: "opacity"; duration: 400; easing.type: Easing.OutQuad }
      NumberAnimation { target: root.state == "text2" ? text2 : text1; property: "y"; duration: 400; from: target.implicitHeight; to: 0; easing.type: Easing.OutQuad }
    }
  ]

  Component.onCompleted: root.__componentComplete = true
}
