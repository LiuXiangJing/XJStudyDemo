//
//  XJTextRequestViewController.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/10.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTextRequestViewController.h"
#import "XJTestDataSource.h"
@interface XJTextRequestViewController ()
{
    XJTestDataSource * _dataSource;
}
@end
#import "KZWProgressHUD.h"
#import "MJExtension.h"
#import "XJTestModel.h"
#import <Mantle.h>
#import "StatusResult.h"
@implementation XJTextRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [XJTestDataSource dataSource];
}
- (IBAction)sendARequestAction:(id)sender {
    
    [KZWProgressHUD showLoadingInView:self.navigationController.view showOrHidden:YES];
    [_dataSource testRequest:^(BOOL success, NSString *errorMsg, NSArray *results) {
        [KZWProgressHUD showLoadingInView:self.navigationController.view showOrHidden:NO];
        [KZWProgressHUD showTipsInView:self.navigationController.view OnlyString:errorMsg];
    }];
}
- (IBAction)showTipsAction:(id)sender {
    
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"statuses" : @[
                                   @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"明天去旅游了",
                                       
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"嘿嘿，这东西不错哦！",
                                       
                                       @"user" : @{
                                               @"name" : @"Jim",
                                               @"icon" : @"zero.png"
                                               }
                                       }
                                   
                                   ],
                           
                           @"totalNumber" : @"2014",
                           
                           @"previousCursor" : @"13476589",
                           
                           @"nextCursor" : @"13476599",
                           @"status": @{
                               @"text" : @"是啊，今天天气确实不错！",
                               
                               @"user" : @{
                                       @"name" : @"Jack",
                                       @"icon" : @"lufy.png"
                                       },
                               
                               @"retweetedStatus" : @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       }
                               }
                           };
    [self mapData:dict toClass:[StatusResult class] forKey:nil];
    
    /*
    [XJTestModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"statuses" : @"XJStatus"
                 };
    }];
    [XJTestModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                  @"statusabc":@"status"
                 };
    }];
    
    
    XJTestModel * model =[XJTestModel objectWithKeyValues:dict];
    NSLog(@"model=%@",model);
     */
    [KZWProgressHUD showTipsInView:self.navigationController.view OnlyString:@"恭喜你，这个一个提示"];
}
-(void)reans{
    NSArray *dictArray = @[
                           @{
                               @"name" : @"Jack",
                               @"icon" : @"lufy.png",
                               },
                           
                           @{
                               @"name" : @"Rose",
                               @"icon" : @"nami.png",
                               },
                           
                           @{
                               @"name" : @"Jim",
                               @"icon" : @"zero.png",
                               }
                           ];
}
-(void)mapData:(id)respondData toClass:(Class)class forKey:(NSString *)key {
    if (respondData) {
        id mappingData;
        __block NSError *error;
        if ([respondData isKindOfClass:[NSDictionary class]]) {
            if (key) {
                
                id keyData = respondData[key];
                
                if ([keyData isKindOfClass:[NSArray class]]) {
                    mappingData = [MTLJSONAdapter modelsOfClass:class fromJSONArray:keyData error:&error];
                    
                }else {
                    mappingData = [MTLJSONAdapter modelOfClass:class
                                            fromJSONDictionary:keyData
                                                         error:&error];
                }
            }else{
                
                mappingData = [MTLJSONAdapter modelOfClass:class
                                        fromJSONDictionary:respondData
                                                     error:&error];
            }

        }else if ([respondData isKindOfClass:[NSArray class]]){
             mappingData = [MTLJSONAdapter modelsOfClass:class fromJSONArray:respondData error:&error];
        }
        
        NSLog(@"mappingData==%@",mappingData);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
