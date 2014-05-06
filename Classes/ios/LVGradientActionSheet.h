//
//  LVActionSheet.h
//  LVActionSheet
//
//  Created by Martín Fernández on 2/26/14.
//  Copyright (c) 2014 Martín Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LVGradientActionSheet;

@protocol LVGradientActionSheetDelegate <NSObject>

@required

- (void)actionSheet:(LVGradientActionSheet *)actionSheet clickedButtonWithOption:(NSString *)option;

@optional

- (void)willPresentActionSheet:(LVGradientActionSheet *)actionSheet;  // before animation and showing view
- (void)didPresentActionSheet:(LVGradientActionSheet *)actionSheet;  // after animation

- (void)actionSheet:(LVGradientActionSheet *)actionSheet willDismissWithOption:(NSString *)option; // before animation and hiding view
- (void)actionSheet:(LVGradientActionSheet *)actionSheet didDismissWithWithOption:(NSString *)option;  // after animation

@end

@interface LVGradientActionSheet : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) id<LVGradientActionSheetDelegate> delegate;

@property (nonatomic, copy) NSString *cancelTitle;

- (id)initWithOptions:(NSArray *)options
          cancelTitle:(NSString *)cancelTitle
     topGradientColor:(UIColor *)topColor
  bottomGradientColor:(UIColor *)bottomColor
             delegate:(id<LVGradientActionSheetDelegate>)delegate;

- (void)showInView:(UIView *)superView;

@end
