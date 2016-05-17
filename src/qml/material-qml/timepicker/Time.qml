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
  property var __minuts: []

  property var __hourParts: []
  property var __minutParts: []

  property double __textOpacity: 1.0

  property int hour: 0
  property int minut: 0

  signal selectClock(int value, int mode)

  Component.onCompleted: {
    //[30, 29, ..., 1, 0, 59, 58, ..., 32, 31]
    for (var i = 30; i >= 0; i--)
      __minuts.push(i)
    for (i = 59; i >= 31; i--)
      __minuts.push(i)

    clear()
  }

  Timer {
    id: changeStateTimer
    interval: 50; running: false; repeat: true
    property int delta: 0 // индикатор итерации
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
    // Если нтаймер еще не закончил работу
    if (changeStateTimer.triggeredOnStart)
      return;

    if (__mode === __caseHour)
      return;

    __mode = __caseHour
    changeStateTimer.start()
  }

  function selectMinute() {
    // Если нтаймер еще не закончил работу
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
    for (var i = 0; i < __hours.length; i++)
      __hourParts.push({x: 0, y: 0})
    for (i = 0; i < __minuts.length; i++)
      __minutParts.push({x: 0, y: 0})

    __mode = __caseHour

    __hourRadius = width * 0.5
    __minutRadius = width * 0.4
    __textOpacity = 1.0

    // Получение текущего времени
    var date = new Date()
    hour = (date.getHours() > 12) ? (date.getHours() - 12) : date.getHours()
    minut = date.getMinutes()
    selectClock(hour, __caseHour)
    selectClock(minut, __caseMinute)

    calcClock();

    canvas.requestPaint()
  }

  function calcClock() {
    var angle;
    for (var i = 0; i < __hourParts.length; i++) {
      angle = i * Math.PI / 6
      var hourPointX = __centerX + __hourRadius*0.9 * Math.sin(angle)
      var hourPointY = __centerY + __hourRadius*0.9 * Math.cos(angle)
      __hourParts[i] = {x: hourPointX, y: hourPointY}
    }
    for (i = 0; i < __minutParts.length; i++) {
      angle = i * Math.PI / 30
      var minutPointX = __centerX + __minutRadius*0.9 * Math.sin(angle)
      var minutPointY = __centerY + __minutRadius*0.9 * Math.cos(angle)
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
      ctx.fillStyle =  Qt.rgba(0.01, 0.47, 0.74, __textOpacity);//"#0277bd"
      ctx.ellipse(__hourCurrentX - bigRadius, __hourCurrentY - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0.01, 0.47, 0.74, __textOpacity);//"#0277bd"
      ctx.lineWidth = 3
      ctx.moveTo(__centerX, __centerY);
      ctx.lineTo(__hourCurrentX, __hourCurrentY);
      ctx.stroke()
      ctx.closePath();

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0.01, 0.47, 0.74, 1.0 - __textOpacity);//"#0277bd"
      ctx.ellipse(__minuteCurrentX - bigRadius, __minuteCurrentY - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0.01, 0.47, 0.74, 1.0 - __textOpacity);//"#0277bd"
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
      for (var i = 0; i < __hours.length; i++)
        ctx.fillText(__hours[i], __hourParts[i].x, __hourParts[i].y)
      ctx.closePath();

      // Минуты
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0,0,0, 1 - __textOpacity);
      ctx.lineWidth = 1
      for (i = 0; i < __minuts.length; i++) {
        if (i%5 === 0)
          ctx.fillText(__minuts[i], __minutParts[i].x, __minutParts[i].y)
      }
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

        // Если нтаймер еще не закончил работу
        if (changeStateTimer.triggeredOnStart)
          return

        switch (__mode) {
          case __caseHour:
            for (var i = 0; i < __hourParts.length; i++) {
              if (inEllipse(__hourParts[i].x, __hourParts[i].y, 10*Density.dp, x, y)) {
                __mode = __caseMinute
                hour = __hours[i]
                changeStateTimer.start()
                selectClock(hour, __caseHour)
                return
              }
            }
            break
          case __caseMinute:
            for (i = 0; i < __minutParts.length; i++) {
              if (inEllipse(__minutParts[i].x, __minutParts[i].y, 10*Density.dp, x, y)) {
                minut = __minuts[i]
                canvas.requestPaint()
                selectClock(minut, __caseMinute)
              }
            }
            break
          default: console.warn("unknown type: " + __mode)
        }//switch
      }//onClicked
    }
  }
}
