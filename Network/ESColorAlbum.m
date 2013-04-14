//
//  ESColorAlbum.m
//  Network
//
//  Created by Sam on 13-4-14.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import "ESColorAlbum.h"

@implementation ESColorAlbum

+ (id)sharedInstance
{
    static ESColorAlbum *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ESColorAlbum alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _albums = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_albums release];
    
    [super dealloc];
}

@end



@implementation OneColorAlbum

- (id)init
{
    self = [super init];
    
    if (self) {
        _iconURL = [[NSString alloc] init];
        _imageURL = [[NSString alloc] init];
        _colorIndexes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [_iconURL release];
    [_imageURL release];
    [_colorIndexes release];
    
    [super dealloc];
}

@end