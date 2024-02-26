//  CIRItem.m
//  circleIllusion
//
//  Created by David Phillip Oster on 2/21/24.
//

#import "CIRItem.h"

/// treat the raw bits of a field as an unsigned. Don't convert floats to ints.
#define HASHCAST(n)  *(NSUInteger *)(&n)

static NSString *const nameKey = @"nam";
static NSString *const revsKey = @"rev";
static NSString *const arrowHueKey = @"aHue";
static NSString *const rimKey = @"rim";
static NSString *const ratioKey = @"ratio";
static NSString *const innerKey = @"inner";
static NSString *const outerKey = @"outer";
static NSString *const isArrowsKey = @"arrow";
static NSString *const isAnimationKey = @"anim";
static NSString *const isGrayKey = @"isGray";
static NSString *const isBothRotateSameKey = @"isBoth";

@implementation CIRItem

- (instancetype)init {
  self = [super init];
  if (self) {
    _name = @"";
  }
  return self;
}

- (NSUInteger)hash {
  return HASHCAST(_revsPerSec) ^ HASHCAST(_deltaArowHue) ^ HASHCAST(_rimDim) ^ HASHCAST(_middleRatio) ^ HASHCAST(_outerOffset) ^ HASHCAST(_innerOffset);
}

- (BOOL)isEqual:(nullable id)object {
  if (self == object) {
    return YES;
  }
  CIRItem *other = (CIRItem *)object;
  return [self class] == [other class] &&
    self.revsPerSec == other.revsPerSec &&
    self.deltaArowHue == other.deltaArowHue &&
    self.rimDim == other.rimDim &&
    self.middleRatio == other.middleRatio &&
    self.outerOffset == other.outerOffset &&
    self.innerOffset  == other.innerOffset &&
    self.isArrows == other.isArrows &&
    self.isGray == other.isGray &&
    self.isBothRotateSame == other.isBothRotateSame;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
  CIRItem *other = [[[self class] allocWithZone:zone] init];
  other.revsPerSec = self.revsPerSec;
  other.deltaArowHue = self.deltaArowHue;
  other.rimDim = self.rimDim;
  other.middleRatio = self.middleRatio;
  other.outerOffset = self.outerOffset;
  other.innerOffset  = self.innerOffset;
  other.isArrows = self.isArrows;
  other.isAnimation = self.isAnimation;
  other.isGray = self.isGray;
  other.isBothRotateSame = self.isBothRotateSame;
  return other;
}

- (void)takeValuesFrom:(CIRItem *)other {
  self.revsPerSec = other.revsPerSec;
  self.deltaArowHue = other.deltaArowHue;
  self.rimDim = other.rimDim;
  self.middleRatio = other.middleRatio;
  self.outerOffset = other.outerOffset;
  self.innerOffset  = other.innerOffset;
  self.isArrows = other.isArrows;
  self.isAnimation = other.isAnimation;
  self.isGray = other.isGray;
  self.isBothRotateSame = other.isBothRotateSame;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.name = dict[nameKey];
    self.revsPerSec = [dict[revsKey] floatValue];
    self.deltaArowHue = [dict[arrowHueKey] floatValue];
    self.rimDim = [dict[rimKey] floatValue];
    self.middleRatio = [dict[ratioKey] floatValue];
    self.innerOffset = [dict[innerKey] floatValue];
    self.outerOffset = [dict[outerKey] floatValue];
    self.isArrows = [dict[isArrowsKey] boolValue];
    self.isAnimation = [dict[isAnimationKey] boolValue];
    self.isGray = [dict[isGrayKey] boolValue];
    self.isBothRotateSame = [dict[isBothRotateSameKey] boolValue];
  }
  return self;
}

- (NSDictionary *)asDict {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  dict[nameKey] = self.name;
  dict[revsKey] = @(self.revsPerSec);
  dict[arrowHueKey] = @(self.deltaArowHue);
  dict[rimKey] = @(self.rimDim);
  dict[ratioKey] = @(self.middleRatio);
  dict[innerKey] = @(self.innerOffset);
  dict[outerKey] = @(self.outerOffset);
  if (self.isArrows) { dict[isArrowsKey] = @YES; }
  if (self.isAnimation) { dict[isAnimationKey] = @YES; }
  if (self.isGray) { dict[isGrayKey] = @YES; }
  if (self.isBothRotateSame) { dict[isBothRotateSameKey] = @YES; }
  return dict;
}

@end

NSArray<CIRItem *> *InitialModel(void){
  NSMutableArray *a = [NSMutableArray array];
  [a addObject:[[CIRItem alloc] initWithDictionary:@{
    nameKey: @"Color repel",
    revsKey: @(0.7),
    arrowHueKey: @(0.01),
    rimKey: @(4),
    ratioKey: @(0.666),
    innerKey: @(-60),
    outerKey: @(60),
    isArrowsKey: @YES,
    isAnimationKey: @YES,
    isGrayKey : @NO
  }]];

  CIRItem *attract = [[a firstObject] copy];
  CGFloat t = attract.innerOffset;
  attract.name = @"Color attract";
  attract.innerOffset = attract.outerOffset;
  attract.outerOffset = t;
  [a addObject:attract];

  [a addObject:[[CIRItem alloc] initWithDictionary:@{
    nameKey: @"Gray attract",
    revsKey: @(0.7),
    arrowHueKey: @(0.01),
    rimKey: @(2),
    ratioKey: @(0.666),
    innerKey: @(60),
    outerKey: @(-60),
    isArrowsKey: @YES,
    isAnimationKey: @YES,
    isGrayKey : @YES
  }]];
  CIRItem *repel = [[a lastObject] copy];
  t = repel.innerOffset;
  repel.name = @"Gray repel";
  repel.innerOffset = repel.outerOffset;
  repel.outerOffset = t;
  [a addObject:repel];
  
  return a;
}
