//
//  ModalViewController.h
//  SamplingSequencer
//
//  Created by isid on 2015/04/15.
//  Copyright (c) 2015年 neckpain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedService.h"

@protocol ModalViewControllerDelegate <NSObject>

@required
- (void)didDissmissView:(UIViewController *)controller;
@end

@interface ModalViewController : UIViewController

<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    id<ModalViewControllerDelegate> modalViewControllerDelegate;
}
@property NSString *receiveString;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *execButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
