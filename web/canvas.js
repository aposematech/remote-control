// https://codepen.io/djfav/pen/kBRQYJ
// https://js1k.com/2014-dragons/demo/1959

var window;
var document;
var canvas;
var context;
var width;
var height;
var radius;
var x = 0;
var y = 0;
var angle = 0;
var max = 90;

function draw() {
  var i;
  context.clearRect(0, 0, width, height);
  context.save();
  context.translate(width / 2, height / 2);
  context.rotate(angle / Math.PI);
  for (i = 1; i < max; i += 1) {
    x = Math.sin(i / 2) * (radius / (max / 2));
    context.beginPath();
    // if (i % 4 === 0) {
    //   context.fillStyle = "white";
    // } else if (i % 2 === 0) {
    //   context.fillStyle = "red";
    // } else {
    //   context.fillStyle = "black";
    // }
    context.fillStyle = i % 2 !== 0 ? "black" : "white";
    context.arc(x, y, radius - i * (radius / max), 0, 2 * Math.PI, false);
    context.fill();
  }
  context.restore();
  angle += 0.1;
  window.requestAnimationFrame(draw);
}

window.onload = function () {
  canvas = document.getElementById("canvas");
  context = canvas.getContext("2d");
  width = window.innerWidth;
  height = window.innerHeight;
  canvas.width = width;
  canvas.height = height;
  radius = width > height ? width : height;
  window.requestAnimationFrame(draw);
};
