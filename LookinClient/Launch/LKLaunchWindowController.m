//
//  LKLaunchWindowController.m
//  Lookin
//
//  Created by Li Kai on 2018/11/3.
//  https://lookin.work
//

#import "LKLaunchWindowController.h"
#import "LKLaunchViewController.h"
#import "LKWindow.h"

@interface LKLaunchWindowController ()

@end

@implementation LKLaunchWindowController

- (instancetype)init {
    NSScreen *screen = [LKWindow lookin_preferredInitialScreen];
    LKWindow *window = [[LKWindow alloc] initWithContentRect:[LKWindow lookin_centeredRectWithSize:NSMakeSize(252, 400) onScreen:screen] styleMask:NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskFullSizeContentView backing:NSBackingStoreBuffered defer:YES];
    window.lookin_tracksPreferredScreen = YES;
    window.backgroundColor = [NSColor clearColor];
    window.titlebarAppearsTransparent = YES;
    window.movableByWindowBackground = YES;

    if (self = [self initWithWindow:window]) {
        _launchViewController = [[LKLaunchViewController alloc] initWithWindow:window];
        window.contentView = self.launchViewController.view;
        self.contentViewController = self.launchViewController;
    }
    return self;
}

@end
