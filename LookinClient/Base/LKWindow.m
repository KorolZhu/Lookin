//
//  LKWindow.m
//  Lookin
//
//  Created by Li Kai on 2019/5/14.
//  https://lookin.work
//

#import "LKWindow.h"
#import "LKNavigationManager.h"
#import "LKPanelContentView.h"

static NSString * const LKPreferredWindowScreenNumberKey = @"LKPreferredWindowScreenNumber";

@implementation LKWindow

+ (instancetype)panelWindowWithWidth:(CGFloat)width height:(CGFloat)height contentView:(LKPanelContentView *)contentView {
    LKWindow *window = [[LKWindow alloc] initWithContentRect:NSMakeRect(0, 0, width, height) styleMask:NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:YES];
    window.contentView = contentView;
    return window;
}

+ (NSScreen *)lookin_preferredInitialScreen {
    NSNumber *storedScreenNumber = [[NSUserDefaults standardUserDefaults] objectForKey:LKPreferredWindowScreenNumberKey];
    if (storedScreenNumber) {
        for (NSScreen *screen in NSScreen.screens) {
            NSNumber *screenNumber = screen.deviceDescription[@"NSScreenNumber"];
            if ([screenNumber isEqualToNumber:storedScreenNumber]) {
                return screen;
            }
        }
    }

    NSScreen *screen = NSApp.keyWindow.screen ?: NSApp.mainWindow.screen;
    if (screen) {
        return screen;
    }

    NSPoint mouseLocation = [NSEvent mouseLocation];
    for (NSScreen *candidateScreen in NSScreen.screens) {
        if (NSPointInRect(mouseLocation, candidateScreen.frame)) {
            screen = candidateScreen;
            break;
        }
    }
    return screen ?: NSScreen.mainScreen ?: NSScreen.screens.firstObject;
}

+ (NSRect)lookin_centeredRectWithSize:(NSSize)size onScreen:(NSScreen *)screen {
    screen = screen ?: [self lookin_preferredInitialScreen];
    NSRect visibleFrame = screen.visibleFrame;
    size.width = MIN(size.width, visibleFrame.size.width);
    size.height = MIN(size.height, visibleFrame.size.height);

    return NSMakeRect(NSMidX(visibleFrame) - size.width / 2.0,
                      NSMidY(visibleFrame) - size.height / 2.0,
                      size.width,
                      size.height);
}

+ (void)lookin_centerWindow:(NSWindow *)window onScreen:(NSScreen *)screen {
    if (!window) {
        return;
    }
    [window setFrame:[self lookin_centeredRectWithSize:window.frame.size onScreen:screen] display:NO];
}

+ (void)lookin_rememberPreferredScreenFromWindow:(NSWindow *)window {
    NSNumber *screenNumber = window.screen.deviceDescription[@"NSScreenNumber"];
    if (!screenNumber) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:screenNumber forKey:LKPreferredWindowScreenNumberKey];
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    if (self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag]) {
         [self registerForDraggedTypes:@[NSPasteboardTypeFileURL]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_lookin_handleWindowWillClose:) name:NSWindowWillCloseNotification object:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_lookin_handleWindowWillClose:(NSNotification *)notification {
    if (!self.lookin_tracksPreferredScreen) {
        return;
    }
    [LKWindow lookin_rememberPreferredScreenFromWindow:self];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSString *path = [NSURL URLFromPasteboard:[sender draggingPasteboard]].path;
    NSError *error;
    BOOL isSucc = [[LKNavigationManager sharedInstance] showReaderWithFilePath:path error:&error];
    if (!isSucc) {
        if (error) {
            AlertError(error, self);
        }
    }
    return isSucc;
}

@end
