//
//  Customslider.m
//  ExploringSlider
//
//  Created by Neha Singh on 12/26/16.
//  Copyright © 2016 Neha Singh. All rights reserved.
//

#import "Customslider.h"

const CGSize kminValueImageSize = {15.0, 15.0};
const CGSize kmaxValueImageSize = {20.0, 20.0};
const CGFloat ksliderTrackHeight = 3;

@interface ToolTipPopupView : UIView
@property (nonatomic) float value;
@property (nonatomic, retain) UIFont *fontSize;
@property (nonatomic, retain) NSString *toolTipValue;
@end

@implementation ToolTipPopupView

@synthesize value=_value;
@synthesize fontSize =_fontSize;
@synthesize toolTipValue = _toolTipValue;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.fontSize = [UIFont boldSystemFontOfSize:18];
    }
    return self;
}

- (void)dealloc {
    self.toolTipValue = nil;
    self.fontSize = nil;
}

- (void)drawRect:(CGRect)rect {
    
    // Set the fill color and Create the path for the rectangle
    [[UIColor colorWithRed:236.0f/256.0f green:236.0f/256.0f blue:236.0f/256.0f alpha:1] setFill];
    CGRect roundedRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height * 0.7);
    UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:3.0];
    
    // Create the arrow path
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGPoint midPoint = CGPointMake(midX, CGRectGetMaxY(self.bounds));
    [arrowPath moveToPoint:midPoint];
    [arrowPath addLineToPoint:CGPointMake((midX - 10.0), CGRectGetMaxY(roundedRect))];
    [arrowPath addLineToPoint:CGPointMake((midX + 10.0), CGRectGetMaxY(roundedRect))];
    [arrowPath closePath];
    
    // Attach the arrow path to the rectangle
    [roundedRectPath appendPath:arrowPath];
    [roundedRectPath fill];
    
    // Draw the text if there is a value
    if (self.toolTipValue) {
        [[UIColor darkGrayColor] set];
        CGSize s = [_toolTipValue sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"American Typewriter" size:12], NSFontAttributeName, nil]];
        CGFloat yOffset = (roundedRect.size.height - s.height) / 2;
        CGRect textRect = CGRectMake(roundedRect.origin.x, yOffset, roundedRect.size.width, s.height);
        NSMutableParagraphStyle *theStyle = [NSMutableParagraphStyle new];
        [theStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [theStyle setAlignment:NSTextAlignmentCenter];
        [_toolTipValue drawInRect:textRect withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"American Typewriter" size:12], NSFontAttributeName,theStyle, NSParagraphStyleAttributeName, nil]];
    }
}

- (void)setValue:(float)aValue {
    _value = aValue;
    self.toolTipValue = [NSString stringWithFormat:@"%.1f", _value];
    [self setNeedsDisplay];
}

@end

@implementation Customslider
{
    UIView* tickview;
}
@synthesize showTooltip;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)setShowTooltip:(BOOL)show{
    if (show) {
        [self initToolTip];
    }else{
        [self removeToolTip];
    }
    self->showTooltip = show;
}

-(void)setIsTickType:(BOOL)TickType{
    self->_isTickType = TickType;
    if (TickType) {
        if (tickview!=nil) {
            tickview.hidden = NO;
        }
    }else{
        tickview.hidden = YES;
    }
}

-(CGRect)trackRectForBounds:(CGRect)bounds{
    // set rect for track
    _trackFrame = CGRectMake(kminValueImageSize.width+1 , (self.frame.size.height-ksliderTrackHeight)/2 , self.frame.size.width-(kminValueImageSize.width+kmaxValueImageSize.width+4) , ksliderTrackHeight);
    
    return CGRectMake(kminValueImageSize.width+1,(self.frame.size.height-ksliderTrackHeight)/2 , self.frame.size.width-(kminValueImageSize.width+kmaxValueImageSize.width+4) , ksliderTrackHeight);
}

-(CGRect)minimumValueImageRectForBounds:(CGRect)bounds{
    // set rect for minimumValue image
    return CGRectMake(0 , (self.frame.size.height-kminValueImageSize.height)/2 , kminValueImageSize.width , kminValueImageSize.height);
}

-(CGRect)maximumValueImageRectForBounds:(CGRect)bounds{
    // set rect for maximumValue image
    return CGRectMake( self.frame.size.width-kmaxValueImageSize.width , (self.frame.size.height-kmaxValueImageSize.height)/2 , kmaxValueImageSize.width , kmaxValueImageSize.height );
}

- (CGRect)knobRect {
    CGRect knobRect = [self thumbRectForBounds:self.bounds
                                     trackRect:[self trackRectForBounds:self.bounds]
                                         value:self.value];
    return knobRect;
}
#pragma mark - UIControl touch event tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (showTooltip) {
        // Find the touch point on mousedown
        CGPoint touchPoint = [touch locationInView:self];
        // Check if the touch is within the knob's boundary to show the tooltip-view
        if(CGRectContainsPoint(self.knobRect, touchPoint)) {
            [self updateToolTipView];
            [self animateToolTipFading:YES];
        }
    }
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.showTooltip) {
        // Update the tooltip as slider knob is being moved
        [self updateToolTipView];
    }
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.showTooltip) {
        // Fade out the tooltip view on mouse release event
        [self animateToolTipFading:NO];
        [super endTrackingWithTouch:touch withEvent:event];
    }
    if (self.isTickType) {
        // to make the knob snap to the nearest tick mark.
        float newStep = roundf((self.value) / stepValue);
        self.value = newStep * stepValue;
        [self updateToolTipView];
    }
}

- (void)initToolTip {
    if (toolTip==nil) {
        toolTip = [[ToolTipPopupView alloc] initWithFrame:CGRectZero];
        toolTip.backgroundColor = [UIColor clearColor];
        toolTip.alpha = 0.0;
        [toolTip drawRect:CGRectZero];
    }
    [self addSubview:toolTip];
}

- (void)removeToolTip {
    [toolTip removeFromSuperview];
}
- (void)animateToolTipFading:(BOOL)aFadeIn {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if (aFadeIn) {
        toolTip.alpha = 1.0;
    } else {
        toolTip.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)updateToolTipView {
    CGRect _thumbRect = [self thumbRectForBounds:self.bounds
                                       trackRect:[self trackRectForBounds:self.bounds]
                                           value:self.value];
    CGRect popupRect = CGRectOffset(_thumbRect, 0, -(_thumbRect.size.height));
    toolTip.frame = CGRectInset(popupRect,0,0);
    toolTip.value = self.value;
    toolTip.toolTipValue = [NSString stringWithFormat:@"%.1f",self.value];
}

-(UIView*)addTickMarksView
{
    // set up vars
    stepValue = (self.maximumValue-self.minimumValue)/_noOfTicks;
    float tickwidth = _trackFrame.size.width / _noOfTicks;
    float xPos = self.trackFrame.origin.x;
    // initialize view to return
    tickview = [[UIView alloc]init];
    tickview.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                self.frame.size.width, self.frame.size.height);
    tickview.backgroundColor = [UIColor clearColor];
    // make a UIImageView with tick for each tick in the slider
    for (int i=0; i <= _noOfTicks; i++)
    {
//        if (i==0) {
//            xPos += (tickwidth );
//            continue;
//        }
        UIView *tick = [[UIView alloc] initWithFrame:CGRectMake(xPos,((self.frame.size.height - 10)/2),1, 10)];
        tick.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        tick.layer.shadowColor = [[UIColor whiteColor] CGColor];
        tick.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        tick.layer.shadowOpacity = 1.0f;
        tick.layer.shadowRadius = 0.0f;
        [tickview insertSubview:tick belowSubview:self];
        xPos += (tickwidth );
    }
    return tickview;
}

@end














