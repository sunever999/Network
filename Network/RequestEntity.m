//
//  RequestEntity.m
//  Network
//
//  Created by Sam on 13-5-1.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "RequestEntity.h"

@implementation RequestEntity
@synthesize requestComplete = _requestComplete;

- (id)init
{
    if (self = [super init]) {
        _requestTag = Request_Hot_Cities;
        _requestPath = [[NSString alloc] init];
        _requestParameters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_requestPath release];
    [_requestParameters release];
    [_requestComplete release];
    
    [super dealloc];
}

@end
