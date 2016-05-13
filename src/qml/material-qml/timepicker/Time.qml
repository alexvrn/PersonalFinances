import QtQuick 2.3

import ".." as Material
import "../density.js" as Density

Rectangle {
  id: time

  width: 200*Density.dp
  height: width

  color: "#f5f5f5"

  property int __caseHour: 0
  property int __caseMinute: 1

  property int __mode: __caseHour

  property int __radius:  width * 0.3
  property int __hourRadius:  width * 0.3
  property int __minutRadius:  width * 0.3

  property int __centerX:  width / 2
  property int __centerY:  width / 2

  property var __hours: [6, 5, 4, 3, 2, 1, 0, 11, 10, 9, 8, 7]
  property var __minuts: [30, 25, 20, 15, 10, 5, 0, 55, 50, 45, 40, 35]

  property var __hourParts: []
  property var __minutParts: []

  property int __currentX: 0
  property int __currentY: 0

  property double __textOpacity: 1.0

  Component.onCompleted: {
    for (var i = 0; i < 12; i++) {
      __hourParts.push({x: 0, y: 0})
      __minutParts.push({x: 0, y: 0})
    }

    calcHours();

    __currentX = __hourParts[0].x
    __currentY = __hourParts[0].y
  }

  Timer {
    id: changeStateTimer
    interval: 100; running: false; repeat: true
    property int delta: 0
    onTriggered: {
      __hourRadius += Density.dp
      __minutRadius += Density.dp
      calcHours()
      canvas.requestPaint()

      delta++;
      __textOpacity /= 2;
      if (delta > 10*Density.dp) {
        delta = 0
        stop()

        __radius = width * 0.3;
        __textOpacity = 1.0
        calcHours()
        canvas.requestPaint()
      }
    }
  }

  function calcHours() {
    for (var i = 0; i < 12; i++) {
      var angle = i * Math.PI / 6
      var hourPointX = __centerX + __hourRadius*0.9 * Math.sin(angle)
      var hourPointY = __centerY + __hourRadius*0.9 * Math.cos(angle)
      var minutPointX = __centerX + __minutRadius*0.9 * Math.sin(angle)
      var minutPointY = __centerY + __minutRadius*0.9 * Math.cos(angle)
      __hourParts[i] = {x: hourPointX, y: hourPointY}
      __minutParts[i] = {x: minutPointX, y: minutPointY}
    }
  }

  function inEllipse(centerX, centerY, radius, x, y) {
    return Math.pow(x - centerX, 2) + Math.pow(y - centerY, 2) <= Math.pow(radius, 2)
  }

  Canvas {
    id: canvas
    anchors.fill: parent

    function paintArrow(ctx) {
      // Маленький круг в центре
      ctx.beginPath();
      ctx.fillStyle = "#0277bd";
      var smallRadius = 5*Density.dp;
      ctx.ellipse(__centerX - smallRadius, __centerY - smallRadius, 2*smallRadius, 2*smallRadius);
      ctx.fill();
      ctx.closePath();

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle = "#0277bd";
      var bigRadius = 10*Density.dp;
      ctx.ellipse(__currentX - bigRadius, __currentY - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = "#0277bd";
      ctx.lineWidth = 3
      ctx.moveTo(__centerX, __centerY);
      ctx.lineTo(__currentX, __currentY);
      ctx.stroke()
      ctx.closePath();
    }

    onPaint: {
      // Большой круг
      var ctx = getContext("2d");

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle = "white";
      ctx.fillRect(0, 0, width, height);
      ctx.fill();
      ctx.closePath();

      ctx.fillStyle = "#e0e0e0";
      ctx.ellipse(__centerX - __radius, __centerY - __radius, __radius*2, __radius*2);
      ctx.fill();

      // Стрелка
      paintArrow(ctx);

      // Текст цифры
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0,0,0, __textOpacity);
      ctx.lineWidth = 1
      ctx.font = "50pt";
      switch (__mode) {
        case __caseHour:
          for (var i = 0; i < 12; i++) {
            ctx.strokeText(__hourParts[i], __hourParts[i].x, __hourParts[i].y)
          }
          break
        case __caseMinute:
          for (i = 0; i < 12; i++) {
            ctx.strokeText(__minutParts[i], __ts[i].x, __minutParts[i].y)
          }
          break
        default:
      }
      ctx.stroke()
      ctx.closePath();
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent

      onClicked: {
        var x = mouse.x
        var y = mouse.y
        // Проверка, что попали в круг циферблата
        if (!inEllipse(__centerX, __centerY, __radius, x, y))
          return

        for (var i = 0; i < 12; i++) {
          switch (__mode) {
            case __caseHour:
              if (inEllipse(__hourParts[i].x, __hourParts[i].y, 10*Density.dp, x, y)) {
                __currentX = __hourParts[i].x
                __currentY = __hourParts[i].y
                changeStateTimer.start()
                return
              }
              break
            case __caseMinute:
              if (inEllipse(__minutParts[i].x, __minutParts[i].y, 10*Density.dp, x, y)) {
                __currentX = __minutParts[i].x
                __currentY = __minutParts[i].y
              }
              break
            default: {}
          }//switch
        }//for
      }//onClicked
    }
  }
}
