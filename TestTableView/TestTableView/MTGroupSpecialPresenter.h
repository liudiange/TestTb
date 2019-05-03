//
//  MTGroupSpecialPresenter.h
//  TestTableView
//
//  Created by 塞纳 on 2019/5/3.
//  Copyright © 2019年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MTGroupSpecialPresenterDelegate <NSObject>
/**
 改变tableview的frame
 
 @param isNeedFrame 是否需要改变frame
 @param distanceY :tableview 距离顶部的y 值
 @param limitY :tableview 距离顶部的y 值
 */
-(void)isNeedChangeFrame:(BOOL)isNeedFrame distanceY:(CGFloat)distanceY limitY:(CGFloat)limitY;


@end
@interface MTGroupSpecialPresenter : NSObject

@property (nonatomic, weak) id<MTGroupSpecialPresenterDelegate> presenerDelegate;


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

 @param tableView tableview
 */
-(void)configureTableView:(UITableView *)tableView;



@end

NS_ASSUME_NONNULL_END
