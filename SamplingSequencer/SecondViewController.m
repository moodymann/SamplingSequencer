//
//  SecondViewController.m
//  SamplingSequencer
//
//  Created by isid on 2014/09/01.
//  Copyright (c) 2014年 neckpain. All rights reserved.
//

#import "SecondViewController.h"
#import "ModalViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didDissmissView:(UIViewController *)controller
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"save"] ) {
        ModalViewController *nextViewController = [segue destinationViewController];
        nextViewController.receiveString = @"SAVE";
    }else if ([[segue identifier] isEqualToString:@"load"]){
        ModalViewController *nextViewController = [segue destinationViewController];
        nextViewController.receiveString = @"LOAD";
    }else if ([[segue identifier] isEqualToString:@"delete"]){
        ModalViewController *nextViewController = [segue destinationViewController];
        nextViewController.receiveString = @"DELETE";
    }
}
@end
