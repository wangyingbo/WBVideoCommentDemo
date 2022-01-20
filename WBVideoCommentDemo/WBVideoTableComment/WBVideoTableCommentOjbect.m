//
//  WBVideoTableCommentModel.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "WBVideoTableCommentOjbect.h"
#import "WBVideoTableCommentOjbect+Private.h"
#import "WBVideoTableCommentCell.h"

@implementation WBVideoTableCommentOjbect
- (WBVideoTableCommonInfo *)commonInfo {
    if (!_commonInfo) {
        _commonInfo = [[WBVideoTableCommonInfo alloc] init];
    }
    return _commonInfo;
}

- (Class<WBVideoTableCommentCellProtocol>)_validCellClass {
    if ([self respondsToSelector:@selector(cellClass)]) {
        return [self cellClass];
    }
    return nil;
}

- (NSString *)_validCellReuseIdentifier {
    NSString *identifier = nil;
    if ([self respondsToSelector:@selector(reuseIdentifier)]) {
        identifier = [self reuseIdentifier];
    }
    Class<WBVideoTableCommentCellProtocol> cellClass = [self _validCellClass];
    if (!identifier && [cellClass respondsToSelector:@selector(reuseIdentifier)]) {
        identifier = [cellClass reuseIdentifier];
    }
    return identifier;
}

@end

@implementation WBVideoTableCommonInfo



@end
