//
//  LVViewController.m
//  LVGradientActionSheetDemo
//
//  Created by Martín Fernández on 2/27/14.
//  Copyright (c) 2014 Martín Fernández. All rights reserved.
//

#import "LVViewController.h"


@interface LVViewController ()

@end

@implementation LVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)showActionSheet:(id)sender
{
    LVGradientActionSheet *actionSheet = [[LVGradientActionSheet alloc] initWithOptions:@[@"Follow",@"Fuck you", @"Hello"]
                                                                            cancelTitle:@"Cancel"
                                                                       topGradientColor:[UIColor colorWithRed:108.f/255.f green:118.f/255.f blue:244.f/255.f alpha:1.0f]
                                                                    bottomGradientColor:[UIColor colorWithRed:22.f/255.f green:224.f/255.f blue:117.f/255.f alpha:0.f]
                                                                               delegate:self];
    
//    LVGradientActionSheet *actionSheet = [[LVGradientActionSheet alloc] initWithOptions:@[@"Follow",@"Fuck you", @"Hello"]
//                                                                            cancelTitle:@"Cancel"
//                                                                       topGradientColor:[UIColor redColor]
//                                                                    bottomGradientColor:[UIColor blueColor]
//                                                                               delegate:self];
    
//    LVGradientActionSheet *actionSheet = [[LVGradientActionSheet alloc] initWithOptions:@[@"Follow",@"Fuck you", @"Hello"]
//                                                                            cancelTitle:@"Cancel"
//                                                                       topGradientColor:[UIColor greenColor]
//                                                                    bottomGradientColor:[UIColor blueColor]
//                                                                               delegate:self];
    
    [actionSheet showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(LVGradientActionSheet *)actionSheet clickedButtonWithOption:(NSString *)option
{
    NSLog(@"%@",option);
}

@end
