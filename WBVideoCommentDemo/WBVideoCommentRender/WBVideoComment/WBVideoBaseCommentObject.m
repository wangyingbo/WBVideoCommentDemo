//
//  WBVideoBaseCommentObject.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "WBVideoBaseCommentObject.h"
#import "WBVideoBaseCommentObject+Private.h"
#import "WBVideoBaseCommentView.h"

@implementation WBVideoBaseCommentObject
- (WBVideoBaseCommonInfo *)commonInfo {
    if (!_commonInfo) {
        _commonInfo = [[WBVideoBaseCommonInfo alloc] init];
    }
    return _commonInfo;
}

- (NSString *)_validCellReuseIdentifier {
    NSString *identifier = nil;
    if ([self respondsToSelector:@selector(reuseIdentifier)]) {
        identifier = [self reuseIdentifier];
    }
    Class<WBVideoBaseCommentViewProtocol> cellClass = [self _validCellClass];
    if (!identifier && [cellClass respondsToSelector:@selector(reuseIdentifier)]) {
        identifier = [cellClass reuseIdentifier];
    }
    return identifier;
}

- (Class<WBVideoBaseCommentViewProtocol>)_validCellClass {
    if ([self respondsToSelector:@selector(cellClass)]) {
        return [self cellClass];
    }
    return nil;
}


@end

@implementation WBVideoBaseCommonInfo



@end
