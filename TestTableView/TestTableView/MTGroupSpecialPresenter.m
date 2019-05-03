//
//  MTGroupSpecialPresenter.m
//  TestTableView
//
//  Created by 塞纳 on 2019/5/3.
//  Copyright © 2019年 saina. All rights reserved.
//

#import "MTGroupSpecialPresenter.h"




@interface MTGroupSpecialPresenter ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**
 是否需要改变tableview的frame
 */
@property (nonatomic, assign) BOOL isNeedChangeFrame;
/**
 tableivew的最后滚动位置
 */
@property (nonatomic, assign) CGFloat lastOffsetY;


@end
@implementation MTGroupSpecialPresenter
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
    return NO;
}
/**
 配置tableview相关的东西
 
 @param tableView tableview
 */
-(void)configureTableView:(UITableView *)tableView{
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor redColor];
    tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    self.isNeedChangeFrame = YES;
    self.lastOffsetY = -200;
    
    [tableView reloadData];
    
    self.tableView = tableView;
    
    self.tableView.contentOffset = CGPointMake(0, -200);
    
}
#pragma mark - tableview的datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.textLabel.text = [NSString stringWithFormat:@"aaa -- %zd",indexPath.row];
    return cell;
}
#pragma mark - tableview 的 delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (decelerate == NO) {
        
        NSLog(@"停止移动了");
        NSLog(@"%f",scrollView.contentOffset.y);
        
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            offsetY = 0;
        }else if (offsetY <= 0){
            offsetY = fabs(offsetY);
        }
        self.lastOffsetY = scrollView.contentOffset.y;
        if ([self.presenerDelegate respondsToSelector:@selector(isNeedChangeFrame:distanceY:limitY:)]) {
            [self.presenerDelegate isNeedChangeFrame:self.isNeedChangeFrame distanceY:offsetY limitY:200];
            self.tableView.contentOffset = CGPointMake(0,0);
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
   
    NSLog(@"停止移动了");
    NSLog(@"%f",scrollView.contentOffset.y);
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        offsetY = 0;
    }else if (offsetY <= 0){
        offsetY = fabs(offsetY);
    }
    self.lastOffsetY = scrollView.contentOffset.y;
    if ([self.presenerDelegate respondsToSelector:@selector(isNeedChangeFrame:distanceY:limitY:)]) {
        [self.presenerDelegate isNeedChangeFrame:self.isNeedChangeFrame distanceY:offsetY limitY:200];
        self.tableView.contentOffset = CGPointMake(0,0);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"将要开始移动");
    
    if ([self.presenerDelegate respondsToSelector:@selector(isNeedChangeFrame:distanceY:limitY:)]) {
        
        [self.presenerDelegate isNeedChangeFrame:self.isNeedChangeFrame distanceY:0 limitY:200];
        self.tableView.contentOffset = CGPointMake(0,self.lastOffsetY);
    }
}
#pragma mark - 关于tableivew的frame的处理



@end
