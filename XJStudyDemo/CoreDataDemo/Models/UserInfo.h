//
//  UserInfo.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/30.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//


#import "XJBaseModel.h"

@class UserDetailInfo;
@interface UserInfo : XJBaseModel

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) UserDetailInfo *detailInfo;
-(UserInfo *)initWithUserId:(NSString *)userId userName:(NSString *)userName phoneNumber:(NSString *)phoneNumber avatar:(NSString*)avatar email:(NSString*)email;
@end
