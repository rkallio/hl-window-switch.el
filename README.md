# Highlight window switch

Highlight point when switching windows

## Demo

<https://youtu.be/nw5_oezUU_0>

## Install

Add this repository to your `load-path` and `M-x hl-window-switch-mode RET`.

## Customization

```
M-x customize-group RET hl-window-switch RET
```

## Issues

If you have the same buffer open in two separate windows, both windows will show
the highlight.  This is due to Emacs overlays being targeted at buffers, not
windows.

## Contributing

Email <roni@kallio.app>, or open an issue/create a pull request on
<https://github.com/rkallio/hl-window-switch.el>.
