//  CIRItem.h
//  circleIllusion
//
//  Created by David Phillip Oster on 2/21/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// The "Model" of this app.
@interface CIRItem : NSObject <NSCopying>

/// for displaying in UI. Not considered for equality testing.
@property NSString *name;

/// revolutions per second of the main rotation
@property CGFloat revsPerSec;

/// each animation frame, bump the arrow colors by this amount. When in gray, it is the saturation.
@property CGFloat deltaArowHue;

/// width, in pixels, of the inner rim. width, in pixels, of the outer rim.
@property CGFloat rimDim;

/// size of the donut hole in proportion to the total size of the circle.
@property CGFloat middleRatio;

/// number of degrees the outer rim differs from the main circle.
@property CGFloat outerOffset;

/// number of degrees the inner rim differs from the main circle.
@property CGFloat innerOffset;

/// show the arrows?
@property BOOL isArrows;

/// run the animation timer?
@property BOOL isAnimation;

/// Use shades of gray, instead of color?
@property BOOL isGray;

/// Spin both circles in the same dirction?
@property BOOL isBothRotateSame;

- (void)takeValuesFrom:(CIRItem *)other;

@end

NSArray<CIRItem *> *InitialModel(void);

NS_ASSUME_NONNULL_END
