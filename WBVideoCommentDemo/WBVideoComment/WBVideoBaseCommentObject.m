//
//  WBVideoBaseCommentModel.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "WBVideoBaseCommentObject.h"

@implementation WBVideoBaseCommentObject
- (WBVideoBaseCommonInfo *)commonInfo {
    if (!_commonInfo) {
        _commonInfo = [[WBVideoBaseCommonInfo alloc] init];
    }
    return _commonInfo;
}
@end

@implementation WBVideoBaseCommonInfo



@end
