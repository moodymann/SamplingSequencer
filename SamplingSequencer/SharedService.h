//
//  SharedService.h
//  SamplingSequencer
//
//  Created by isid on 2015/04/15.
//  Copyright (c) 2015年 neckpain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedService : NSObject

+ (SharedService *) sharedInstance;

@property (nonatomic, retain)NSString *currentFileName;
@property (nonatomic, retain)NSMutableArray* steps1;
@property (nonatomic, assign)NSInteger bpm;

@end
