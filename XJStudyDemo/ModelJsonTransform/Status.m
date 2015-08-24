//
//  Status.m
//  字典与模型的互转
//
//  Created by MJ Lee on 14-5-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "Status.h"
#import "User.h"
@implementation Status
ModelTransformer(user, [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]])

@end
