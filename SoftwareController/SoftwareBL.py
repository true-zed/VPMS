# Software Business Logic

import os
import qrcode

from time import sleep
from subprocess import Popen
from django.conf import settings


# Constant for filepath and filename
BASE_DIR = settings.BASE_DIR.parent
script_path = BASE_DIR / 'SoftwareController/Scripts/'
qr_path = BASE_DIR / 'SoftwareController/QrCodes/'
qr_name = 'qrcode.png'
scancode_script_name = 'open_wab_web.sh'

# Constant for background size of qr code
background_width = 2000
background_height = 1500

# Default video source (he-he-he, hi Captain!)
default_video_source = '/dev/video0'


def _save_qr_code(qr_code: str, filepath: str = qr_path, filename: str = qr_name) -> str:
    """Use it for save QrCode from web.whatsapp.com (copied as string)
    to PNG file to your path and your filename.

    :param qr_code: QrCode string from web.whatsapp.com.
    :param filepath: Your path for saving file.
    :param filename: Your name for file.

    :return: Absolute path to saved file.
    """

    path = os.path.join(filepath, filename)
    from PIL import Image
    background = Image.new('RGB', (background_width, background_height), color='white')
    img = qrcode.make(qr_code)

    img_w, img_h = img.size
    bg_w, bg_h = background.size

    offset = ((bg_w - img_w) // 2, (bg_h - img_h) // 2)
    background.paste(img, offset)

    background.save(path)
    return path


def _scan_code() -> bool:
    """Use it for open app (WhatsApp) and scan code

    Plan: start app > more options > WhatsApp Web > scan QR code > waiting > stop app
    Bash-script uses.

    :return: Always True when non-critical error.
    """

    Popen(os.path.join(script_path, scancode_script_name), shell=True)

    return True


def _set_image(path_to_img: str, video_source: str = default_video_source):
    """Use it to loop an image on a video source.

    :param path_to_img: Path to your image to loop.
    :param video_source: A necessary video source for looping an image.

    :return: "subprocess.Popen" object with started ffmpeg stream
    """

    ffmpeg = Popen(
        'sudo ffmpeg -loop 1 -i {} -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 {} > /dev/null 2>&1 < /dev/null &'.format(
            path_to_img, video_source
        ), shell=True)

    return ffmpeg


def scan_code(qr_code: str) -> bool:
    """Use it for scan QrCode from web.whatsapp.com (copied as string).

    :param qr_code: String of QR code from web.whatsapp.com.
    It is located in "data-ref" attribute at "_3jid7" class.

    :return:
    """

    new_qr = _save_qr_code(qr_code)
    _set_image(new_qr)
    _scan_code()

    # TODO: Maybe need to fix it. Cause it could be stopping thread. Idk. (2)
    #       Celery could fix that problem
    sleep(45)

    Popen('killall ffmpeg', shell=True)

    return True
