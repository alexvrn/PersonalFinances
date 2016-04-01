import QtQuick 2.0


Rectangle {
  id: root

  // Сигнал может быть вызван щелчком мыши по свободному пространству
  signal closeRequested

  property bool shown: false
  property real maximumOpacity: 0.4
  property var target
  property alias animationDuration: opacityAnimation.duration

  opacity: 0
  color: "#000"
  width: typeof target !== 'undefined' ? target.width : 0
  height: typeof target !== 'undefined' ? target.height : 0

  visible: maximumOpacity != 0 ? (opacity != 0) : shown

  Behavior on opacity { PropertyAnimation { id: opacityAnimation; duration: 150 } }
  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    preventStealing: true
    acceptedButtons: Qt.LeftButton | Qt.BackButton

    // Перехватываем события колеса мыши, чтобы они не проходили через оверлей
    onWheel: {
      wheel.accepted = true
    }

    onClicked: {
      // Дополнительную кнопку мыши тоже перехватываем, на неё могут быть завязаны другие действия
      if (mouse.button == Qt.BackButton) {
        mouse.accepted = true
        return
      }

      root.closeRequested()
    }
  }

  states: [
    State {
      name: "shown"
      when: root.shown

      StateChangeScript {
        script: {
          // Находим цель для оверлея и лезем к ней
          if (!root.target) {
            var newTarget = root.parent
            do {
              root.target = newTarget
              newTarget = root.target.parent
            }
            while (newTarget && newTarget.width != 0 && newTarget.height != 0);
          }

          root.parent = root.target
          root.x = root.target.x
          root.y = root.target.y
        }
      }

      PropertyChanges {
        target: root
        opacity: root.maximumOpacity
      }
    }
  ]
}
