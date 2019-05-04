//
//  ViewController.m
//  TestTableView
//
//  Created by 塞纳 on 2019/5/3.
//  Copyright © 2019年 saina. All rights reserved.
//

#import "ViewController.h"
#import "MTGroupSpecialPresenter.h"
#import "Masonry/Masonry.h"
#import "MTGroupSpecialTableView.h"

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MTGroupSpecialPresenterDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texFieldBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) MTGroupSpecialPresenter *groupSpecialPresenter;




@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.layer.cornerRadius = 20;
    self.textField.layer.masksToBounds = YES;
    
    self.groupSpecialPresenter = [[MTGroupSpecialPresenter alloc] init];
    self.groupSpecialPresenter.presenerDelegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [self showOrHideSpecialTableView:textField.text singleText:string];
    
    return YES;
}
/**
 展示或者隐藏@的tableview

 @param textFieldText textField的text
 @param singleText 当时正在输入的文字
 */
-(void)showOrHideSpecialTableView:(NSString *)textFieldText singleText:(NSString *)singleText{
    if ([self.groupSpecialPresenter isAllowShowSpecialTableView:textFieldText singleText:singleText]) { // 允许出现@界面
        if (!self.groupSpecialPresenter.specialTableView) {
            self.groupSpecialPresenter.specialTableView = [[MTGroupSpecialTableView alloc] init];
        }
        [self.view addSubview:self.groupSpecialPresenter.specialTableView];
        [self.self.groupSpecialPresenter.specialTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view).offset(self.textField.frame.origin.y);
            make.bottom.mas_equalTo(self.textField).offset(-45);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.groupSpecialPresenter configureTableView];
        });
    }
    
}
#pragma mark - tableview 的 dataosurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellId";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    return cell;
}
#pragma mark - mainTableView 的 lelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textField resignFirstResponder];
}
#pragma mark presenter的delegate
-(void)mtGroupPresenter:(MTGroupSpecialPresenter *)presenter changeTableViewTopAndNeedTableView:(BOOL)isNeed{
    if (!isNeed) {
        [self.groupSpecialPresenter.specialTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(self.textField.frame.origin.y);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [presenter removeAll];
        }];
    }else{
            [self.groupSpecialPresenter.specialTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view);
            }];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view layoutIfNeeded];
            }];
    }
}
#pragma mark - 其他事件的响应
- (void)keyboardChanged:(NSNotification *)info{
    
    CGRect rect = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat shouldHeight = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    self.texFieldBottomConstraint.constant = shouldHeight;
    if (shouldHeight) {
        self.groupSpecialPresenter.keyBoardH = shouldHeight;
    }
    if (shouldHeight > 0) { // 键盘弹起来
        [self.groupSpecialPresenter keyBoardChangeIsUP:YES];
        
    }else{ // 键盘消失
       [self.groupSpecialPresenter keyBoardChangeIsUP:NO];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
