//
//  XJSearchBar.h
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/5.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol XJSearchBarDelegate;
@class UITextField, UILabel, UIButton, UIColor;
/**
 *  XJSearchBar是一个简单的搜索框，其结构是就是一个View(本身)上放一个背景ImageView 再放backgroundVew 上面有一个输入框TextField、一个placeholder的View(一个imageView 一个label) 和开始编辑的button  左侧 一个取消按钮Button
 */
@interface XJSearchBar : UIView<UITextInputTraits>
@property(nonatomic,assign) id<XJSearchBarDelegate> delegate;
@property(nonatomic,copy)   NSString               *text;                       // current/starting search text
@property(nonatomic,copy)   NSString               *placeholder;                // default is nil
@property(nonatomic)        BOOL                    showsCancelButton;          // default is NO
/**
 *  比一般的UISearchBar多一个属性，设置placeholder的居左显示还是居中显示。。。
 */
@property(nonatomic)        BOOL                    placeholderAlignmentLeft;   //default is NO
@property(nonatomic,retain) UIImage                *backgroundImage;            //default is nil

@end
@protocol XJSearchBarDelegate <NSObject>
@optional
- (BOOL)searchBarShouldBeginEditing:(XJSearchBar *)searchBar;                      // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(XJSearchBar *)searchBar;                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(XJSearchBar *)searchBar;                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(XJSearchBar *)searchBar;                       // called when text ends editing
- (void)searchBar:(XJSearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
- (BOOL)searchBar:(XJSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; // called before text changes

- (void)searchBarSearchButtonClicked:(XJSearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(XJSearchBar *)searchBar;                     // called when cancel button pressed

@end