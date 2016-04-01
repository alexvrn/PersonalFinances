import QtQuick 2.3

import "material-qml" as Material
import "picker" as Picker
import "material-qml/density.js" as Density


Item {
  id: root

  property int day: 15
  property int month: 12
  property int year: 2014

  property color backgroundColor: "#80cbc4"

  Rectangle {
    id: rect
    color: backgroundColor

    anchors.fill: root
    anchors.centerIn: root

    Picker.ACPicker {
      id: daysPicker

      anchors {
        right: splitLeft.left
        rightMargin: 1*Density.mm
        verticalCenter: rect.verticalCenter
      }

      model:
        ListModel {
          id: daysModel

          Component.onCompleted: {
            append({ value: -1, text: " " })
            for(var i = 1; i <= 31; i++){
              var norm = i.toString();
              if( i < 10 ) norm = "0" + i
              append({ value: i, text: norm })
            }
            append({ value: -1, text: " " })
          }
        }

      Component.onCompleted: {
        setValue(day)
      }

      onIndexSelected: {
        day = value
        var lastDate = new Date(year, month + 1, 0).getDate();
        if(day > lastDate) {
          day = lastDate;
        }
      }
    }

    Text {
      id: splitLeft
      text: ":"
      font.pixelSize: 3*Density.mm
      anchors.verticalCenter: rect.verticalCenter
      anchors.right: monthsPicker.left
      anchors.rightMargin: 1*Density.mm
    }

    Picker.ACPicker {
      id: monthsPicker

      anchors {
        verticalCenter: rect.verticalCenter
        horizontalCenter: rect.horizontalCenter
      }

      model:
        ListModel {
        id: monthsModel

        Component.onCompleted: {
          var buffDate = new Date();
          append({ value: -1, text: " " })
          for(var i = 0; i <= 11; i++){
            buffDate.setMonth(i)
            var monthNic = Qt.formatDate(buffDate, "MMM")
            monthNic = monthNic.slice(0,-1)
            append({ value: i, text: monthNic })
          }
          append({ value: -1, text: " " })
          }
        }

      Component.onCompleted: {
        setValue(month)
      }

      onIndexSelected: {
        month = value - 1
      }
    }

    Text {
      id: splitRight
      text: ":"
      font.pixelSize: 3*Density.mm
      anchors.verticalCenter: rect.verticalCenter
      anchors.left: monthsPicker.right
      anchors.leftMargin: 1*Density.mm
    }

    Picker.ACPicker {
      id: yearsPicker

      anchors {
        left: splitRight.right
        leftMargin: 1*Density.mm
        verticalCenter: rect.verticalCenter
      }

      model:
        ListModel {
          id: yearsModel

          Component.onCompleted: {
            append({ value: -1, text: " " })
            for(var i = 2001; i <= 2038; i++){
              append({ value: i, text: i.toString() })
            }
            append({ value: -1, text: " " })
          }
        }

      Component.onCompleted: {
        setValue(year%100)
      }

      onIndexSelected: {
        year = value + 2000
      }
    }
  }
}
