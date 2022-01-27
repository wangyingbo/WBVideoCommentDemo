//
//  WBVideoTableCommentEngine.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WBVideoTableCommentOjbect;
@protocol WBVideoTableCommentOjbectProtocol;

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoTableCommentEngineProtocol <NSObject>
@required
- (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)getNextObject;
- (void)adjustNextObjectRect:(CGRect)rect duration:(NSTimeInterval)duration;
@optional
- (void)didAutoShowNextObject;
/**首次加载时，是否从第一个开始滚*/
@property (nonatomic, assign) BOOL scrollFromFirstObject;
/**iOS11以下时，改变contentOffset是否使用自定义线性动画*/
@property (nonatomic, assign) BOOL linearAnimation;


@end

typedef void(^UpdateValueBlock)(CGFloat value);

@interface WBVideoTableCommentEngine : NSObject<WBVideoTableCommentEngineProtocol>
@property (nonatomic, weak) UITableView *tableView;
@property(nonatomic) UIEdgeInsets contentInset;
- (void)updateAllObjects:(NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)objects;
- (NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)startPlayInitialObjects;
@end

NS_ASSUME_NONNULL_END
