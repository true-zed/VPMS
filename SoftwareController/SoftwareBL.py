# Software Business Logic

from time import sleep
import qrcode
from subprocess import Popen
from VPMS.settings import BASE_DIR


# Example QrCode from web.whatsapp.com
example_qr = '1@eZI3bgNAvXyktg0zETgBoYKV0lRWSkOkFORLIdFZzCHVXlFLdPI6ZPREOtMnsHpwRMj6+xoFk7bJQQ==,' \
             'Amig/QvtgrkmJe6CsyHkridF5Qr3Lay6DzEmEx0SaFE=,YckRhP9b6+7nsrEpLsCJAg== '


# Constant for filepath and filename
script_path = '{}/SoftwareController/Scripts/'.format(BASE_DIR)
qr_path = '{}/SoftwareController/QrCodes/'.format(BASE_DIR)
qr_name = 'qrcode'

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

    path = '{}{}.png'.format(filepath, filename)

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

    Popen('{}{}'.format(script_path, 'open_wab_web.sh'), shell=True)

    return True


def _set_image(path_to_img: str, video_source: str = default_video_source):
    """Use it to loop an image on a video source.

    :param path_to_img: Path to your image to loop.
    :param video_source: A necessary video source for looping an image.

    :return: "subprocess.Popen" object with started ffmpeg stream
    """

    # TODO: Could be use official library for it.
    ffmpeg = Popen(
        'sudo ffmpeg -loop 1 -i {} -vf scale=800:600 -f v4l2 -vcodec rawvideo -pix_fmt yuyv422 {} '
        '> /dev/null 2>&1 < /dev/null &'.format(
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
    sleep(45)
    Popen('killall ffmpeg', shell=True)

    return True


if __name__ == '__main__':
    # Use it for test
    scan_code(example_qr)
