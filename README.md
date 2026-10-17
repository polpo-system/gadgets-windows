# gadgets-windows

Gadget documents in X11 windows of their own, for [polpo](https://github.com/polpo-system/polpo):
a panel, a picture or a text opens beside the desktop in a window that looks like the windows of
the other programs. The window manager gives it a title bar and moves it, and its close button
closes it; inside, the document works as in a viewer of the desktop.

```
portia.Install gadgets-windows
```

## Using

    DocWindows.OpenDoc HPCalc.Panel     a panel in a window as large as it
    DocWindows.OpenDoc ^                the selected document

Programs call `DocWindows.Open(D)` for a document `D`; it returns the window (a viewer of
polpo's module `Windows`) or NIL. Windows exist with X11 only (not with sixel graphics in a
terminal), at most 16, each at most as large as the screen. The windows themselves come from
polpo (`Windows`, `Display.OpenWindow`, `Viewers.OpenFree`); `Windows.OpenText` opens a text
without the gadgets.

## What is here

    src/DocWindows.Mod
    tools/DocWindows.Tool
    test/DocWindowsTest.Mod

## Tests

    DocWindowsTest.Run      5 checks: a text document opened in a window of its own, below the
                            screen and filled by the document, then closed; it needs X11

The license is GPL-3 (`LICENSE`).
