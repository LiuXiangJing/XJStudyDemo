//
//  XJSearchBar.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/5.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//


#import "XJSearchBar.h"
@interface XJSearchBar ()<UITextFieldDelegate>
{
    CGSize searchBarSize;
    
    BOOL isEditing;//是否是在编辑中
    BOOL isFirstTimeTextGrow;//当textField开始编辑时，text增长的第一次，标记为YES ,用来placholdView左移动

}
@property(nonatomic,strong)UIImageView  * backgroundImageView;
/**
 *  在backgroundImageView之上，subView有：searchTextField,beignSearchButton,placeholderView
 */
@property(nonatomic,strong)UIView       * backgroundView;

@property(nonatomic,strong)UITextField  * searchTextField;
@property(nonatomic,strong)UIButton     * searchCancleButton;

@property(nonatomic,strong)UIButton     * beignSearchButton;//开始搜索的按钮
@property(nonatomic,strong)UIView       * placeholderView;
@property(nonatomic,strong)UIImageView  * iconImageView;//放大镜
@property(nonatomic,strong)UILabel      * placeholderLabel;

@end

#define iconSize 15 //放大镜的大小
#define spacing 5 //间距
#define cancelBtnWidth 50

@implementation XJSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        searchBarSize = frame.size;
        [self initView];
    }
    return self;
}
- (instancetype)init{
    self =[super init];
    if (self) {
        [self initView];
    }
    return self;
}
#pragma mark - 直接添加了所有的界面-并按次序
-(void)initView{
    
    [self backgroundImageView];//最下面的背景图。。大小同self
    [self backgroundView]; //底部背景View 大小是self-取消按钮。当没有取消按钮的时候同 self
    [self searchTextField]; //搜索框
    [self searchCancleButton];//取消按钮
    [self placeholderView];// 显示放大镜和placer的View，大小是iconImage和placeholder的和 注意。！= backgroundView的大小
    [self iconImageView];//放大镜
    [self placeholderLabel];//placeholder
    [self beignSearchButton];//在最上层大小同backgroundView 他是在（text有值）隐藏，（text为空）显示
    [self setShowsCancelButton:NO];
    [self setPlaceholderAlignmentLeft:NO];
    isFirstTimeTextGrow =YES;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    searchBarSize =frame.size;
    [self displayAllView];
}
#pragma mark - get methods SubViews
-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView =[[UIImageView alloc]initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor =[UIColor clearColor];
        [self addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, searchBarSize.width, searchBarSize.height)];
        _backgroundView.backgroundColor =[UIColor whiteColor];
        _backgroundView.layer.cornerRadius = 2;
        _backgroundView.layer.masksToBounds =YES;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}
- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(iconSize+2*spacing, 0, searchBarSize.width, searchBarSize.height)];
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.backgroundColor = [UIColor whiteColor];
        _searchTextField.delegate = self;
        _searchTextField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        _searchTextField.layer.cornerRadius =2;
        _searchTextField.layer.masksToBounds =YES;
        _searchTextField.textColor =[UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1];
        _searchTextField.font =[UIFont systemFontOfSize:15];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [[self backgroundView] addSubview:_searchTextField];
    }
    return _searchTextField;
}
- (UIView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView =[[UIView alloc]initWithFrame:CGRectZero];
        _placeholderView.backgroundColor =[UIColor clearColor];
        [[self backgroundView] addSubview:_placeholderView];
    }
    return _placeholderView;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
        _iconImageView.center =CGPointMake(_iconImageView.center.x+spacing, searchBarSize.height/2);
        [[self placeholderView] addSubview:_iconImageView];
    }
    return _iconImageView;
}
- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
//        CGFloat orX =[self iconImageView].frame.size.width+spacing;
        _placeholderLabel =[[UILabel alloc]initWithFrame:CGRectMake(spacing*2+iconSize, 0, 20, searchBarSize.height)];
        _placeholderLabel.font =[UIFont systemFontOfSize:15];
        _placeholderLabel.textColor =[UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1];
        _placeholderLabel.backgroundColor =[UIColor clearColor];
        [[self placeholderView] addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}
- (UIButton *)searchCancleButton{
    if (!_searchCancleButton) {
        _searchCancleButton =[UIButton buttonWithType:UIButtonTypeSystem];
        [_searchCancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_searchCancleButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_searchCancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchCancleButton addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_searchCancleButton];
    }
    return _searchCancleButton;
}
- (UIButton *)beignSearchButton{
    if (!_beignSearchButton) {
        _beignSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beignSearchButton.frame =[self backgroundView].bounds;
        [_beignSearchButton setBackgroundColor:[UIColor clearColor]];
        [_beignSearchButton addTarget:self action:@selector(textFieldBeginEdit) forControlEvents:UIControlEventTouchUpInside];
        [[self backgroundView] addSubview:_beignSearchButton];
    }
    return _beignSearchButton;
}
#pragma mark - set methods
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    [[self backgroundImageView] setImage:_backgroundImage];
    [self displayAllView];
}
#pragma mark 在外面调用设置text;
- (void)setText:(NSString *)text{
    
    [self setTextFieldTextFromSelf:text];
    if (isFirstTimeTextGrow) {
        [self placerholderViewMoveToLeft];
        [[self searchTextField]setText:_text];
    }
}
#pragma mark 在本类内部调用设置的 私有方法
-(void)setTextFieldTextFromSelf:(NSString *)text{
    _text = text;
}
- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    if (_placeholder && _placeholder.length>0) {
        [[self placeholderLabel] setText:placeholder];
        [[self placeholderLabel] sizeToFit];
        CGRect labelFrame =[self placeholderLabel].frame;
        [[self placeholderLabel]setFrame:CGRectMake(labelFrame.origin.x, labelFrame.origin.y, labelFrame.size.width, searchBarSize.height)];
        [self placerholderViewMoveToCenter];
    }
    [self displayAllView];
//#warning 这个得更新下placeholderView得UI
}
- (void)setShowsCancelButton:(BOOL)showsCancelButton{
    _showsCancelButton = showsCancelButton;
     [self displayAllView];
    if (_placeholderAlignmentLeft) {
        [self placerholderViewMoveToLeft];
    }else{
        [self placerholderViewMoveToCenter];
    }
//#warning 这里得更新下textField和取消button的UI
}
- (void)setPlaceholderAlignmentLeft:(BOOL)placeholderAlignmentLeft{
    _placeholderAlignmentLeft = placeholderAlignmentLeft;
//#warning 这里更新下placeholderView得位置
    if (_placeholderAlignmentLeft) {
        [self placerholderViewMoveToLeft];
    }else{
        [self placerholderViewMoveToCenter];
    }
    [self displayAllView];
}
#pragma mark-所有的界面显示出来
-(void)displayAllView{
    if (_backgroundImage) {
        [[self backgroundView] setBackgroundColor:[UIColor clearColor]];
        [[self backgroundImageView] setFrame:self.bounds];
    }else{
       [[self backgroundView] setBackgroundColor:[UIColor whiteColor]];
    }
    if (_showsCancelButton) {
        [[self backgroundView] setFrame:CGRectMake(0, 0, searchBarSize.width-cancelBtnWidth, searchBarSize.height)];
      
    }else{
        [[self backgroundView] setFrame:CGRectMake(0, 0, searchBarSize.width, searchBarSize.height)];
    }
    if (_showsCancelButton) {
        [[self searchTextField] setFrame:CGRectMake(iconSize+spacing*2, 0,searchBarSize.width - spacing*2-cancelBtnWidth-iconSize, searchBarSize.height)];
        [[self searchCancleButton] setFrame:CGRectMake(searchBarSize.width-cancelBtnWidth, 0, cancelBtnWidth, searchBarSize.height)];
         [[self searchCancleButton] setHidden:NO];
    }else{
        [[self searchTextField] setFrame:CGRectMake(iconSize+spacing*2, 0,searchBarSize.width-spacing-iconSize, searchBarSize.height)];
        [[self searchCancleButton] setHidden:YES];
    }
}
-(void)textFieldBeginEdit{
    
    if (![[self searchTextField] isFirstResponder]) {
        [[self searchTextField] becomeFirstResponder];
    }
    if (!self.placeholderAlignmentLeft) {
        [self placerholderViewMoveToLeft];
    }
}
#pragma mark 当内容为空时，开始编辑，placeholder左移动画
-(void)placerholderViewMoveToLeft{
    
    [UIView animateWithDuration:0.3 animations:^{
         CGFloat width =spacing*2+iconSize;
        if (!self.text || self.text.length ==0) {
            width = spacing * 2+iconSize+[self placeholderLabel].frame.size.width;
            [[self placeholderLabel] setHidden:NO];
        }else{
            [[self placeholderLabel] setHidden:YES];
        }
        [[self placeholderView] setFrame:CGRectMake(0, 0, width, searchBarSize.height)];
    }completion:^(BOOL finished) {
        if (finished) {
            if (self.text && self.text.length>0) {
                [[self beignSearchButton]setHidden:YES];
            }else{
                [[self beignSearchButton]setHidden:NO];
            }
        }
    }];
}
#pragma mark 当内容为空时，结束编辑，placeholder右移动画
-(void)placerholderViewMoveToCenter{
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat orX = 0; CGFloat width =spacing*2+iconSize;
        if (self.placeholderAlignmentLeft) {
            orX= 0;
            if (!self.text || self.text.length ==0) {
                [[self placeholderLabel] setHidden:NO];
                width =spacing * 2+iconSize+[self placeholderLabel].frame.size.width;
            }
        }else{
            if (!self.text || self.text.length ==0) {
                width =spacing * 2+iconSize+[self placeholderLabel].frame.size.width;
                orX =([self backgroundView].frame.size.width-width)/2;
            }else{
                 orX =0;
                 [[self placeholderLabel] setHidden:YES];
            }
        }
        [self placeholderView].frame =CGRectMake(orX, 0, width, searchBarSize.height);
    }completion:^(BOOL finished) {
        if (finished) {
            [[self beignSearchButton] setHidden:NO];
            [self bringSubviewToFront:[self beignSearchButton]];
        }
    }];
}
#pragma mark - 取消搜索
- (void)cancelSearchAction{
    if ([[self searchTextField]isFirstResponder]) {
        [[self searchTextField] resignFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [self.delegate searchBarCancelButtonClicked:self];
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL shouldEndEdit =YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        shouldEndEdit =  [self.delegate searchBarShouldBeginEditing:self];
    }
    
    return shouldEndEdit;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self placerholderViewMoveToLeft];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [self.delegate searchBarShouldEndEditing:self];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [self.delegate searchBarTextDidEndEditing:self];
    }
    [self placerholderViewMoveToCenter];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL canChange =YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        canChange = [self.delegate searchBar:self shouldChangeTextInRange:range replacementText:string];
    }
    if (canChange) {
        NSString * oryText;
        if ([string isEqualToString:@""]) {
            oryText =[textField.text stringByReplacingCharactersInRange:NSMakeRange(textField.text.length-1, 1) withString:@""];
        }else{
             oryText =  [textField.text stringByReplacingCharactersInRange:range withString:string];
        }
     
        if (oryText.length ==0) {
            isFirstTimeTextGrow = YES;
        }
        [self textFieldDidChangedText:oryText];
        if (oryText.length>0) {
            if (isFirstTimeTextGrow) {
                isFirstTimeTextGrow = NO;
            }
        }
    }
    return canChange;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    isFirstTimeTextGrow = YES;
    [self textFieldDidChangedText:@""];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self setTextFieldTextFromSelf:textField.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
      [self.delegate searchBarSearchButtonClicked:self];
    }
    return YES;
}
- (void)textFieldDidChangedText:(NSString *)text{
    [self setTextFieldTextFromSelf:text];
    if (isFirstTimeTextGrow) {
        [self placerholderViewMoveToLeft];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:text];
    }
}

#pragma mark - UITextInputTraits
-(void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType{
    [self searchTextField].autocapitalizationType =autocapitalizationType;
}
-(UITextAutocapitalizationType)autocapitalizationType{
    return [self searchTextField].autocapitalizationType;
}
-(void)setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType{
    [self searchTextField].autocorrectionType =autocorrectionType;
}
-(UITextAutocorrectionType)autocorrectionType{
    return [self searchTextField].autocorrectionType;
}
-(void)setSpellCheckingType:(UITextSpellCheckingType)spellCheckingType{
    
    [self searchTextField].spellCheckingType =spellCheckingType;
}
-(UITextSpellCheckingType)spellCheckingType{
    return [self searchTextField].spellCheckingType;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    [self searchTextField].keyboardType =keyboardType;
}
-(UIKeyboardType)keyboardType{
    return [self searchTextField].keyboardType;
}
- (void)setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance{
    [self searchTextField].keyboardAppearance=keyboardAppearance;
}
- (UIKeyboardAppearance)keyboardAppearance{
    return  [self searchTextField].keyboardAppearance;
}
- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType{
     [self searchTextField].returnKeyType = returnKeyType;
}
- (UIReturnKeyType)returnKeyType{
    return [self searchTextField].returnKeyType;
}
- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically{
    [self searchTextField].enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
}
- (BOOL)enablesReturnKeyAutomatically{
    return [self searchTextField].enablesReturnKeyAutomatically;
}
- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    [self searchTextField].secureTextEntry =secureTextEntry;
}
- (BOOL)isSecureTextEntry{
    return [self searchTextField].isSecureTextEntry;
}
@end
