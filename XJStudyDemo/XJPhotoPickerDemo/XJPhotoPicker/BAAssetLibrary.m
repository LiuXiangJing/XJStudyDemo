//
//  BAAssetLibrary.m
//  microphone
//
//  Created by 任前辈 on 15/6/5.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "BAAssetLibrary.h"

@implementation BAAssetLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
