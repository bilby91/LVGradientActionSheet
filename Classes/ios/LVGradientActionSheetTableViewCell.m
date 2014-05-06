//
//  LVActionSheetTableViewCell.m
//  LVActionSheet
//
//  Created by Martín Fernández on 2/26/14.
//  Copyright (c) 2014 Martín Fernández. All rights reserved.
//

#import "LVGradientActionSheetTableViewCell.h"

float const kTopPadding    = 19.f;
float const kButtomPadding = 19.f;
float const kLeftPadding   = 26.f;

@implementation LVGradientActionSheetTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier needsTopBorder:(BOOL)needsTopBorder
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    

    if (self) {
        
        self.needsTopBorder = needsTopBorder;
        
        if (needsTopBorder) {
        
            CALayer* border        = [CALayer layer];
            border.frame           = CGRectMake(0, 0, self.frame.size.width, 0.5f);
            border.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:0.30f].CGColor;
            
            [self.layer addSublayer:border];
            
        }
    }
    return self;
}

+ (NSDictionary *)optionAttributes
{
    return @{ NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-Regular" size:20.f], NSForegroundColorAttributeName : [UIColor whiteColor] };
}

#pragma mark - Drawing

- (void)setDarkEnabled:(BOOL)darkEnabled
{
    _darkEnabled = darkEnabled;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{

    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    if (self.darkEnabled) {
        
        CGRect cellFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        CGContextSetFillColorWithColor(currentContext, [UIColor colorWithRed:66/255.f green:75/255.f blue:87/255.f alpha:0.55f].CGColor);
        CGContextFillRect(currentContext,cellFrame);
    }
    
    CGSize textSize = [self.option boundingRectWithSize:self.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:[self.class optionAttributes] context:nil].size;
    CGRect textRect = CGRectMake(kLeftPadding, kTopPadding, textSize.width, textSize.height);
    
    [self.option drawInRect:textRect withAttributes:[self.class optionAttributes]];
    
}
@end
