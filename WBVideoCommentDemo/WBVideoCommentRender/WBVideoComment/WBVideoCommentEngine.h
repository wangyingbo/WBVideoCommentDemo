//
//  WBVideoCommentEngine.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WBVideoBaseCommentView;
@class WBVideoBaseCommentObject;
@class WBVideoCommentRender;
@protocol WBVideoBaseCommentViewProtocol;
@protocol WBVideoBaseCommentObjectProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface WBVideoComment : NSObject
@property (nonatomic, assign) BOOL suspend;

@property (nonatomic, strong, readonly) __kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView;
@property (nonatomic, strong, readonly) __kindof WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *object;

@end



@protocol WBVideoCommentEngineDelegate <NSObject>
- (__kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)viewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object;
@end

@protocol WBVideoCommentEngineProtocol <NSObject>
- (NSArray<WBVideoComment *> *)getVisibleComments;
- (void)showNextComment;
/**首次加载时，是否从第一个开始滚*/
@property (nonatomic, assign) BOOL scrollFromFirstObject;
/**the scroll animation duration when scroll a item*/
@property (nonatomic, assign) NSTimeInterval scrollAnimationDuration;
@end

@interface WBVideoCommentEngine : NSObject<WBVideoCommentEngineProtocol>
@property (nonatomic, weak) WBVideoCommentRender *render;
@property (nonatomic, weak) id<WBVideoCommentEngineDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *> *> *reuseViewsDict;

- (void)updateWithDatas:(NSArray<WBVideoBaseCommentObject*> *)datas;
- (void)startPlay;
@end

NS_ASSUME_NONNULL_END
