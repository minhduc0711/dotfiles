# Firefox (on Sway)
## Invisible dialogs
Go to about:config, set `gfx.webrender.all` to true
## Bypass blocked websites (only works with firefox-esr-bin 78.6.0-1):
* Go to about:preferences, search for dns, enable dns over https
* Go to about:config, set `network.security.esni.enabled` to true
* Check status on https://www.cloudflare.com/ssl/encrypted-sni/
## Hardware video acceleration (VA-API)
* Guide: https://wiki.archlinux.org/index.php/Firefox#Hardware_video_acceleration
* Error `DRM_IOCTL_I915_GEM_APERTURE failed`. 
[Solution](https://github.com/intel/media-driver/issues/816):
```
/etc/mkinitcpio.conf
----------------------
MODULES=(... i915 ...)
```
