//
//  WBVideoTestData.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/20.
//

#import "WBVideoTestData.h"

@implementation WBVideoTestData
- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:14.f];
    }
    return _font;
}
@end
