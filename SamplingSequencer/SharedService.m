//
//  SharedService.m
//  SamplingSequencer
//
//  Created by isid on 2015/04/15.
//  Copyright (c) 2015年 neckpain. All rights reserved.
//

#import "SharedService.h"

@implementation SharedService

/*******************************************************************************
 *  sharedInstance
 *  自身のインスタンスを返却
 */
+ (SharedService *)sharedInstance
{
	static SharedService *sharedInstance;
	
	@synchronized(self)
	{
		if (!sharedInstance) {
			sharedInstance = [[SharedService alloc] init];
        }
		return sharedInstance;
	}
}

- (id)init
{
    if ((self = [super init])) {
        _currentFileName = [[NSString alloc] init];
        _bpm = 120;
        _steps1 = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];

    }
    return self;
}

@end
