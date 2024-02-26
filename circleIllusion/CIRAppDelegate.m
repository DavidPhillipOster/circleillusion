//  CIRAppDelegate.m
//  circleIllusion
//
//  Created by David Phillip Oster on 2/19/24.
//

#import "CIRAppDelegate.h"


@interface CIRAppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@end

@implementation CIRAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}


@end
