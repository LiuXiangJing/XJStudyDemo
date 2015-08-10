//
//  DebugTools.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/4.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DebugTools : NSObject
// Show the tree
+ (void)logViewTreeForMainWindow:(UIView *)view;
@end
