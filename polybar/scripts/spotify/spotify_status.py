#!/home/minhduc0711/miniconda3/bin/python

import time
import sys
import dbus
import argparse


parser = argparse.ArgumentParser()
parser.add_argument(
    '-t',
    '--trunclen',
    type=int,
    metavar='trunclen'
)
parser.add_argument(
    '-f',
    '--format',
    type=str,
    metavar='custom format',
    dest='custom_format'
)
args = parser.parse_args()

# Default parameters
output = '{song} - {artist}'
trunclen = 20

# parameters can be overwritten by args
if args.trunclen is not None:
    trunclen = args.trunclen
if args.custom_format is not None:
    output = args.custom_format

try:
    session_bus = dbus.SessionBus()
    spotify_bus = session_bus.get_object(
        'org.mpris.MediaPlayer2.spotify',
        '/org/mpris/MediaPlayer2'
    )

    spotify_properties = dbus.Interface(
        spotify_bus,
        'org.freedesktop.DBus.Properties'
    )

    metadata = spotify_properties.Get('org.mpris.MediaPlayer2.Player', 'Metadata')

    artist = metadata['xesam:artist'][0]
    song = metadata['xesam:title']
    text = output.format(artist=artist, song=song)

    #if len(text) > trunclen:
    #    text = text[0:trunclen]
    #    text += '...' 
    
    # Python3 uses UTF-8 by default. 
    if sys.version_info.major == 3:
        print(text)
    else:
        print(text.encode('UTF-8'))
except Exception as e:
    if isinstance(e, dbus.exceptions.DBusException):
        print('')
    else:
        print(e)
