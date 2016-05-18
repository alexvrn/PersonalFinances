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
  property int __minuteRadius:  width * 0.4

  property int __center:  { x: width * 0.5; y: width * 0.5 }

  property var __hours: [6, 5, 4, 3, 2, 1, 12, 11, 10, 9, 8, 7]
  //property var __hoursPM: [18, 17, 16, 15, 14, 13, 0, 23, 22, 21, 20, 19]
  property var __minutes: []

  property var __hourParts: []
  property var __minuteParts: []

  property double __textOpacity: 1.0

  property int hour: 0
  property int minute: 0

  signal selectClock(int value, int mode)

  Component.onCompleted: {
    //[30, 29, ..., 1, 0, 59, 58, ..., 32, 31]
    for (var i = 30; i >= 0; i--)
      __minutes.push(i)
    for (i = 59; i >= 31; i--)
      __minutes.push(i)

    clear()
  }

  Timer {
    id: changeStateTimer
    interval: 50; running: false; repeat: true
    property int delta: 0 // индикатор итерации
    onTriggered: {
      if (__mode === __caseMinute) {
        __hourRadius += Density.dp
        __minuteRadius += Density.dp
      }
      else if (__mode === __caseHour) {
        __hourRadius -= Density.dp
        __minuteRadius -= Density.dp
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
          __minuteRadius = width * 0.5;
        }
        else if (__mode == __caseHour) {
          __hourRadius = width * 0.5;
          __minuteRadius = width * 0.4
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
    __minuteParts = []
    for (var i = 0; i < __hours.length; i++)
      __hourParts.push({x: 0, y: 0})
    for (i = 0; i < __minutes.length; i++)
      __minuteParts.push({x: 0, y: 0})

    __mode = __caseHour

    __hourRadius = width * 0.5
    __minuteRadius = width * 0.4
    __textOpacity = 1.0

    // Получение текущего времени
    var date = new Date()
    hour = (date.getHours() > 12) ? (date.getHours() - 12) : date.getHours()
    minute = date.getMinutes()

    calcClock();

    canvas.requestPaint()
  }

  function calcClock() {
    var angle;
    for (var i = 0; i < __hourParts.length; i++) {
      angle = i * Math.PI / 6
      var hourPointX = __center.x + __hourRadius*0.9 * Math.sin(angle)
      var hourPointY = __center.y + __hourRadius*0.9 * Math.cos(angle)
      __hourParts[i] = {x: hourPointX, y: hourPointY}
    }
    for (i = 0; i < __minuteParts.length; i++) {
      angle = i * Math.PI / 30
      var minutPointX = __center.x + __minuteRadius*0.9 * Math.sin(angle)
      var minutPointY = __center.y + __minuteRadius*0.9 * Math.cos(angle)
      __minuteParts[i] = {x: minutPointX, y: minutPointY}
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
      ctx.ellipse(__center.x - smallRadius, __center.y - smallRadius, 2*smallRadius, 2*smallRadius);
      ctx.fill();
      ctx.closePath();

      var bigRadius = 10*Density.dp;

      var hourIndex = __hours.indexOf(hour);
      var minuteIndex = __minutes.indexOf(minute);

      var hourCurrent = {
        x:  __hourParts[hourIndex].x,
        y: __hourParts[hourIndex].y
      }

      var minuteCurrent = {
        x: __minuteParts[minuteIndex].x,
        y: __minuteParts[minuteIndex].y
      }

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle =  Qt.rgba(0.01, 0.47, 0.74, __textOpacity);//"#0277bd"
      ctx.ellipse(hourCurrent.x - bigRadius, hourCurrent.y - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0.01, 0.47, 0.74, __textOpacity);//"#0277bd"
      ctx.lineWidth = 3
      ctx.moveTo(__center.x, __center.y);
      ctx.lineTo(hourCurrent.x, hourCurrent.y);
      ctx.stroke()
      ctx.closePath();

      // Большой круг скраю
      ctx.beginPath();
      ctx.fillStyle = Qt.rgba(0.01, 0.47, 0.74, 1.0 - __textOpacity);//"#0277bd"
      ctx.ellipse(minuteCurrent.x - bigRadius, minuteCurrent.y - bigRadius, 2*bigRadius, 2*bigRadius);
      ctx.fill();
      ctx.closePath();

      // Стрелка
      ctx.beginPath();
      ctx.strokeStyle = Qt.rgba(0.01, 0.47, 0.74, 1.0 - __textOpacity);//"#0277bd"
      ctx.lineWidth = 3
      ctx.moveTo(__center.x, __center.y);
      ctx.lineTo(minuteCurrent.x, minuteCurrent.y);
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
      ctx.ellipse(__center.x - __radius, __center.y - __radius, __radius*2, __radius*2);
      ctx.fill();

      // Стрелка
      paintArrow(ctx);

      // Часы
      ctx.beginPath();
      ctx.lineWidth = 1
      ctx.textAlign = "center";
      var hourIndex = __hours.indexOf(hour);
      for (var i = 0; i < __hours.length; i++) {
        if (hourIndex === i)
          ctx.fillStyle = Qt.rgba(100,100,100, __textOpacity);
        else
          ctx.fillStyle = Qt.rgba(0,0,0, __textOpacity);
        ctx.fillText(__hours[i], __hourParts[i].x, __hourParts[i].y)
      }
      ctx.closePath();

      // Минуты
      ctx.beginPath();
      ctx.lineWidth = 1
      var minuteIndex = __minutes.indexOf(minute);
      for (i = 0; i < __minutes.length; i++) {
        if (i%5 === 0) {
          if (minuteIndex === i)
            ctx.fillStyle = Qt.rgba(100,100,100, 1 - __textOpacity);
          else
            ctx.fillStyle = Qt.rgba(0,0,0, 1 - __textOpacity);
          ctx.fillText(__minutes[i], __minuteParts[i].x, __minuteParts[i].y)
        }
      }
      ctx.closePath();
    }

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      property bool __isPress: false

      function move(x, y) {
        switch (__mode) {
          case __caseHour:
            for (var i = 0; i < __hourParts.length; i++) {
              if (inEllipse(__hourParts[i].x, __hourParts[i].y, 10*Density.dp, x, y)) {
                hour = __hours[i]
                canvas.requestPaint()
                selectClock(hour, __caseHour)
                return
              }
            }
            break
          case __caseMinute:
            for (i = 0; i < __minuteParts.length; i++) {
              if (inEllipse(__minuteParts[i].x, __minuteParts[i].y, 10*Density.dp, x, y)) {
                minute = __minutes[i]
                canvas.requestPaint()
                selectClock(minute, __caseMinute)
              }
            }
            break
          default: console.warn("unknown type: " + __mode)
        }//switch
      }

      onPressed: {
        var x = mouse.x
        var y = mouse.y
        // Проверка, что попали в круг циферблата
        if (!inEllipse(__center.x, __center.y, __radius, x, y))
          return

        // Если таймер еще не закончил работу
        if (changeStateTimer.triggeredOnStart)
          return

        __isPress = true

        move(x, y)
      }//onPressed

      onMouseXChanged: {
        if (!__isPress)
          return;
        move(mouse.x, mouse.y)
      }

      onMouseYChanged: {
        if (!__isPress)
          return;
        move(mouse.x, mouse.y)
      }

      onReleased: {
        if (!__isPress)
          return

        __isPress = false

        switch (__mode) {
          case __caseHour:
            __mode = __caseMinute
            changeStateTimer.start()
            break
        }//switch
      }//onReleased
    }
  }
}
