//
//  ViewController.m
//  MKAlertManagerExample
//
//  Created by Michał Kaliniak on 19.09.2016.
//  Copyright © 2016 Michal Kaliniak. All rights reserved.
//

#import "ViewController.h"
#import "MKAlertManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)defaultAction:(id)sender
{
    [[MKAlertManager sharedManager] showAlertWithName:@"Test message! Hello!"];
}

- (IBAction)fromLeftAction:(id)sender
{
    [[MKAlertManager sharedManager] showAlertWithName:@"Hello! Animation from left to right!" showType:MKAlertShowTypeFromLeft];
}

- (IBAction)fromBottomAction:(id)sender
{
    [[MKAlertManager sharedManager] showAlertWithName:@"Hi! I'm here! On bottom!" showType:MKAlertShowTypeFromBottomOnBottom];
}

- (IBAction)multipleAction:(id)sender
{
    [[MKAlertManager sharedManager] showAlertWithName:@"Rectangle default" showType:MKAlertShowTypeNormal messageStyle:MKAlertMessageSyleRectangle];
    
    [[MKAlertManager sharedManager] showAlertWithName:@"Rectangle from left" showType:MKAlertShowTypeFromLeft messageStyle:MKAlertMessageSyleRectangle];
    
    [[MKAlertManager sharedManager] showAlertWithName:@"Rounded form bottom" showType:MKAlertShowTypeFromBottomOnBottom messageStyle:MKAlertMessageSyleRounded];
}

@end
