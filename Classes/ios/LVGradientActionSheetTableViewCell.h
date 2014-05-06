//
//  LVActionSheetTableViewCell.h
//  LVActionSheet
//
//  Created by Martín Fernández on 2/26/14.
//  Copyright (c) 2014 Martín Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

extern float const kTopPadding;
extern float const kButtomPadding;
extern float const kLeftPadding;

@interface LVGradientActionSheetTableViewCell : UITableViewCell

@property (nonatomic, copy  ) NSString *option;
@property (nonatomic, assign) BOOL     needsTopBorder;
@property (nonatomic, assign) BOOL     darkEnabled;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier needsTopBorder:(BOOL)needsTopBorder;
+ (NSDictionary *)optionAttributes;

@end
