// https://codepen.io/djfav/pen/kBRQYJ
var canvas,
	context,
	width, 
	height,
	x = 0,
	y= 0,
	angle = 0;

function draw() {
	var max = 90
	var radius = ((width > height) ? width : height);
	context.clearRect(0, 0, width, height);
	context.save();
	context.translate(width / 2, height / 2);
	context.rotate(angle / Math.PI);
	for (var i = 1; i < max; i++) {
		x = Math.sin(i / 2) * (radius / (max / 2));
		context.beginPath();
		context.fillStyle = ((i % 2 !== 0) ? "#000" : "#fff");
		context.arc(x, y, radius - i * (radius / max), 0, 2 * Math.PI, false);
		context.fill();
	}
	context.restore();
	angle += 0.5;
}

window.onload = function () {
	canvas = document.getElementById('canvas');
	context = canvas.getContext('2d');
	width = window.innerWidth;
	height = window.innerHeight;
	canvas.width = width;
	canvas.height = height;
	window.setInterval(draw, 50);
};
