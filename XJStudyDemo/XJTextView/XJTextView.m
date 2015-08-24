//
//  XJTextView.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/21.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "XJTextView.h"
@interface XJTextView ()
@property (nonatomic, strong)UIView * placeholderView;
@property (nonatomic, strong)UILabel * placeholderLabel;
@end

@implementation XJTextView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (UIView *)placeholderView {
    if (!_placeholderView) {
        _placeholderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _placeholderView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer * tapgesyure =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginEditAction)];
        [_placeholderView addGestureRecognizer:tapgesyure];
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, self.bounds.size.width-4, self.bounds.size.width-4)];
        _placeholderLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1];
        _placeholderLabel.backgroundColor =[UIColor clearColor];
        [[self placeholderView] addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[self placeholderLabel]setText:placeholder];
    [[self placeholderLabel]sizeToFit];
}
- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholderViewStatus];
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [[self placeholderLabel] setFont:font];
}
- (void)textChanged:(NSNotification *)notice {
    [self updatePlaceholderViewStatus];
}
- (void)updatePlaceholderViewStatus {
    if (self.text.length > 0) {
        [[self placeholderView]setHidden:YES];
    }else{
        [[self placeholderView]setHidden:NO];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)beginEditAction{
    [self becomeFirstResponder];
}
@end
