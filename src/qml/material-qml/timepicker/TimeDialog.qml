import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Material.Dialog {
  id: timeDialog

  property int hour: 0
  property int minute: 0

  property color __activeColor: "white"
  property color __noActiveColor: "#81d4fa"


  Component.onCompleted: {
    // Получение текущего времени
    var date = new Date()
    var hour = (date.getHours() > 12) ? (date.getHours() - 12) : date.getHours()
    var minute = date.getMinutes()
    hourLabel.text = format2(hour)
    minuteLabel.text = format2(minute)
    hourLabel.color = __activeColor
    minuteLabel.color = __noActiveColor
  }

  function format2(n) {
    var s = n.toString()
    if (n < 10)
      s = "0" + s

    return s
  }

  Rectangle {
    color: "#0277bd"
    anchors {
      left: parent.left
      right: parent.right
      top: parent.top
    }
    height: 50*Density.dp

    Text {
      id: hourLabel
      color: "white"
      anchors {
        top: parent.top
        right: splitter.left
        left: parent.left
        bottom: parent.bottom
      }
      font {
        family: "Roboto, sans-serif"
        pointSize: 24*Density.dp
      }
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter

      onTextChanged: changeHourValueAnimation.start()

      MouseArea {
        anchors.fill: hourLabel
        onClicked: {
          time.selectHour()
          changeHourValueAnimation.start()
          hourLabel.color = __activeColor
          minuteLabel.color = __noActiveColor
        }
      }

      SequentialAnimation {
        id: changeHourValueAnimation
        PropertyAnimation {target: hourLabel; easing.type: Easing.InBack; properties: "font.pointSize"; to: 27; duration: 100}
        PropertyAnimation {target: hourLabel; easing.type: Easing.InBack; properties: "font.pointSize"; to: 24; duration: 100}
      }
    }
    Text {
      id: splitter
      color: "white"
      text: ":"
      anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
      }
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      font.pointSize: 24*Density.dp
    }
    Text {
      id: minuteLabel
      color: "#e0e0e0"
      anchors {
        top: parent.top
        left: splitter.right
        bottom: parent.bottom
        right: parent.right
      }
      font {
        family: "Roboto, sans-serif"
        pointSize: 24*Density.dp
      }
      horizontalAlignment: Text.AlignHLeft
      verticalAlignment: Text.AlignVCenter

      onTextChanged: changeMinuteValueAnimation.start()

      MouseArea {
        anchors.fill: minuteLabel
        onClicked: {
          time.selectMinute()
          changeMinuteValueAnimation.start()
          minuteLabel.color = __activeColor
          hourLabel.color = __noActiveColor
        }
      }

      SequentialAnimation {
        id: changeMinuteValueAnimation
        PropertyAnimation {target: minuteLabel; easing.type: Easing.InBack; properties: "font.pointSize"; to: 27; duration: 100}
        PropertyAnimation {target: minuteLabel; easing.type: Easing.InBack; properties: "font.pointSize"; to: 24; duration: 100}
      }
    }
  }

  Time {
    id: time
    anchors {
      bottom: okButton.top
      bottomMargin: 20*Density.dp
      horizontalCenter: parent.horizontalCenter
    }

    onSelectClock: {
      // FIXME: 'n' => '0n'
      var sValue = format2(value)

      if (mode === 0) {
        hourLabel.text = sValue
        hour = value
      }
      else if (mode === 1) {
        minuteLabel.text = sValue
        minute = value
      }
      hourLabel.color = __noActiveColor
      minuteLabel.color = __activeColor
    }
  }

  Material.PaperButton {
    id: cancelButton

    width: 40*Density.dp
    anchors {
      right: okButton.left
      rightMargin: 3*Density.dp
      bottomMargin: 10*Density.dp
      bottom: parent.bottom
    }

    context: "dialog"
    text: "Отмена"

    onClicked: {
      time.clear()
      timeDialog.close()
    }
  }

  Material.PaperButton {
    id: okButton

    width: 60*Density.dp
    anchors {
      right: parent.right
      bottomMargin: 10*Density.dp
      bottom: parent.bottom
    }

    context: "dialog"
    text: "OK"

    onClicked: {
      time.clear()
      timeDialog.close()
    }
  }
}
