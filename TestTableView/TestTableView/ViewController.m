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




@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MTGroupSpecialPresenterDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *texFieldBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@property (nonatomic, strong) MTGroupSpecialPresenter *groupSpecialPresenter;
@property (nonatomic, strong) UITableView *specialTableView;



@end
@implementation ViewController
- (UITableView *)specialTableView{
    if (!_specialTableView) {
        self.specialTableView = [[UITableView alloc] init];
    }
    return _specialTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        [self.view addSubview:self.specialTableView];
        [self.specialTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.textField);
        }];
        [self.groupSpecialPresenter configureTableView:self.specialTableView];
    }else{
        
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
#pragma mark presenter的delegate
/**
 改变tableview的frame
 
 @param isNeedFrame 是否需要改变frame
 @param distanceY :tableview 距离顶部的y 值
 @param limitY :tableview 距离顶部的y 值
 */
-(void)isNeedChangeFrame:(BOOL)isNeedFrame distanceY:(CGFloat)distanceY limitY:(CGFloat)limitY{
    if (isNeedFrame) {
        [self.specialTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.view).offset(distanceY > limitY ? limitY:distanceY);
        }];
        
    }
    
    
}

#pragma mark - 其他事件的响应
- (void)keyboardChanged:(NSNotification *)info{
    
    CGRect rect = [info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat shouldHeight = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    self.texFieldBottomConstraint.constant = shouldHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}


@end
