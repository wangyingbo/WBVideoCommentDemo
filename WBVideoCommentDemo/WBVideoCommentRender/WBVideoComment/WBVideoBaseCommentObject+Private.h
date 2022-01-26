//
//  WBVideoBaseCommentObject+Private.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/26.
//

#import "WBVideoBaseCommentObject.h"
@protocol WBVideoBaseCommentViewProtocol;

NS_ASSUME_NONNULL_BEGIN


@interface WBVideoBaseCommentObject ()
- (NSString *)_validCellReuseIdentifier;
- (Class<WBVideoBaseCommentViewProtocol>)_validCellClass;
@end

NS_ASSUME_NONNULL_END
