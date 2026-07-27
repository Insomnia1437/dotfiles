## TigerVNC server

XFCE is preferred. GNOME and the system X session are used as fallbacks.
The server listens on the Linac network rather than being restricted to
localhost.

### Usage

```shell
vncpasswd
vncserver :19
vncserver -kill :19
```
