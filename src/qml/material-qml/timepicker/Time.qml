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

  property int __radius:  width * 0.5
  property int __hourRadius:  width * 0.4
  //property int __hourRadiusPM:  width * 0.3
  property int __minutRadius:  width * 0.4

  property int __centerX:  width * 0.5
  property int __centerY:  width * 0.5

  property var __hours: [6, 5, 4, 3, 2, 1, 12, 11, 10, 9, 8, 7]
  //property var __hoursPM: [18, 17, 16, 15, 14, 13, 0, 23, 22, 21, 20, 19]
  property var __minuts: [30, 25, 20, 15, 10, 5, 0, 55, 50, 45, 40, 35]

  property var __hourParts: []
  property var __minutParts: []

  property double __textOpacity: 1.0

  property int hour: 0
  property int minut: 0


  Component.onCompleted: {
    clear()
  }

  Timer {
    id: changeStateTimer
    interval: 50; running: false; repeat: true
    property int delta: 0
    onTriggered: {
      if (__mode === __caseMinute) {
        __hourRadius += Density.dp
        __minutRadius += Density.dp
      }
      else if (__mode === __caseHour) {
        __hourRadius -= Density.dp
        __minutRadius -= Density.dp
      }

      delta++;
      if (__mode === __caseMinute) {
        __textOpacity -= 0.1;
      }
      else {
        if (__textOpacity === 0.0)
          __textOpacity = 0.1
        else
          __textOpacity += 0.1;
      }

      if (delta > 10) {
        delta = 0
        __textOpacity = __mode === __caseMinute ? 0.0 : 1.0
        stop()

        if (__mode === __caseMinute) {
          __minutRadius = width * 0.5;
        }
        else if (__mode == __caseHour) {
          __hourRadius = width * 0.5;
          __minutRadius = width * 0.4
        }
      }

      calcClock()
      canvas.requestPaint()
    }
  }

  function selectHour() {
    if (changeStateTimer.triggeredOnStart)
      return;

    if (__mode === __caseHour)
      return;

    __mode = __caseHour
    changeStateTimer.start()
  }

  function selectMinute() {
    if (changeStateTimer.triggeredOnStart)
      return;

    if (__mode === __caseMinute)
      return;

    __mode = __caseMinute
    changeStateTimer.start()
  }

  function clear() {
    __hourParts = []
    __minutParts = []
    for (var i = 0; i < 12; i++) {
      __hourParts.push({x: 0, y: 0})
      __minutParts.push({x: 0, y: 0})
    }

    __mode = __caseHour

    __hourRadius = width * 0.5
    __minutRadius = width * 0.4
    __textOpacity = 1.0

    // Получение текущего времени
    var date = new Date()
    hour = 9//date.getHours()
    minut = 25//date.getMinutes()
    console.debug(hour)
    console.debug(minut)

    calcClock();

    canvas.requestPaint()
  }

  function calcClock() {
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

      var bigRadius = 10*Density.dp;

      var hourIndex = __hours.indexOf(hour);
      var minuteIndex = __minuts.indexOf(minut);

      var __hourCurrentX =  __hourParts[hourIndex].x
      var __hourCurrentY =  __hourParts[hourIndex].y

      var __minuteCurrentX =  __minutParts[minuteIndex].x
      var __minuteCurrentY =  __minutParts[minuteIndex].y

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0,0,0, __textOpacity);
      ctx.ellipse(__hourCurrentX - bigRadius, __hourCurrentY - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0,0,0, __textOpacity);
      ctx.lineWidth = 3
      ctx.moveTo(__centerX, __centerY);
      ctx.lineTo(__hourCurrentX, __hourCurrentY);
      ctx.stroke()
      ctx.closePath();

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0,0,0, 1.0 - __textOpacity);
      ctx.ellipse(__minuteCurrentX - bigRadius, __minuteCurrentY - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0,0,0, 1.0 - __textOpacity);
      ctx.lineWidth = 3
      ctx.moveTo(__centerX, __centerY);
      ctx.lineTo(__minuteCurrentX, __minuteCurrentY);
      ctx.stroke()
      ctx.closePath();
    }

    onPaint: {
      var ctx = getContext("2d");

      // Фон
      ctx.beginPath();
      ctx.fillStyle = "white";
      ctx.fillRect(0, 0, width, height);
      ctx.fill();
      ctx.closePath();

      // Циферблат
      ctx.fillStyle = "#e0e0e0";
      ctx.ellipse(__centerX - __radius, __centerY - __radius, __radius*2, __radius*2);
      ctx.fill();

      // Стрелка
      paintArrow(ctx);

      // Часы
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0,0,0, __textOpacity);
      ctx.lineWidth = 1
      ctx.textAlign="center";
      for (var i = 0; i < 12; i++)
        ctx.fillText(__hours[i], __hourParts[i].x, __hourParts[i].y)
      ctx.closePath();

      // Минуты
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0,0,0, 1 - __textOpacity);
      ctx.lineWidth = 1
      for (i = 0; i < 12; i++)
        ctx.fillText(__minuts[i], __minutParts[i].x, __minutParts[i].y)
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

        //
        if (changeStateTimer.triggeredOnStart)
          return

        for (var i = 0; i < 12; i++) {
          switch (__mode) {
            case __caseHour:
              if (inEllipse(__hourParts[i].x, __hourParts[i].y, 10*Density.dp, x, y)) {
                __mode = __caseMinute
                hour = __hours[i]
                changeStateTimer.start()
                return
              }
              break
            case __caseMinute:
              if (inEllipse(__minutParts[i].x, __minutParts[i].y, 10*Density.dp, x, y)) {
                minut = __minuts[i]
                canvas.requestPaint()
              }
              break
            default:
          }//switch
        }//for
      }//onClicked
    }
  }
}
