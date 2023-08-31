#!/usr/bin/env python3.9

# https://pypi.org/project/qrcode/
import qrcode

qr = qrcode.QRCode(
    version=1,
    error_correction=qrcode.constants.ERROR_CORRECT_L,
    box_size=20,
    border=4,
)
qr.add_data("https://remotecontrol.solutions")
qr.make(fit=True)
img = qr.make_image(fill_color="black", back_color="white")
img.save("remotecontrol.png")
