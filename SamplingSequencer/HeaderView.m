//
//  HeaderView.m
//  SimpleSeq
//
//  Created by isid on 2014/08/14.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

@synthesize navBar = _navBar;
@synthesize navItem = _navItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];

    if (self) {
        [self initView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    /* ナビゲーションバー */
    _navBar.frame = CGRectMake(0.0f,
                                    0.0f,
                                    self.frame.size.width,
                                    self.frame.size.height);

}

- (void)viewDidLoad
{
}

- (void)initView
{
    _navBar = [[UINavigationBar alloc] init];
    _navItem = [[UINavigationItem alloc] init];
    
    UIBarButtonItem *playBarButton = [[UIBarButtonItem alloc] initWithTitle:@"PLAY"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(playEvent:)];
    UIBarButtonItem *stopBarButton = [[UIBarButtonItem alloc] initWithTitle:@"STOP"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(stopEvent:)];
    
    _navItem.leftBarButtonItems = [NSMutableArray arrayWithObjects:playBarButton, stopBarButton, nil];
    
    [_navBar pushNavigationItem:_navItem animated:YES];
    [self addSubview:_navBar];
}

- (void)playEvent:(id)sender
{
    NSLog(@"play");
    if ([self.delegate respondsToSelector:@selector(playButtonEvent)]) {
        [self.delegate playButtonEvent];
    }
}

- (void)stopEvent:(id)sender
{
    NSLog(@"stop");
    if ([self.delegate respondsToSelector:@selector(stopButtonEvent)]) {
        [self.delegate stopButtonEvent];
    }
}
@end
