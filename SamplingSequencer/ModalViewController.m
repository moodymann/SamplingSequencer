//
//  ModalViewController.m
//  SamplingSequencer
//
//  Created by isid on 2015/04/15.
//  Copyright (c) 2015年 neckpain. All rights reserved.
//

#import "ModalViewController.h"
#import "FirstViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController
{
    NSMutableArray *fileList;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _textField.delegate = self;

    _titleLabel.text = _receiveString;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _execButton.titleLabel.text = _receiveString;
    
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'-'HH:mm:ss"];
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    _textField.text = dateString;
    
    
    // ファイルマネージャを作成
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:directory
                                                     error:&error];
    
    // ファイルやディレクトリの一覧を表示する
    fileList = [[NSMutableArray alloc] init];
    
    for (NSString *path in list) {
        [fileList addObject:[path stringByDeletingPathExtension]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closeModalView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)execButtonEvent:(id)sender {
    if ([_receiveString isEqualToString:@"SAVE"]) {
        [self saveEvent];
    }else if ([_receiveString isEqualToString:@"LOAD"]){
        [self loadEvent];
    }else if ([_receiveString isEqualToString:@"DELETE"]){
        [self deleteEvent];
    }
}

- (void)saveEvent
{
    NSNumber *bpm = [NSNumber numberWithInt:[SharedService sharedInstance].bpm];
    NSArray *step1 = [SharedService sharedInstance].steps1;
    
    NSMutableDictionary* list = [[NSMutableDictionary alloc]init];
    [list setObject:bpm forKey:@"bpm"];
    [list setObject:step1 forKey:@"step1"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _textField.text]];
    
    BOOL successful = [list writeToFile:filePath atomically:NO];
    
    if (successful) {
        NSLog(@"save success");
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)loadEvent
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _textField.text]];
    NSDictionary* list = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:filePath];
    if(success) {
        list = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    }
    
    if (list) {
        for (NSString *data in list) {
            NSLog(@"%@", [list objectForKey: data]);
            if ([data isEqualToString:@"bpm"]) {
                [SharedService sharedInstance].bpm = [[list objectForKey:data] integerValue];
            }else if ([data isEqualToString:@"step1"]){
                [SharedService sharedInstance].steps1 = [list objectForKey:data];
            }
        }
    }else {
        NSLog(@"%@", @"データがありません。");
    }
    
    UITabBarController *bc = (UITabBarController *)self.presentingViewController;
    FirstViewController *vc = bc.viewControllers[0];
    [vc updateSeqView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) deleteEvent
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _textField.text]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager removeItemAtPath:filePath error:nil];
    
    if(success) {
        NSArray *list = [fileManager contentsOfDirectoryAtPath:directory
                                                         error:nil];
        
        [fileList removeAllObjects];
        for (NSString *path in list) {
            [fileList addObject:[path stringByDeletingPathExtension]];
        }
        
        NSLog(@"削除");
        [_tableView reloadData];
    }

}
- (BOOL)textFieldShouldReturn:(UITextField*)textField{
    [_textField resignFirstResponder];
    return YES;
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fileList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _textField.text = [[fileList objectAtIndex:indexPath.row] stringByDeletingPathExtension];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        // セルを作成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // セルにテキストを設定
    cell.textLabel.text = [fileList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    return cell;
}

@end
