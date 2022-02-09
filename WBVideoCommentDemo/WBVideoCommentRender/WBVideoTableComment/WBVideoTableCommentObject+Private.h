//
//  WBVideoTableCommentObject+Private.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/20.
//

#import "WBVideoTableCommentObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBVideoTableCommentObject ()
- (NSString *)_validCellReuseIdentifier;
- (Class<WBVideoTableCommentCellProtocol>)_validCellClass;
@end

NS_ASSUME_NONNULL_END
