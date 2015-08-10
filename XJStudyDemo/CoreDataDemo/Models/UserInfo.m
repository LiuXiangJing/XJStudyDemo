//
//  UserInfo.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/30.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "UserInfo.h"
#import "UserDetailInfo.h"


@implementation UserInfo

@dynamic userId;
@dynamic userName;
@dynamic detailInfo;
+(NSString *)primaryKey{
    return @"userName";
}
-(UserInfo *)initWithUserId:(NSString *)userId userName:(NSString *)userName phoneNumber:(NSString *)phoneNumber avatar:(NSString *)avatar email:(NSString *)email{
    self =[UserInfo initObjectWithPrimaryValue:userName];
    self.userId =userId;
    self.userName =userName;
    self.detailInfo =[UserDetailInfo initObject];
    self.detailInfo.phoneNumber =phoneNumber;
    self.detailInfo.avatar =avatar;
    self.detailInfo.email =email;
    return self;
}
@end
