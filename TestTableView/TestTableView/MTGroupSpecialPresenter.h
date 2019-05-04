//
//  MTGroupSpecialPresenter.h
//  TestTableView
//
//  Created by 塞纳 on 2019/5/3.
//  Copyright © 2019年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MTGroupSpecialTableView.h"

@class MTGroupSpecialPresenter;

@protocol MTGroupSpecialPresenterDelegate <NSObject>

/**
 改变tableview的约束

 @param presenter 当前对象
 @param isNeed 是否需要改变
 */
-(void)mtGroupPresenter:(MTGroupSpecialPresenter *)presenter changeTableViewTopAndNeedTableView:(BOOL)isNeed;

@end

@interface MTGroupSpecialPresenter : NSObject

@property (nonatomic, weak) id<MTGroupSpecialPresenterDelegate> presenerDelegate;

/**
 显示@成员的tableview
 */
@property (nonatomic, strong) MTGroupSpecialTableView *specialTableView;
/**
 键盘的高度
 */
@property (nonatomic, assign) CGFloat keyBoardH;

#pragma mark - 实现的方法
/**
 是否出现@的tableview界面

 @param textFieldText 整个输入框的文字
 @param singleText 当前正在输入的文字
 @return 是否需要出现@的界面
 */
-(BOOL)isAllowShowSpecialTableView:(NSString *)textFieldText singleText:(NSString *)singleText;

/**
 配置tableview相关的东西

 */
-(void)configureTableView;
/**
 移除操作
 */
-(void)removeAll;

/**
 键盘是弹起来还是没有弹起来

 @param isUp Yes：弹起来
 */
-(void)keyBoardChangeIsUP:(BOOL)isUp;

@end

