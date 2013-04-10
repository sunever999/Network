//
//  NetworkDataSolver.m
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkDataSolver.h"
#import "NetworkManager.h"

@implementation NetworkDataSolver


#pragma mark - 获取热门城市列表
- (void)parseHotCities:(NSData *)data
{
    NSError *jsonParsingError = nil;
    NSArray *hotCities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    if (hotCities) {
        if (requestComplete) {
            requestComplete(YES, [NSDictionary dictionaryWithObjectsAndKeys:hotCities, @"data", nil]);
        }
    }
}


#pragma mark - New Interface Method for dongge

- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag complete:(void(^)(BOOL, NSDictionary*))requestFinished
{
    requestComplete = requestFinished;

    switch (iTag) {
        case Request_Hot_Cities:
            [self parseHotCities:data];
            break;

        default:
            break;
    }
}


#pragma mark - Class lifecycle

- (void)dealloc
{
//    NSLog(@"NetworkDataSolver dealloc");    
    [super dealloc];
}

@end
