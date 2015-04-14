//
//  SeqView.m
//  SimpleSeq
//
//  Created by isid on 2014/08/08.
//  Copyright (c) 2014年 SimpleSeq. All rights reserved.
//

#import "SeqView.h"

@implementation SeqView
{
    UIImage			*_imageCache;
}

@synthesize stepsDown = _stepsDown;
@synthesize currentStep = _currentStep;

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder: aDecoder];
	if (self) {
//        UILabel *label = [[UILabel alloc]init];
//        label.frame = CGRectMake(100.0f, 50.0f, 100.0f, 20.0f);
//        label.text = @"aaa";
//        label.textColor = [UIColor blackColor];
//        [self addSubview:label];
        _stepsDown = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];
        _currentStep = -1;
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!_imageCache) {
        CGContextRef context = UIGraphicsGetCurrentContext();                       //  コンテキスト取得
        CGContextSaveGState(context);                                               //  グラフィック状態の保存
        CGFloat margin = 20.0;
        CGFloat size = self.frame.size.width / 4.0 - margin;
        
        for (NSInteger i = 0; i < 4; i++) {
            CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
            for (NSInteger j = 0; j < 4; j++) {
                NSInteger p = (i * 4) + j;
                if ([[_stepsDown objectAtIndex:p] isEqualToString:@"1"]) {
                    if (p == _currentStep) {
                        CGContextSetRGBFillColor(context, 0.1, 0.6, 0.6, 0.5);
                    }else{
                        CGContextSetRGBFillColor(context, 0.0, 0.5, 0.5, 0.5);
                    }
                    CGContextFillRect(context, CGRectMake(size * (j + 1) - margin, margin + (i * size), size, size));
                }else if(p == _currentStep){
                    CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 0.5);
                    CGContextFillRect(context, CGRectMake(size * (j + 1) - margin, margin + (i * size), size, size));
                }else{
                    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
                    CGContextFillRect(context, CGRectMake(size * (j + 1) - margin, margin + (i * size), size, size));
                }
                CGContextStrokeRect(context, CGRectMake(size * (j + 1) - margin, margin + (i * size), size, size));
            }
        }
        CGContextRestoreGState(context);                                            //  グラフィック状態の復元
        _imageCache = UIGraphicsGetImageFromCurrentImageContext();
    }else{
        [_imageCache drawInRect:self.bounds];
    }
}

#pragma mark Event handling
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    for (UITouch *touch in touches) {
        CGPoint loc = [touch locationInView: self];
        
        if (loc.x >= 40.0 && loc.x <= 280.0 && loc.y >= 30.0 && loc.y <= 270.0) {
            NSInteger x = (loc.x - 40.0) / 60;
            NSInteger y = (loc.y - 30.0) / 60;
            
            NSInteger point = x + y * 4;
            if ([[_stepsDown objectAtIndex:point] isEqualToString:@"0"]) {
                [_stepsDown replaceObjectAtIndex:point withObject:@"1"];
            }else{
                [_stepsDown replaceObjectAtIndex:point withObject:@"0"];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)timerFired:(NSInteger)step
{
    _currentStep = step;
    [self setNeedsDisplay];
}

@end
