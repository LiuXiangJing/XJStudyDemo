//
//  XJTestModel.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/11.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTestModel.h"
#import "XJStatus.h"

@implementation XJTestModel
- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [XJStatus class]};
}
@end
