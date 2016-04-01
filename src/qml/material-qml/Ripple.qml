import QtQuick 2.0
import "ink.js" as Ink
import "density.js" as Density

Canvas {
  id: canvas
  anchors.fill: parent

  renderStrategy: Canvas.Cooperative

  signal rippleFinished

  property color color: '#d8d8d8'
  property real radius: 0
  property Item mouseArea

  property bool backgroundFill: true
  property bool recenteringTouch: false

  property var __waves: []
  property real __initialOpacity: 0.25
  property real __opacityDecayVelocity: 0.8

  Connections {
    target: mouseArea

    onPressed: {
      var wave = Ink.createWave(canvas.color);

      wave.isMouseDown = true;
      wave.tDown = 0.0;
      wave.tUp = 0.0;
      wave.mouseDownStart = Date.now();
      wave.mouseUpStart = 0.0;

      var width = canvas.width;
      var height = canvas.height;

      var realMouse = mapFromItem(mouseArea, mouse.x, mouse.y);
      wave.startPosition = { x: realMouse.x, y: realMouse.y };

      if (recenteringTouch) {
        wave.endPosition = { x: width / 2, y: height / 2 };
        wave.slideDistance = Ink.dist(wave.startPosition, { w: width, h: height });
      }
      wave.containerSize = Math.max(width, height);
      wave.containerWidth = width;
      wave.containerHeight = height;
      wave.maxRadius = Ink.distanceFromPointToFurthestCorner(wave.startPosition, {w: width, h: height});

      __waves.push(wave);

      if (!t.running)
        t.start()
    }

    function release() {
      for (var i = 0; i < __waves.length; i++) {
        var wave = __waves[i];
        if (wave.isMouseDown) {
          wave.isMouseDown = false
          wave.mouseUpStart = Date.now();
          wave.mouseDownStart = 0;
          wave.tUp = 0.0;
          break;
        }
      }

      t.start();
    }

    onCanceled: release()
    onReleased: release()
  }

  Timer {
    id: t
    interval: 1000 / 60
    repeat: true
    triggeredOnStart: true

    onTriggered: canvas.requestPaint()
  }

  property int __sourceX: 0
  property int __sourceY: 0

  function drawRoundedRect(ctx, x, y, w, h, r) {
    var r2d = Math.PI/180;
    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.lineTo(x + w -r, y);
    ctx.arc(x + w - r, y + r, r, r2d * 270, r2d * 360, false);
    ctx.lineTo(x + w, y + h -r);
    ctx.arc(x + w - r, y + h - r, r, r2d * 0, r2d * 90, false);
    ctx.lineTo(x + r, y + h);
    ctx.arc(x + r, y + h - r, r, r2d * 90, r2d * 180, false);
    ctx.lineTo(x, y + r);
    ctx.arc(x + r, y+r, r, r2d * 180, r2d * 270, false);
    ctx.closePath();
  }

  function drawRipple(ctx, wave, x, y, radius, innerAlpha, outerAlpha) {
    ctx.fillStyle = wave.waveColor;

    // Fill background if needed
    if (outerAlpha !== undefined) {
      ctx.globalAlpha = outerAlpha;
      ctx.fillRect(0, 0, canvas.width, canvas.height);
    }

    ctx.globalAlpha = innerAlpha;
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, 2 * Math.PI, true);
    ctx.fill();
  }

  onPaint: {
    if (!t.running)
      return;

    // Initialize canvas rendering context and set clipping region
    var ctx = canvas.getContext("2d");
    ctx.clearRect(0, 0, width, height);
    drawRoundedRect(ctx, 0, 0, width, height, canvas.radius);
    ctx.save();
    ctx.clip();

    var shouldRenderNextFrame = false;

    var deleteTheseWaves = [];
    // The oldest wave's touch down duration
    var longestTouchDownDuration = 0;
    var longestTouchUpDuration = 0;
    // Save the last known wave color
    var lastWaveColor = null;
    // wave animation values
    var anim = {
      initialOpacity: __initialOpacity,
      opacityDecayVelocity: __opacityDecayVelocity,
      height: height,
      width: width
    }

    for (var i = 0; i < __waves.length; i++) {
      var wave = __waves[i];

      if (wave.mouseDownStart > 0) {
        wave.tDown = Date.now() - wave.mouseDownStart;
      }
      if (wave.mouseUpStart > 0) {
        wave.tUp = Date.now() - wave.mouseUpStart;
      }

      // Determine how long the touch has been up or down.
      var tUp = wave.tUp;
      var tDown = wave.tDown;
      longestTouchDownDuration = Math.max(longestTouchDownDuration, tDown);
      longestTouchUpDuration = Math.max(longestTouchUpDuration, tUp);

      // Obtain the instantenous size and alpha of the ripple.
      var radius = Ink.waveRadiusFn(tDown, tUp, anim, Density.dp);
      var waveAlpha =  Ink.waveOpacityFn(tDown, tUp, anim);

      // Position of the ripple.
      var x = wave.startPosition.x;
      var y = wave.startPosition.y;

      // Ripple gravitational pull to the center of the canvas.
      if (wave.endPosition) {
        // This translates from the origin to the center of the view  based on the max dimension of
        var translateFraction = Math.min(1, radius / wave.containerSize * 2 / Math.sqrt(2) );

        x += translateFraction * (wave.endPosition.x - wave.startPosition.x);
        y += translateFraction * (wave.endPosition.y - wave.startPosition.y);
      }

      // If we do a background fill fade too, work out the correct color.
      var bgFillAlpha = null;
      if (canvas.backgroundFill) {
        bgFillAlpha = Ink.waveOuterOpacityFn(tDown, tUp, anim);
      }

      // Draw the ripple.
      drawRipple(ctx, wave, x, y, radius, waveAlpha, bgFillAlpha);

      // Determine whether there is any more rendering to be done.
      var maximumWave = Ink.waveAtMaximum(wave, radius, anim, Density.dp);
      var waveDissipated = Ink.waveDidFinish(wave, radius, anim, Density.dp);
      var shouldKeepWave = !waveDissipated || maximumWave;
      // keep rendering dissipating wave when at maximum radius on upAction
      var shouldRenderWaveAgain = wave.mouseUpStart ? !waveDissipated : !maximumWave;
      shouldRenderNextFrame = shouldRenderNextFrame || shouldRenderWaveAgain;
      if (!shouldKeepWave || this.cancelled) {
        deleteTheseWaves.push(wave);
      }
    }

    if (!shouldRenderNextFrame) {
      t.stop();
    }
    ctx.restore();

    for (var i = 0; i < deleteTheseWaves.length; ++i) {
      var pos = __waves.indexOf(deleteTheseWaves[i]);
      __waves.splice(pos, 1);
      canvas.rippleFinished()
    }

    if (__waves.length == 0) {
      ctx.clearRect(0, 0, width, height);
    }
  }


  Component.onCompleted: {
    canvas.width = parent.width
    canvas.height = parent.height

    if (parent.hasOwnProperty("radius"))
      canvas.radius = parent.radius
  }
}
