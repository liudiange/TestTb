//
//  MTGroupSpecialTableView.m
//  TestTableView
//
//  Created by 刘殿阁 on 2019/5/4.
//  Copyright © 2019 saina. All rights reserved.
//

#import "MTGroupSpecialTableView.h"

@implementation MTGroupSpecialTableView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
 
    NSLog(@"point.y : %f self.tableHeaderView.frame.size.height : %f self.frame.origin.y : %f  self.contentSize.height : %f self.contentOffset.y : %f",point.y ,self.tableHeaderView.frame.size.height,(self.frame.origin.y + self.frame.size.height),self.contentSize.height,self.contentOffset.y);
    if (point.y >=  (self.frame.origin.y + self.frame.size.height + self.contentOffset.y)) {
        return NO;
    }else{
        if (point.y < self.tableHeaderView.frame.size.height) {
            
            return NO;
        }
        return YES;
    }
    
}

@end
