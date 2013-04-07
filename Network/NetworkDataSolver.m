//
//  NetworkDataSolver.m
//  songguo
//
//  Created by songguo on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NetworkDataSolver.h"
#import "JSON.h"
#import "NetworkManager.h"


@implementation NetworkDataSolver


- (BOOL)isResponseStringValid:(NSString *)string
{
    if ([string rangeOfString:@"errStr"].location != NSNotFound &&
        [string rangeOfString:@"err"].location != NSNotFound) {
        NSDictionary *dic = [string JSONValue];
//        NSLog(@"errStr:[%@] err:[%@]", [dic objectForKey:@"errStr"], [dic objectForKey:@"err"]);
        
        [[NetworkManager sharedManager] parseErrorMsg:dic];
        
        return NO;
    }
    
    return YES;
}


#pragma mark - 获取热门城市列表
- (void)parseHotCities:(NSData *)data
{
    NSError *jsonParsingError = nil;
    NSArray *hotCities = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    NSLog(@"data:[%@]", hotCities);
    
    if (hotCities) {
        if (requestComplete) {
            requestComplete(YES);
        }
    }
}

#pragma mark - 按颜色查询(A，B，C三件单品，1，随机取，2，按用户选择类型取，3，A不变，更换B，C）
- (void)parseColorSuits:(NSData *)data
{
}

#pragma mark - 获取app store上的苏格app版本号
- (void)parseAppStoreVersion:(NSData *)data
{
}


#pragma mark - New Interface Method for dongge

- (void)parseData:(NSData *)data requestTag:(RequestTag)iTag complete:(void(^)(BOOL))requestFinished
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
