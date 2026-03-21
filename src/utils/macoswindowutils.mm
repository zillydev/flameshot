// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2017-2019 Alejandro Sirgo Rica & Contributors

#include "macoswindowutils.h"

#import <AppKit/AppKit.h>
#include <QWidget>

void setWindowAboveMenuBar(QWidget* widget)
{
    if (!widget || !widget->windowHandle()) {
        return;
    }

    NSView* nsView = reinterpret_cast<NSView*>(widget->winId());
    if (!nsView) {
        return;
    }

    NSWindow* nsWindow = [nsView window];
    if (!nsWindow) {
        return;
    }

    // Place one level above the menu bar (level 24)
    [nsWindow setLevel:kCGMainMenuWindowLevel + 1];

    // Qt::Tool creates an NSPanel, which hides when the app deactivates
    // (e.g., clicking at the top of screen activates the menu bar).
    // Prevent this auto-hiding behavior.
    if ([nsWindow isKindOfClass:[NSPanel class]]) {
        [(NSPanel*)nsWindow setHidesOnDeactivate:NO];
    }

    // Ensure the window can receive mouse events at all screen edges
    [nsWindow setIgnoresMouseEvents:NO];
    [nsWindow setAcceptsMouseMovedEvents:YES];

    // Remove resizable style mask to prevent resize handles at edges
    NSUInteger styleMask = [nsWindow styleMask];
    styleMask &= ~NSWindowStyleMaskResizable;
    [nsWindow setStyleMask:styleMask];
}

static NSRunningApplication* s_previousApp = nil;

void savePreviousActiveApp()
{
    if (s_previousApp) {
        [s_previousApp release];
        s_previousApp = nil;
    }
    NSRunningApplication* active =
      [[NSWorkspace sharedWorkspace] frontmostApplication];
    if (active && ![active isEqual:[NSRunningApplication currentApplication]]) {
        s_previousApp = [active retain];
    }
}

void restorePreviousActiveApp()
{
    if (s_previousApp) {
        [s_previousApp activateWithOptions:NSApplicationActivateIgnoringOtherApps];
        [s_previousApp release];
        s_previousApp = nil;
    }
}
