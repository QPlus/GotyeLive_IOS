//
//  EmojiScanner.m
//  GotyeLiveDemo
//
//  Created by Nick on 16/1/15.
//  Copyright © 2016年 AiLiao. All rights reserved.
//

#import "EmojiScanner.h"
#import <UIKit/UIKit.h>

@implementation EmojiScanner

+ (NSAttributedString *)scanText:(NSString *)text
{
    if (text.length == 0) {
        return nil;
    }
    
    static NSString * pattern = @"\\[s[\\d]\\d?\\]";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    NSUInteger lastIdx = 0;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSTextCheckingResult* match in matches) {
        NSRange range = match.range;
        if (range.location > lastIdx) {
            NSString *string = [text substringWithRange:NSMakeRange(lastIdx, range.location - lastIdx)];
            [resultArray addObject:[[NSAttributedString alloc]initWithString:string]];
        }
        NSString *matchString = [text substringWithRange:[match rangeAtIndex:0]];
        NSString *imageName = [NSString stringWithFormat:@"smiley_%d", [[matchString substringWithRange:NSMakeRange(2, matchString.length - 3)]intValue]];
        NSAttributedString *attachment = [self imageWithName:imageName];
        if (attachment) {
            [resultArray addObject:attachment];
        }
        
        lastIdx = range.location + range.length;
    }
    
    if (lastIdx < text.length) {
        [resultArray addObject:[[NSAttributedString alloc]initWithString:[text substringFromIndex:lastIdx]]];
    }
    
    
    NSMutableAttributedString *resultString= [[NSMutableAttributedString alloc]init];
    [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultString appendAttributedString:obj];
    }];
    
    return resultString;
}

+ (NSAttributedString *)imageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    if (image == nil) {
        return nil;
    }
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, 18, 18);
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

@end
