//
//  ESColorAlbum.h
//  Network
//
//  Created by Sam on 13-4-14.
//  Copyright (c) 2013年 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESColorAlbum : NSObject

@property (nonatomic, retain) NSMutableArray *albums;


+ (id)sharedInstance;

@end



@interface OneColorAlbum : NSObject

@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, retain) NSMutableArray *colorIndexes;

@end