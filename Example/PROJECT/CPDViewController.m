//
//  CPDViewController.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDViewController.h"
#import <AlertViewCC.h>

@interface CPDViewController ()

@end

@implementation CPDViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonAction:(id)sender {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//        AlertViewCC *alertView = [[CCAlertFactory shareInstance] createAlertView:@"saa"];
    AlertViewCC * alertView = [[CCAlertFactory  shareInstance] createAlertViewWithTitle:@"aaa" message:@"bbb" style:UIAlertViewStyleDefault cancelAction:[CCAlertAction actionWithTitle:@"取消" handler:nil] otherActions:[CCAlertAction actionWithTitle:@"1" handler:^(CCAlertAction * _Nullable action) {
        NSLog(@"%@",action.title);
    }], nil];
    //,[CCAlertAction actionWithTitle:@"2" handler:^(CCAlertAction * _Nullable action) {
//        NSLog(@"%@",action.title);
    
//    }]
        [alertView addAction:[CCAlertAction actionWithTitle:@"33" handler:^(CCAlertAction * _Nullable action) {
            NSLog(@"%@",action.title);
    
        }]];
        [alertView addCustomView:textField viewHandler:^(UIView * _Nullable view) {
            UITextField *t = (UITextField *)view;
            t.placeholder = @"aaaaaaa";
        }];
        [alertView addCustomView:[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)] viewHandler:^(UIView * _Nullable view) {
            UITextView *t = (UITextView *)view;
            t.backgroundColor = [UIColor yellowColor];
        }];
    [alertView show];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(popAction) userInfo:<#(nullable id)#> repeats:<#(BOOL)#>]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
