//
//  ESViewController.m
//  Network
//
//  Created by Sam on 13-4-7.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "ESViewController.h"

#import "NetworkManager.h"

@interface ESViewController ()

@end

@implementation ESViewController

- (void)btnClicked
{
    NSLog(@"button clicked.");
    
//    [[NetworkManager sharedManager] getHotCities:self onSuccess:@selector(success) onFail:@selector(fail)];
    
    [[NetworkManager sharedManager] getHotcities:^(BOOL success, NSDictionary *userInfo) {
        if (success) {
            NSLog(@"block success [%@]", [userInfo objectForKey:@"data"]);
        }
        else {
            NSLog(@"block fail");
        }
    }];
}

- (void)success
{
    NSLog(@"success");
}

- (void)fail
{
    NSLog(@"fail");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(50, 50, 60, 30);
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
