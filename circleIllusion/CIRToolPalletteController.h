//
//  CIRToolPalletteController.h
//  circleIllusion
//
//  Created by David Phillip Oster on 2/22/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class CIRItem;
@class CIRIllusionView;

extern NSString *const ItemChangedNotification;

@interface CIRToolPalletteController : NSWindowController

@property (nonatomic) NSArray<CIRItem *> *model;
@property (nonatomic) CIRItem *item;

+ (CIRToolPalletteController *)sharedToolPaletteController;

- (void)toggleWindow;

@end

NS_ASSUME_NONNULL_END
