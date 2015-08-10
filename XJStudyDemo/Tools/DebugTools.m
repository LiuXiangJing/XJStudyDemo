//
//  DebugTools.m
//  XJStudyDemo
//
//  Created by 刘向晶 on 15/8/4.
//  Copyright (c) 2015年 刘向晶. All rights reserved.
//

#import "DebugTools.h"

@implementation DebugTools
// Show the tree
+ (void)logViewTreeForMainWindow:(UIView *)view
{
    //  CFShow([self displayViews: self.window]);
    NSLog(@"The view tree:\n%@", [self displayViews:view]);
}

+ (void)dumpView:(UIView *)aView atIndent:(int)indent into:(NSMutableString *)outstring
{
    for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
    [outstring appendFormat:@"[%2d] %@\n", indent, [[aView class] description]];
    for (UIView *view in [aView subviews])
    [self dumpView:view atIndent:indent + 1 into:outstring];
}
// Start the tree recursion at level 0 with the root view
+ (NSString *) displayViews: (UIView *) aView
{
    NSMutableString *outstring = [[NSMutableString alloc] init];
    [self dumpView: aView atIndent:0 into:outstring];
    return outstring ;
}

@end
