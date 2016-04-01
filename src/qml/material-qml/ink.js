.pragma library

// Based on Polymer Project components code from: https://github.com/Polymer/paper-ripple/
// Ported by Boris Moiseev <cyberbobs@gmail.com>, 2014

// Ink equations
var waveMaxRadius = 150;

function waveRadiusFn(touchDownMs, touchUpMs, anim, dp) {
  // Convert from ms to s.
  var touchDown = touchDownMs / 1000;
  var touchUp = touchUpMs / 1000;
  var totalElapsed = touchDown + touchUp;
  var ww = anim.width, hh = anim.height;
  // use diagonal size of container to avoid floating point math sadness
  var waveRadius = Math.min(Math.sqrt(ww * ww + hh * hh), (waveMaxRadius * dp)) * 1.1 + 5 * dp;
  var duration = 1.1 - .2 * (waveRadius / (waveMaxRadius * dp) );
  var tt = (totalElapsed / duration);

  var size = waveRadius * (1 - Math.pow(80, -tt));
  return Math.abs(size);
}


function waveOpacityFn(td, tu, anim) {
  // Convert from ms to s.
  var touchDown = td / 1000;
  var touchUp = tu / 1000;
  var totalElapsed = touchDown + touchUp;

  if (tu <= 0) {  // before touch up
    return anim.initialOpacity;
  }
  return Math.max(0, anim.initialOpacity - touchUp * anim.opacityDecayVelocity);
}


function waveOuterOpacityFn(td, tu, anim) {
  // Convert from ms to s.
  var touchDown = td / 1000;
  var touchUp = tu / 1000;

  // Linear increase in background opacity, capped at the opacity
  // of the wavefront (waveOpacity).
  var outerOpacity = touchDown * 0.3;
  var waveOpacity = waveOpacityFn(td, tu, anim);
  return Math.max(0, Math.min(outerOpacity, waveOpacity));
}


// Determines whether the wave should be completely removed.
function waveDidFinish(wave, radius, anim, dp) {
  var waveOpacity = waveOpacityFn(wave.tDown, wave.tUp, anim);

  // If the wave opacity is 0 and the radius exceeds the bounds
  // of the element, then this is finished.
  return waveOpacity < 0.01 && radius >= Math.min(wave.maxRadius, (waveMaxRadius * dp));
};


function waveAtMaximum(wave, radius, anim, dp) {
  var waveOpacity = waveOpacityFn(wave.tDown, wave.tUp, anim);

  return waveOpacity >= anim.initialOpacity && radius >= Math.min(wave.maxRadius, (waveMaxRadius * dp));
}


// Setup
function createWave(color) {
  var wave = {
    waveColor: color,
    maxRadius: 0,
    isMouseDown: false,
    mouseDownStart: 0.0,
    mouseUpStart: 0.0,
    tDown: 0,
    tUp: 0
  };
  return wave;
}


// Shortcuts
function dist(p1, p2) {
  return Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2));
}


function distanceFromPointToFurthestCorner(point, size) {
  var tl_d = dist(point, {x: 0, y: 0});
  var tr_d = dist(point, {x: size.w, y: 0});
  var bl_d = dist(point, {x: 0, y: size.h});
  var br_d = dist(point, {x: size.w, y: size.h});
  return Math.max(tl_d, tr_d, bl_d, br_d);
}
