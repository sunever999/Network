//
//  ESViewController.m
//  Network
//
//  Created by Sam on 13-4-7.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "ESViewController.h"

#import "NetworkManager.h"

#import "RequestEntity.h"

@interface ESViewController ()

@end

@implementation ESViewController

- (void)btnClicked
{
    NSLog(@"button clicked.");
    
//    [[NetworkManager sharedManager] getHotCities:self onSuccess:@selector(success) onFail:@selector(fail)];
    
//    [[NetworkManager sharedManager] getHotcities:^(BOOL success, NSDictionary *userInfo) {
//        if (success) {
//            NSData *data = [userInfo objectForKey:@"data"];
//            NSError *jsonParsingError = nil;
//            NSArray *hotCities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//
//            NSLog(@"block success [%@]", hotCities);
//        }
//        else {
//            NSLog(@"block fail");
//        }
//    }];
    
    
    // new method
    RequestEntity *request = [[RequestEntity alloc] init];
    request.requestTag = Request_Hot_Cities;
    request.requestPath = @"appColorTrendUAMisc";
    request.requestParameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"getHotCities", @"cmd", nil];
    
    [[NetworkManager sharedManager] doRequest:request complete:^(ResponseEntity *response) {
        if (response.success) {
//            NSData *data = [userInfo objectForKey:@"data"];
            NSError *jsonParsingError = nil;
            NSArray *hotCities = [NSJSONSerialization JSONObjectWithData:response.responseData options:0 error:&jsonParsingError];
            
            NSLog(@"block success [%@]", hotCities);
        }
        else {
            NSLog(@"block fail [%@]", response.errorMsg);
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
