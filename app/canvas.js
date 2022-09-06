// https://codepen.io/djfav/pen/kBRQYJ
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
    for (i = 1; i < max; i++) {
        x = Math.sin(i / 2) * (radius / (max / 2));
        context.beginPath();
        context.fillStyle = ((i % 2 !== 0) ? "black" : "white");
        context.arc(x, y, radius - i * (radius / max), 0, 2 * Math.PI, false);
        context.fill();
    }
    context.restore();
    angle += 0.2;
}

window.onload = function () {
    canvas = document.getElementById('canvas');
    context = canvas.getContext('2d');
    width = window.innerWidth;
    height = window.innerHeight;
    canvas.width = width;
    canvas.height = height;
    radius = ((width > height) ? width : height);
    window.setInterval(draw, 20);
};
