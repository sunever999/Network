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
#import "HotCitiesRequest.h"

@interface ESViewController ()

@end

@implementation ESViewController

- (void)btnClicked
{
    NSLog(@"button clicked.");
    
    // new method    
    HotCitiesRequest *hotCityRequest = [[HotCitiesRequest alloc] init];
    
    [[NetworkManager sharedManager] doRequest:hotCityRequest complete:^(ResponseEntity *response) {
        if (response.success) {
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
