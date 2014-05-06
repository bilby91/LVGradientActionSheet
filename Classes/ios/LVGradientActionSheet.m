//
//  LVActionSheet.m
//  LVActionSheet
//
//  Created by Martín Fernández on 2/26/14.
//  Copyright (c) 2014 Martín Fernández. All rights reserved.
//

#import "LVGradientActionSheet.h"
#import "LVGradientActionSheetTableViewCell.h"
#import "LVGradientView.h"

NSString * const kLVActionSheetTableViewCellIdentifier = @"com.bilby91.kLVGradientActionSheetTableViewCellIdentifier";
float const kAnimationDuration = 20/60.f;

@interface LVGradientActionSheet()
{
    float _lastContentOffsetYDragBegin;
    float _tableViewHeight;
}


@property (nonatomic, strong) UIView           *parentView;
@property (nonatomic, assign) CGPoint          parentCenter;
@property (nonatomic, strong) UIView           *fullScreenView;
@property (nonatomic, strong) UIView           *backgroundView;
@property (nonatomic, strong) LVGradientView   *gradientView;
@property (nonatomic, strong) UIView           *solidView;


@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) NSMutableArray   *options;

@property (nonatomic, strong) UIColor          *startBGColor;
@property (nonatomic, strong) UIColor          *endBGColor;


@property (nonatomic, assign) UIStatusBarStyle appStatusBarStyle;

@end

@implementation LVGradientActionSheet

- (id)initWithOptions:(NSArray *)options
          cancelTitle:(NSString *)cancelTitle
     topGradientColor:(UIColor *)topColor
  bottomGradientColor:(UIColor *)bottomColor
             delegate:(id<LVGradientActionSheetDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        
        self.options     = [options mutableCopy];
        self.delegate    = delegate;
        self.startBGColor = topColor;
        self.endBGColor = bottomColor;
        self.cancelTitle = cancelTitle;
        
        [self.options insertObject:self.cancelTitle atIndex:self.options.count];
    }
    
    return self;
        
}

- (void)showInView:(UIView *)superView
{
    CGRect fullScreenFrame              = [[UIScreen mainScreen] bounds];

    self.parentView                     = superView;
    self.appStatusBarStyle              = [UIApplication sharedApplication].statusBarStyle;
    self.parentCenter                   = superView.center;

    self.frame                          = fullScreenFrame;
    float screenWidth                   = fullScreenFrame.size.width;

    _tableViewHeight                    = ceilf((self.options.count) * [self calculateTableViewCellHeigh]);
    CGRect tableViewFrame               = CGRectMake(0, fullScreenFrame.size.height + _tableViewHeight - 100 , screenWidth, _tableViewHeight);

    self.tableView                      = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.dataSource           = self;
    self.tableView.delegate             = self;
    self.tableView.separatorStyle       = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled        = YES;
    self.tableView.backgroundColor      = [UIColor clearColor];
    self.tableView.clipsToBounds        = NO;

    self.backgroundView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
    self.solidView                      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _tableViewHeight * 2)];
    self.solidView.clipsToBounds        = NO;

    self.gradientView                   = [[LVGradientView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _tableViewHeight * 2)];
    self.gradientView.clipsToBounds     = NO;
    self.gradientView.startBGColor      = self.startBGColor;
    self.gradientView.endBGColor        = self.endBGColor;

    self.solidView.backgroundColor      = [UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1.0f];
    self.backgroundView.backgroundColor = [UIColor redColor];
    self.backgroundView.alpha           = 0.9f;
    self.backgroundView.clipsToBounds   = NO;
    
    [self.backgroundView addSubview:self.solidView];
    [self.backgroundView addSubview:self.gradientView];
    

    [self.tableView insertSubview:self.backgroundView atIndex:0];
    [self addSubview:self.tableView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    
    [self setupGestureRecognizer];
    
    if ([self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
        [self.delegate willPresentActionSheet:self];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [UIView animateWithDuration:kAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{

        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor colorWithRed:10/255.f green:10/255.f blue:12/255.f alpha:1.0f];
        
        self.tableView.frame              = CGRectMake(0,  1, screenWidth, superView.frame.size.height);
        self.tableView.contentInset       = UIEdgeInsetsMake(ceilf(fullScreenFrame.size.height - _tableViewHeight) + 1, 0, 0, 0);

        self.backgroundColor              = [UIColor clearColor];
        self.parentView.alpha             = 0.3f;
        
        float scaleFactor                 = 0.06f;
        
        self.parentView.center            = CGPointMake(self.parentView.center.x, self.parentView.frame.size.height * (0.5f - (scaleFactor/2.f)));
        self.parentView.layer.transform   = CATransform3DConcat(CATransform3DMakeScale(1 - scaleFactor, 1 - scaleFactor,1.f),
                                                                CATransform3DMakeTranslation(0, self.parentView.frame.size.width * (scaleFactor/2.f),0));

    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
            [self.delegate didPresentActionSheet:self];
        }
    }];
}

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.numberOfTapsRequired    = 1;
    
    [self addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
    CGPoint location         = [recognizer locationInView:self];
    CGPoint tablePoint       = [self.tableView convertPoint:location fromView:self];
    NSString *selectedOption = location.y <= self.tableView.frame.origin.y ? self.cancelTitle : self.options[[self.tableView indexPathForRowAtPoint:tablePoint].row];
    
    [self dismissWithSelectedOption:selectedOption];
}

- (void)dismissWithSelectedOption:(NSString *)selectedOption
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:willDismissWithOption:)]) {
        [self.delegate actionSheet:self willDismissWithOption:selectedOption];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.appStatusBarStyle animated:YES];
    
    [UIView animateWithDuration:kAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.tableView.frame      = CGRectMake(0, self.frame.size.height,
                                               self.tableView.frame.size.width,
                                               self.tableView.frame.size.height);

        self.backgroundColor      = [UIColor colorWithWhite:0 alpha:0];
        self.parentView.transform = CGAffineTransformIdentity;
        self.parentView.alpha     = 1.f;
        self.parentView.center    = self.parentCenter;
        
        
    } completion:^(BOOL isCompleted){
        
        if ([self.delegate respondsToSelector:@selector(actionSheet:didDismissWithWithOption:)]) {
            [self.delegate actionSheet:self didDismissWithWithOption:selectedOption];
        }
        [self removeFromSuperview];
    }];

}

#pragma mark - UITableViewDataSource Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LVGradientActionSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLVActionSheetTableViewCellIdentifier];
    
    if (!cell)
        cell = [[LVGradientActionSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:kLVActionSheetTableViewCellIdentifier
                                                          needsTopBorder:!(indexPath.row == 0 || indexPath.row == self.options.count)];
                

    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDelegate Implementation

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self calculateTableViewCellHeigh];
}


#pragma mark - UITableViewDelegate Implementation

-(float)progressWithSource:(float)source startingWith:(float)start ammount:(float)ammount
{
    return (source<=start && source>= start-ammount)? 1.0f - fabs((source-start)/ammount) : (source<=start)? 0.0f: 1.0f;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)aScrollView
{
    _lastContentOffsetYDragBegin = aScrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float scrollY  = scrollView.contentOffset.y;
    float progress = [self progressWithSource:scrollY
                                 startingWith:-(_tableView.frame.size.height - _tableViewHeight)
                                      ammount:self.parentView.frame.size.height - _tableViewHeight];

    if (progress <= .6f)
        [self dismissWithSelectedOption:self.cancelTitle];
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ((targetContentOffset->y) / 2 > scrollView.frame.size.height)
        [self dismissWithSelectedOption:self.cancelTitle];
}

#pragma mark - Helpers

- (void)configureCell:(LVGradientActionSheetTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.option          = ([(NSString *)[self.options objectAtIndex:[indexPath row]] uppercaseString]);
    cell.backgroundColor = [UIColor clearColor];

    if ([cell.option isEqualToString:[self.cancelTitle uppercaseString]])
        [cell setDarkEnabled:YES];
}

- (float)calculateTableViewCellHeigh
{
    NSDictionary *attributes = [LVGradientActionSheetTableViewCell optionAttributes];
    CGSize textSize          = [self.cancelTitle boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:attributes
                                                              context:nil].size;
    return textSize.height + kTopPadding + kButtomPadding;
}

@end
