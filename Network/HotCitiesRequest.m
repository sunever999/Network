//
//  HotCitiesRequest.m
//  Network
//
//  Created by Sam on 13-5-2.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "HotCitiesRequest.h"

@implementation HotCitiesRequest

- (id)init
{
    if (self = [super init]) {
    }
    
    return self;
}

- (NSMutableDictionary *)getRequestParameters
{
    self.requestPath = @"appColorTrendUAMisc";

    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@"getHotCities", @"cmd", nil];
}

@end
