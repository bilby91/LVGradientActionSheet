//
//  LVGradientView.m
//  LVActionSheet
//
//  Created by Martín Fernández on 2/27/14.
//  Copyright (c) 2014 Martín Fernández. All rights reserved.
//

#import "LVGradientView.h"

@implementation LVGradientView

- (id)init
{
    self = [super init];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
//    self.startBGColor = [UIColor colorWithRed:108.f/255.f green:118.f/255.f blue:244.f/255.f alpha:1.0f];
//    self.endBGColor = [UIColor colorWithRed:22.f/255.f green:224.f/255.f blue:117.f/255.f alpha:0.f];
    self.opaque = NO;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    
    size_t num_locations          = 2;
    CGFloat locations[2]          = { 0.1, 1.0 };

    NSArray* startColorComponents = _startBGColor ? [self getComponentsFromColor:_startBGColor] : @[@(1.0f), @(0.0f), @(0.0f), @(1.0f)];
    NSArray* endColorComponents   = _endBGColor ? [self getComponentsFromColor:_endBGColor] : @[@(0.0f), @(1.0f), @(0.0f), @(1.0f)];
    
    CGFloat components[8] = { ((NSNumber*)startColorComponents[0]).floatValue,
                              ((NSNumber*)startColorComponents[1]).floatValue,
                              ((NSNumber*)startColorComponents[2]).floatValue,
                              ((NSNumber*)startColorComponents[3]).floatValue,  // Start color
                              ((NSNumber*)endColorComponents[0]).floatValue,
                              ((NSNumber*)endColorComponents[1]).floatValue,
                              ((NSNumber*)endColorComponents[2]).floatValue,
                              ((NSNumber*)endColorComponents[3]).floatValue}; // End color
    
    rgbColorspace        = CGColorSpaceCreateDeviceRGB();
    glossGradient        = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);

    CGRect currentBounds = rect;
    CGPoint topCenter    = CGPointMake(CGRectGetMidX(currentBounds), 0.f);
    CGPoint midCenter    = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
    
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
}

-(NSArray*)getComponentsFromColor:(UIColor*)color
{
    CGFloat r, g, b, a;
    [color getRed: &r green:&g blue:&b alpha:&a];
    
    return @[@(r),@(g),@(b),@(a)];
}


@end
