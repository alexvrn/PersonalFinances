import QtQuick 2.3

import "material-qml" as Material
import "picker" as Picker
import "material-qml/density.js" as Density


Item {
  id: root

  property color backgroundColor: "#80cbc4"

  property int hours: 12
  property int minutes: 00

  Rectangle {
    id: rect
    color: backgroundColor

    anchors.fill: root
    anchors.centerIn: root

    Picker.ACPicker {
      id: hoursPicker

      anchors {
        right: center.left
        rightMargin: 1*Density.mm
        verticalCenter: rect.verticalCenter
      }

      model:
        ListModel {
        id: hoursModel

        Component.onCompleted: {
          append({ value: -1, text: " " })
            for(var i = 0; i <= 23; i++){
              var norm = i.toString();
              if( i < 10 ) norm = "0" + i
              append({ value: i, text: norm })
            }
          append({ value: -1, text: " " })
        }

        Component.onCompleted: {
          setValue(hours + 1)
        }
      }
    }

    Text {
      id: center
      text: ":"
      font.pixelSize: 3*Density.mm
      anchors.centerIn: rect
    }

    Picker.ACPicker {
      id: minutesPicker

      anchors {
        left: center.right
        leftMargin: 1*Density.mm
        verticalCenter: rect.verticalCenter
      }

      model:
        ListModel {
        id: minutesModel

        Component.onCompleted: {
          append({ value: -1, text: " " })
          for(var i = 0; i <= 59; i++){
            var norm = i.toString();
            if( i < 10 ) norm = "0" + i
              append({ value: i, text: norm })
            }
            append({ value: -1, text: " " })
          }
        }

        Component.onCompleted: {
          setValue(minutes + 1)
      }
    }
  }
}
