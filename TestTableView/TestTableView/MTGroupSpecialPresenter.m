//
//  MTGroupSpecialPresenter.m
//  TestspecialTableView
//
//  Created by 塞纳 on 2019/5/3.
//  Copyright © 2019年 saina. All rights reserved.
//

#import "MTGroupSpecialPresenter.h"

@interface MTGroupSpecialPresenter ()<UITableViewDelegate,UITableViewDataSource>
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *specialDataArray;
/**
 是不是整屏幕都放不完cell的那种类型
 */
@property (nonatomic, assign) BOOL isMaxType;
/**
 tableview的headerview的高度
 */
@property (nonatomic, assign) CGFloat specialHeaderViewH;


@end
@implementation MTGroupSpecialPresenter

- (NSMutableArray *)specialDataArray {
    if (!_specialDataArray) {
        _specialDataArray = [NSMutableArray array];
        for (NSInteger index = 0; index < 100; index ++) {
            [_specialDataArray addObject:[NSString stringWithFormat:@"ttt -- %zd",index]];
        }
    }
    return _specialDataArray;
}
/**
 是否出现@的tableview界面
 
 @param textFieldText 整个输入框的文字
 @param singleText 当前正在输入的文字
 @return 是否需要出现@的界面
 */
-(BOOL)isAllowShowSpecialTableView:(NSString *)textFieldText singleText:(NSString *)singleText{
    
    if ([singleText isEqualToString:@"@"]) {
        return YES;
    }
    if (self.specialTableView) {
        if ([self.presenerDelegate respondsToSelector:@selector(mtGroupPresenter:changeTableViewTopAndNeedTableView:)]) {
            [self.presenerDelegate mtGroupPresenter:self changeTableViewTopAndNeedTableView:NO];
        }
    }
    return NO;
}
/**
 配置tableview相关的东西
 */
-(void)configureTableView{
    
    self.specialTableView.delegate = self;
    self.specialTableView.dataSource = self;
    self.specialTableView.rowHeight = 50;
    self.specialTableView.backgroundColor = [UIColor clearColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.isMaxType = [self judgeIsMaxType];
        self.specialHeaderViewH = [self calculateTbaleViewHeight:self.specialDataArray.count];
        
        self.specialTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,self.specialHeaderViewH)];
        self.specialTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        [self.specialTableView reloadData];
        
        if ([self.presenerDelegate respondsToSelector:@selector(mtGroupPresenter:changeTableViewTopAndNeedTableView:)]) {
            [self.presenerDelegate mtGroupPresenter:self changeTableViewTopAndNeedTableView:YES];
        }
    });
}
/**
 移除操作
 */
-(void)removeAll{
   
    [self.specialTableView removeFromSuperview];
    self.specialTableView = nil;
    self.specialHeaderViewH = 0;
    self.isMaxType = NO;
    
}
/**
 键盘是弹起来还是没有弹起来
 
 @param isUp Yes：弹起来
 */
-(void)keyBoardChangeIsUP:(BOOL)isUp{
    if (self.specialTableView.frame.size.height > 0) {
        if (isUp) {
           self.specialHeaderViewH = self.specialHeaderViewH - self.keyBoardH;
        }else{
            self.specialHeaderViewH = self.specialHeaderViewH + self.keyBoardH;
           
        }
        self.specialTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.specialHeaderViewH)];
        self.specialTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        [self.specialTableView reloadData];
    }
}

#pragma mark - 内部实现的操作
/**
 计算tableview的headerview的高度

 @param dataCount 数组个数
 @return 高度
 */
-(CGFloat)calculateTbaleViewHeight:(NSUInteger)dataCount{
    if (self.isMaxType) {
        return 200;
    }else{
        CGFloat height = self.specialDataArray.count * self.specialTableView.rowHeight;
        return  self.specialTableView.frame.origin.y - height ;
    }
}
/**
 是否是大于整个屏幕装不满的那种类型

 @return YES:是
 */
-(BOOL)judgeIsMaxType{
    int count = ([UIScreen mainScreen].bounds.size.height - self.specialTableView.frame.origin.y)/self.specialTableView.rowHeight;
    if (count < self.specialDataArray.count) {
        return YES;
    }
    return NO;
}
#pragma mark - specialTableView的datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.specialDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.backgroundColor = [UIColor yellowColor];
    cell.textLabel.text = self.specialDataArray[indexPath.row];
    return cell;
}



@end
