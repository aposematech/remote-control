#!/usr/bin/env python3.9

import qrcode                   # https://pypi.org/project/qrcode/
from PIL import Image, ImageOps # https://pypi.org/project/Pillow/

# generate qrcode
qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=50,
    border=5,
)
qr.add_data("https://remotecontrol.solutions")
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white")
img.save("remotecontrol.png")
# add border
ImageOps.expand(Image.open('remotecontrol.png'),border=1,fill='black').save('remotecontrol_border.png')
# resize
img = Image.open('remotecontrol_border.png')
img = img.resize((1500, 1500))
img.save('remotecontrol_resize.png')
