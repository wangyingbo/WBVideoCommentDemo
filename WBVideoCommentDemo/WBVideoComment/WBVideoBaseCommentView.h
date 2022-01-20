//
//  WBVideoBaseCommentView.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import <UIKit/UIKit.h>
#import "WBVideoBaseCommentObject.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoBaseCommentViewProtocol <NSObject>
- (NSString *)reuseIdentifier;
- (void)prepareForReuse;
- (void)prepareForHidden;
@required
- (CGFloat)heightForViewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object;
- (void)updateViewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object;
@end


@interface WBVideoBaseCommentView : UIView<WBVideoBaseCommentViewProtocol>

@end

NS_ASSUME_NONNULL_END
