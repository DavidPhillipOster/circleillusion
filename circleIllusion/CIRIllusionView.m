//  CIRIllusionView.m
//  circleIllusion
//
//  Created by David Phillip Oster on 2/19/24.
// https://www.indiatimes.com/technology/science-and-future/optical-illusion-rainbow-circle-video-539454.html
/*
The circles have an inner and outer edge that is of a different colour to the centre rainbow that’s on the rings. They’re basically thinner slices of the main circles and the colours in them are slightly warmer and colder (depending on the colours).

It’s these coloured outer and inner rings that trick the eye into thinking that it’s the circles that are moving. However, as soon as he covered the outer and inner circles with a static coloured ring, the illusion fell flat and it was no longer in motion.

What makes the Spinning Rainbow Circles illusion work.
https://www.youtube.com/watch?v=dd2Y_ee6zIM

If you picture how a movie works, we see a series of frames with slight differences between each frame.  As we watch, one frame with a person in one position and in the next frame they are in a slightly different position and so on.  Our eye sees each of the individual frames but as it would overload if it had to process all that data, it kind of doesnt bother to.  In fact our brain (being the clever little lump of water and fat that it is) keeps the original image and processes the changes to smooth it all out.  We see it as fluid motion.  In fact our brain goes a step further and actually anticipates the changes to a degree.

In the case of the rotating rainbow rings, as a colour (eg the dark blue) is passing a point on the ring it is trailed behind by a thin edge of the same blue after it has passed, our brain pics up this change,  interprets and smooths it out as if the whole blue section moved slightly in that direction.  Now that shouldnt in etself produce the illusion of motion as much as a flickering but our helpful brain anticipates that that movement is going to continue and so we percieve it to do so.  It does adjust but essentially keeps falling for the same trick over and over and we really percieve that there is movement there.

inner edge ring advanced, outer edge ring retarded?

https://twitter.com/sebjwallace/status/1384773017717420034?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1384773017717420034%7Ctwgr%5E4050615ba71356c85fe7621a02712abf727443c8%7Ctwcon%5Es1_&ref_url=https%3A%2F%2Fwww.indiatimes.com%2Ftechnology%2Fscience-and-future%2Foptical-illusion-rainbow-circle-video-539454.html has it in black and white.


 */

#import "CIRIllusionView.h"

#import "CIRItem.h"
#import "CIRToolPalletteController.h"

static CGFloat sat = 0.8;

// Given a value in the range 0..1, return a new, scaled, one in the range 0.2..0.95
static CGFloat Trimmed(CGFloat n){
  n = sin(2*M_PI * n);
  return 0.4 + n*(0.95 - 0.4);
}

// The color illusion works better with this trim function for brightness.
static CGFloat Crimmed(CGFloat n){
  n = sin(2*M_PI * n);
  return 0.5 + n*(0.99 - 0.5);
}


// Given a rect, return a new rect that is a square centered in it.
static CGRect OuterCircleFrame(CGRect r){
  CGPoint center = CGPointMake(r.origin.x + r.size.width/2, r.origin.y + r.size.height/2);
  CGFloat dim = MIN(r.size.width, r.size.height);
  return CGRectMake(center.x - dim/2, center.y - dim/2, dim, dim);
}

@interface NSBezierPath (IllusionView)
+ (instancetype)arrowHead;

// create a "donut" path inside rect.
- (void)appendDonut:(CGRect)r;

- (void)appendDonut:(CGRect)r holeDia:(CGFloat)dia;

- (void)draw:(CGFloat)degrees radialHues:(NSImage *)radialHues;
@end

@implementation NSBezierPath (IllusionView)
- (void)appendDonut:(CGRect)r {
  [self appendDonut:r holeDia:r.size.width*0.36];
}

- (void)appendDonut:(CGRect)r holeDia:(CGFloat)dia {
  [self appendBezierPathWithOvalInRect:r];
  CGRect center = CGRectMake(r.origin.x + r.size.width/2, r.origin.y + r.size.height/2, 0, 0);
  NSBezierPath *hole = [[NSBezierPath bezierPathWithOvalInRect:CGRectInset(center, -dia/2, -dia/2)] bezierPathByReversingPath];
  [self appendBezierPath:hole];
}

+ (instancetype)arrowHead {
  NSBezierPath *result = [NSBezierPath bezierPath];
  [result moveToPoint:CGPointMake(-4, 3)];
  [result lineToPoint:CGPointMake(10, 3)];
  [result lineToPoint:CGPointMake(10, 7.5)];
  [result lineToPoint:CGPointMake(17.5, 0)];
  [result lineToPoint:CGPointMake(10, -7.5)];
  [result lineToPoint:CGPointMake(10, -3)];
  [result lineToPoint:CGPointMake(-4, -3)];
  [result closePath];
  return result;
}

// draw, filling self with radialHues, centered on the bezier, rotate by degrees
- (void)draw:(CGFloat)degrees radialHues:(NSImage *)radialHues {
  NSGraphicsContext *gc = [NSGraphicsContext currentContext];
  [gc saveGraphicsState];
  CGRect r = [self bounds];
  CGRect radialRect = CGRectInset(CGRectInset(r, r.size.width/2, r.size.height/2), - radialHues.size.width/2, -radialHues.size.height/2);
  [self addClip];

  NSAffineTransform *t = [NSAffineTransform transform];
  [t translateXBy:radialRect.origin.x + radialRect.size.width/2 yBy:radialRect.origin.y + radialRect.size.height/2];
  [t rotateByDegrees:degrees];
  [t translateXBy:-(radialRect.origin.x + radialRect.size.width/2) yBy:-(radialRect.origin.y + radialRect.size.height/2)];
  [t concat];

  [radialHues drawInRect:radialRect];
  [gc restoreGraphicsState];
}
@end

// returns a new image that is a cycle of hues.
static NSImage *RadialHues(CGFloat radius, BOOL isGray){
  radius *= 2;
  NSImage *image = [[NSImage alloc] initWithSize:CGSizeMake(radius*2, radius*2)];
  const int numDivisions = 100;
  CGFloat theta = 360./numDivisions * M_PI/180.0;
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:CGPointZero];
  [path lineToPoint:CGPointMake(radius, 0)];
  [path lineToPoint:CGPointMake(radius * cos(theta), radius * sin(theta))];
  [path closePath];
  [image lockFocus];
  [NSColor.blueColor set];
  NSAffineTransform *t = [NSAffineTransform transform];
  [t translateXBy:radius yBy:radius];
  [t concat];
  NSColor *start = isGray? [NSColor colorWithDeviceHue:0 saturation:0 brightness:Trimmed(0) alpha:1] :
    [NSColor colorWithDeviceHue:0 saturation:sat brightness:Crimmed(1.0/numDivisions) alpha:1];
  NSColor *end =  isGray? [NSColor colorWithDeviceHue:0 saturation:0 brightness:Trimmed(1.0/numDivisions) alpha:1] :
    [NSColor colorWithDeviceHue:1.0/numDivisions saturation:sat brightness:Crimmed(1.0/numDivisions) alpha:1];
  for (int i = 0; i < numDivisions; ++i) {
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:start endingColor:end];
    start = end;
    end = isGray? [NSColor colorWithDeviceHue:0 saturation:0 brightness:Trimmed((i+1)*1.0/numDivisions) alpha:1] :
      [NSColor colorWithDeviceHue:(i+1)*1.0/numDivisions saturation:sat brightness:Crimmed((i+1)*1.0/numDivisions) alpha:1];
    [gradient drawInBezierPath:path angle:90];
    NSAffineTransform *t = [NSAffineTransform transform];
    [t rotateByDegrees:360.0/numDivisions];
    [t concat];
  }
  t = [NSAffineTransform transform];
  [t translateXBy:-radius yBy:-radius];
  [t concat];
  [image unlockFocus];
  NSImage *result = [[NSImage alloc] initWithSize:CGSizeMake(image.size.width/2, image.size.height/2)];
  [result lockFocus];
  [image drawInRect:CGRectMake(0, 0, image.size.width/2, image.size.width/2)];
  [result unlockFocus];
  return result;
}

/// represent a "circle" - a hollow filled circle, i.e., a donut, with an inner rim and an outer rim, where the coloring of the rims is advanced or retarded by a number of degrees
@interface Donut : NSObject
@property  NSBezierPath *outer;
@property  NSBezierPath *middle;
@property  NSBezierPath *inner;
@property CGFloat outerOffset;
@property CGFloat innerOffset;

/// draw, filling self with radialHues, centered on the bezier, rotate by degrees, with inner and outer rotation offset appropriately
- (void)draw:(CGFloat)degrees radialHues:(NSImage *)radialHues;

@end

@implementation Donut
- (instancetype)initWithRect:(CGRect)r  item:(CIRItem *)item {
  self = [super init];
  if (self) {
    CGFloat rimDim = item.rimDim;
    CGFloat middleRatio = item.middleRatio;
    _outerOffset = item.outerOffset;
    _innerOffset = item.innerOffset;
    _outer = [NSBezierPath bezierPath];
    [_outer appendDonut:r holeDia:r.size.width - 2*rimDim];
    _middle = [NSBezierPath bezierPath];
    CGRect middleR = CGRectInset(r, rimDim, rimDim);
    [_middle appendDonut:middleR holeDia:r.size.width*middleRatio];
    CGRect innerR = CGRectInset(CGRectInset(middleR, middleR.size.width/2,  middleR.size.height/2), -r.size.width*middleRatio/2, -r.size.width*middleRatio/2);
    _inner = [NSBezierPath bezierPath];
    [_inner appendDonut:innerR holeDia:innerR.size.width - 2*rimDim];
  }
  return self;
}

- (void)draw:(CGFloat)degrees radialHues:(NSImage *)radialHues {
  [_outer draw:degrees + _outerOffset radialHues:radialHues];
  [_middle draw:degrees radialHues:radialHues];
  [_inner draw:degrees + _innerOffset radialHues:radialHues];
}

- (CGRect)bounds {
  return _middle.bounds;
}
@end

@interface CIRIllusionView () <NSMenuItemValidation>
@property  CGRect xbounds;
@property  Donut *leftP;
@property  Donut *rightP;

@property  NSBezierPath *leftArrow;
@property  NSBezierPath *rightArrow;

@property  NSImage *radialHues;

@property  CGFloat degrees;
@property  CGFloat arrowHue;
@property  CGFloat arrowRotationDegrees;
@property  NSTimer *timer;

@property(nonatomic)  NSNumber* revolutionsPerSecond;

@property(nonatomic) NSArray<CIRItem *> *model;
@property(nonatomic) CIRItem *item;
@end

@implementation CIRIllusionView

static int margin = 10;

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self initIllusionView];
  }
  return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self) {
    [self initIllusionView];
  }
  return self;
}

- (void)initIllusionView {
  if (nil == self.item) {
    if (nil == self.model) {
      self.model = InitialModel();
    }
    _item = [[self.model firstObject] copy];
    [_item addObserver:self forKeyPath:@"isGray" options:0 context:(void *)&self];
    [_item addObserver:self forKeyPath:@"middleRatio" options:0 context:(void *)&self];
    [_item addObserver:self forKeyPath:@"rimDim" options:0 context:(void *)&self];
    [_item addObserver:self forKeyPath:@"innerOffset" options:0 context:(void *)&self];
    [_item addObserver:self forKeyPath:@"outerOffset" options:0 context:(void *)&self];
  }
  NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
  [nc addObserver:self selector:@selector(itemChanged:) name:ItemChangedNotification object:nil];
  [self reinitIllusionView];
}

- (void)reinitIllusionView {
  CGRect bounds = [self bounds];
  _xbounds = bounds;
  bounds = CGRectInset(bounds, margin, margin);
  CGRect left, right;
  CGRectDivide(bounds, &left, &right, bounds.size.width/2, CGRectMinXEdge);
  left = CGRectInset(left, 2*margin, 0);
  right = CGRectInset(right, 2*margin, 0);
  left = OuterCircleFrame(left);
  right = OuterCircleFrame(right);

  _leftP = [[Donut alloc] initWithRect:left item:self.item];

  _rightP = [[Donut alloc] initWithRect:right item:self.item];
  CGFloat off = _rightP.innerOffset;
  _rightP.innerOffset = _rightP.outerOffset;
  _rightP.outerOffset = off;

  _radialHues = RadialHues(left.size.width * 0.6, self.item.isGray);
  _leftArrow = [NSBezierPath arrowHead];
  _rightArrow = [NSBezierPath arrowHead];
  [_timer invalidate];
  _timer = [NSTimer timerWithTimeInterval:1/60. target:self selector:@selector(doTimer:) userInfo:nil repeats:YES];
  [NSRunLoop.currentRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
  [_item removeObserver:self forKeyPath:@"isGray" context:(void *)&self];
  [_item removeObserver:self forKeyPath:@"rimDim" context:(void *)&self];
  [_item removeObserver:self forKeyPath:@"middleRatio" context:(void *)&self];
  [_item removeObserver:self forKeyPath:@"innerOffset" context:(void *)&self];
  [_item removeObserver:self forKeyPath:@"outerOffset" context:(void *)&self];
}

- (void)itemChanged:(NSNotification *)notification {
  self.item = notification.object;
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)doTimer:(NSTimer *)timer {
  if (self.item.isAnimation) {
    [self setNeedsDisplay:YES];
    // fields here control the rate of change.
    _degrees = fmod(_degrees + self.item.revsPerSec*6., 360);
    _arrowHue = fmod(_arrowHue + self.item.deltaArowHue, 1.);

    if ((0 < self.item.revsPerSec) == (0 < self.item.innerOffset)) {
      if (0 < _arrowRotationDegrees) {
        _arrowRotationDegrees = MAX(0, _arrowRotationDegrees - 10);
      }
    } else if (_arrowRotationDegrees < 180) {
        _arrowRotationDegrees = MIN(180, _arrowRotationDegrees + 10);
    }
  }
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  CGRect bounds = [self bounds];
  if (!CGRectEqualToRect(bounds, _xbounds)) {
    [self reinitIllusionView];
  }
  [NSColor.grayColor set];
  NSRectFill(bounds);

  [_leftP draw:_degrees radialHues:_radialHues];
  if (self.item.isBothRotateSame) {
    [_rightP draw:_degrees radialHues:_radialHues];
  } else {
    [_rightP draw:-_degrees radialHues:_radialHues];
  }

  if (self.item.isArrows) {
    NSGraphicsContext *gc = [NSGraphicsContext currentContext];
    [gc saveGraphicsState];
    NSAffineTransform *t = [NSAffineTransform transform];
    NSColor *arrowColor = self.item.isGray ? [NSColor colorWithHue:0 saturation:0 brightness:Trimmed(_arrowHue) alpha:1] :
      [NSColor colorWithHue:_arrowHue saturation:sat brightness:Crimmed(_arrowHue) alpha:1];
    CGRect right = [_rightP bounds];
    CGRect radialRect = CGRectInset(CGRectInset(right, right.size.width/2, right.size.height/2), -_radialHues.size.width/2, -_radialHues.size.height/2);
    [t translateXBy:radialRect.origin.x + radialRect.size.width/2 yBy:radialRect.origin.y + radialRect.size.height/2];
    [t rotateByDegrees:_arrowRotationDegrees];
    [t scaleXBy:-2 yBy:2];
    [t concat];
    [arrowColor set];
    [_rightArrow fill];
    [gc restoreGraphicsState];

    [gc saveGraphicsState];
    t = [NSAffineTransform transform];
    CGRect left = [_leftP bounds];
    radialRect = CGRectInset(CGRectInset(left, left.size.width/2, left.size.height/2), -_radialHues.size.width/2, -_radialHues.size.height/2);
    [t translateXBy:radialRect.origin.x + radialRect.size.width/2 yBy:radialRect.origin.y + radialRect.size.height/2];
    [t rotateByDegrees:_arrowRotationDegrees];
    [t scaleXBy:2 yBy:2];
    [t concat];
    [arrowColor set];
    [_leftArrow fill];
    [gc restoreGraphicsState];
  }
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  [self.window makeFirstResponder:self];
}

- (void)setModel:(NSArray<CIRItem *> *)model {
  _model = model;
}

- (void)setItem:(CIRItem *)item {
  if (![_item isEqual:item]) {
    [_item takeValuesFrom:item];
//    [self reinitIllusionView];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqual:@"rimDim"] || [keyPath isEqual:@"middleRatio"] || [keyPath isEqual:@"isGray"]) {
    [self reinitIllusionView];
    [self setNeedsDisplay:YES];
  } else if ([keyPath isEqual:@"innerOffset"]) {
    self.leftP.innerOffset = self.item.innerOffset;
    self.rightP.innerOffset = self.item.innerOffset;
    [self setNeedsDisplay:YES];
  } else if ([keyPath isEqual:@"outerOffset"]) {
    self.leftP.outerOffset = self.item.outerOffset;
    self.rightP.outerOffset = self.item.outerOffset;
    [self setNeedsDisplay:YES];
  }
}

/// set checkmarks to denote "on" state.
- (BOOL)validateMenuItem:(NSMenuItem *)item {
  if (@selector(toggleArrows:) == item.action) {
    item.state = self.item.isArrows;
  } else if (@selector(toggleAnimation:) == item.action) {
    item.state = self.item.isAnimation;
  } else if (@selector(toggleColor:) == item.action) {
    item.state = !self.item.isGray;
  } else if (@selector(toggleTools:) == item.action) {
    CIRToolPalletteController *tools = CIRToolPalletteController.sharedToolPaletteController;
    item.state = tools.window.isVisible;
  } else {
    return NO;
  }
  return YES;
}

- (IBAction)toggleArrows:(id)sender {
  self.item.isArrows = ! self.item.isArrows;
  [self setNeedsDisplay:YES];
}

- (IBAction)toggleAnimation:(id)sender {
  self.item.isAnimation = ! self.item.isAnimation;
}

- (IBAction)toggleColor:(id)sender {
  self.item.isGray = ! self.item.isGray;
  [self reinitIllusionView];
  [self setNeedsDisplay:YES];
}

- (IBAction)toggleTools:(id)sender {
  CIRToolPalletteController *tools = CIRToolPalletteController.sharedToolPaletteController;
  tools.item = self.item;
  tools.model = self.model;
  [tools toggleWindow];
}



@end
