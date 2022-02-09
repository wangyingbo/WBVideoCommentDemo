//
//  WBVideoTableCommentCell.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import <UIKit/UIKit.h>
#import "WBVideoTableCommentObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoTableCommentCellProtocol <NSObject>
+ (NSString *)reuseIdentifier;
@required
+ (CGFloat)heightForCellWithObject:(WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)object;
- (void)updateCellWithObject:(WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)object;
@optional
@end


@interface WBVideoTableCommentCell : UITableViewCell<WBVideoTableCommentCellProtocol>

@end

NS_ASSUME_NONNULL_END
