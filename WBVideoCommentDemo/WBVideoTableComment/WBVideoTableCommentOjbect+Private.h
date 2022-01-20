//
//  WBVideoTableCommentOjbect+Private.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/20.
//

#import "WBVideoTableCommentOjbect.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBVideoTableCommentOjbect ()
- (NSString *)_validCellReuseIdentifier;
- (Class<WBVideoTableCommentCellProtocol>)_validCellClass;
@end

NS_ASSUME_NONNULL_END
