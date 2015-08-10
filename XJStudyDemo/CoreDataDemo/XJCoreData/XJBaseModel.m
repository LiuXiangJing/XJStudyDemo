//
//  XJBaseModel.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/7/30.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJBaseModel.h"
#import "XJCoreData.h"
@implementation XJBaseModel
@synthesize primaryKey;
+(NSString *)primaryKey{
    return @"";
}

+(NSString *)getEntityName
{
    return NSStringFromClass([self class]);
}
+(instancetype)initObjectWithPrimaryValue:(NSString *)primaryValue
{
    NSArray * tempArray =[[XJCoreData shareCoreData] findObjectFrom:[self getEntityName] Key:[self primaryKey] Value:primaryValue];
    if (tempArray && [tempArray count]>0) {
        return [tempArray objectAtIndex:0];
    }else{
        return [NSEntityDescription insertNewObjectForEntityForName:[self getEntityName] inManagedObjectContext:[[XJCoreData shareCoreData]managedObjectContext]];
    }
    return nil;
}
+(instancetype)initObject{
    return [NSEntityDescription insertNewObjectForEntityForName:[self getEntityName] inManagedObjectContext:[[XJCoreData shareCoreData]managedObjectContext]];
}
-(void)saveObject{
    [[XJCoreData shareCoreData] saveContext];
}
@end
