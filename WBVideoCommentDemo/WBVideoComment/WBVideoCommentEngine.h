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
@property (nonatomic, strong, readonly) __kindof WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *commentModel;

- (CGFloat)commentHeight;
- (void)updateData;
@end



@protocol WBVideoCommentEngineDelegate <NSObject>
- (__kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)viewWithData:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)commentModel;
@end

@protocol WBVideoCommentEngineProtocol <NSObject>
- (NSArray<WBVideoComment *> *)getVisibleComments;
- (void)showNextComment;
@end

@interface WBVideoCommentEngine : NSObject<WBVideoCommentEngineProtocol>
@property (nonatomic, weak) WBVideoCommentRender *render;
@property (nonatomic, weak) id<WBVideoCommentEngineDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *> *> *reuseViewsDict;

- (void)updateWithDatas:(NSArray<WBVideoBaseCommentObject*> *)datas;
- (void)startPlay;
@end

NS_ASSUME_NONNULL_END
