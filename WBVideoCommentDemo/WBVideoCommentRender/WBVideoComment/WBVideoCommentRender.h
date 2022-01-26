//
//  WBVideoCommentRender.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import <UIKit/UIKit.h>
#import "WBVideoCommentEngine.h"
#import "WBVideoCommentRenderProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoCommentRenderDelegate <NSObject>
@optional
- (__kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)render:(WBVideoCommentRender *)render viewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object;
@end

typedef WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol>* _Nullable (^WBVideoReuseCommentViewBlock)(NSString *identifier);

@interface WBVideoCommentRender : UIView<WBVideoCommentRenderProtocol>
/**可不实现，内部会根据[view reuseIdentifier]自动复用*/
@property (nonatomic, copy) WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol>* (^instanceCommentViewBlock)(WBVideoReuseCommentViewBlock reuseBlock, WBVideoCommentRender *render, WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *object);

@property (nonatomic, weak) id<WBVideoCommentRenderDelegate> delegate;

- (WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)updateWithDatas:(NSArray<WBVideoBaseCommentObject *> *)datas;


@end

NS_ASSUME_NONNULL_END
