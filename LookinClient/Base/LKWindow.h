//
//  LKWindow.h
//  Lookin
//
//  Created by Li Kai on 2019/5/14.
//  https://lookin.work
//

#import <Cocoa/Cocoa.h>

@class LKPanelContentView;

@interface LKWindow : NSWindow

+ (instancetype)panelWindowWithWidth:(CGFloat)width height:(CGFloat)height contentView:(LKPanelContentView *)contentView;

@property(nonatomic, assign) BOOL lookin_tracksPreferredScreen;

+ (NSScreen *)lookin_preferredInitialScreen;
+ (NSRect)lookin_centeredRectWithSize:(NSSize)size onScreen:(NSScreen *)screen;
+ (void)lookin_centerWindow:(NSWindow *)window onScreen:(NSScreen *)screen;
+ (void)lookin_rememberPreferredScreenFromWindow:(NSWindow *)window;

@end
