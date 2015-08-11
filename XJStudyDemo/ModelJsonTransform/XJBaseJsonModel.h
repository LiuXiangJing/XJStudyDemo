//
//  XJBaseModel.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/11.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ModelTransformer(prop,transformer)          + (NSValueTransformer *)prop##JSONTransformer{return transformer;}
#import <Mantle.h>
#import <Mantle/MTLModel.h>
@interface XJBaseJsonModel : MTLModel<MTLJSONSerializing>

@end
