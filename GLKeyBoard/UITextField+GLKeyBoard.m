//
//  UITextField+GLKeyBoard.m
//  GLKeyBoard
//
//  Created by 高磊 on 2017/5/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "UITextField+GLKeyBoard.h"

@implementation UITextField (GLKeyBoard)

- (void)updateText:(NSString *)text
{
    if ([text isEqualToString:@"千"]) {
        [self changeTextWithNumber:1000];
    }else if ([text isEqualToString:@"万"]){
        [self changeTextWithNumber:10000];
    }else if ([text isEqualToString:@"十万"]){
        [self changeTextWithNumber:100000];
    }else if ([text isEqualToString:@"百万"]){
        [self changeTextWithNumber:1000000];
    }
    else{
        UITextPosition *beginning = self.beginningOfDocument;//文字的开始地方
        UITextPosition *startPosition = self.selectedTextRange.start;//光标开始位置
        UITextPosition *endPosition = self.selectedTextRange.end;//光标结束位置
        NSInteger startIndex = [self offsetFromPosition:beginning toPosition:startPosition];//获取光标开始位置在文字中所在的index
        NSInteger endIndex = [self offsetFromPosition:beginning toPosition:endPosition];//获取光标结束位置在文字中所在的index
        
        // 将输入框中的文字分成两部分，生成新字符串，判断新字符串是否满足要求
        NSString *originText = self.text;
        NSString *beforeString = [originText substringToIndex:startIndex];//从起始位置到当前index
        NSString *afterString = [originText substringFromIndex:endIndex];//从光标结束位置到末尾
        
        NSInteger offset;
        
        if (![text isEqualToString:@""]) {
            offset = text.length;
        } else {
            // 只删除一个字符
            if (startIndex == endIndex) {
                if (startIndex == 0) {
                    return;
                }
                offset = -1;
                beforeString = [beforeString substringToIndex:(beforeString.length - 1)];
            } else {
                //光标选中多个
                offset = 0;
            }
        }
        
        NSString *newText = [NSString stringWithFormat:@"%@%@%@", beforeString, text, afterString];
        self.text = newText;
        
        // 重置光标位置
        UITextPosition *nowPosition = [self positionFromPosition:startPosition offset:offset];
        UITextRange *range = [self textRangeFromPosition:nowPosition toPosition:nowPosition];
        self.selectedTextRange = range;
    }
}

- (void)changeTextWithNumber:(NSInteger)number
{
    if (self.text.length > 0 && [self.text integerValue] > 0) {
        self.text = [NSString stringWithFormat:@"%ld",[self.text integerValue] * number];
    }else{
        self.text = [NSString stringWithFormat:@"%ld",number];
    }
}

@end
