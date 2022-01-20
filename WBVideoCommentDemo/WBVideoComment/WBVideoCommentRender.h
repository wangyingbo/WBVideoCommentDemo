//
//  WBVideoCommentRender.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import <UIKit/UIKit.h>
#import "WBVideoCommentEngine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoCommentRenderDelegate <NSObject>
- (__kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)render:(WBVideoCommentRender *)render data:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)data;
@end

typedef WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol>* _Nullable (^WBVideoReuseCommentViewBlock)(NSString *identifier);

@interface WBVideoCommentRender : UIView
@property (nonatomic, copy) WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol>* (^instanceCommentViewBlock)(WBVideoReuseCommentViewBlock reuseBlock,WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *commentModel);

@property (nonatomic, weak) id<WBVideoCommentRenderDelegate> delegate;

- (WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)updateWithDatas:(NSArray<WBVideoBaseCommentObject *> *)datas;

- (void)startPlay;


@end

NS_ASSUME_NONNULL_END
