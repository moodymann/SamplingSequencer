//
//  HeaderView.h
//  SimpleSeq
//
//  Created by isid on 2014/08/14.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderDelegate;

@interface HeaderView : UIView

@property(nonatomic, weak)     id<HeaderDelegate> delegate;

@property(nonatomic, retain)UINavigationBar *navBar;
@property(nonatomic, retain)UINavigationItem *navItem;

@end

@protocol HeaderDelegate <NSObject>
@optional
- (void)playButtonEvent;
- (void)stopButtonEvent;
@end
