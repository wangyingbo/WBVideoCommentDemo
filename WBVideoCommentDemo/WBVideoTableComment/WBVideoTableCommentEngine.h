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
- (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)getNextObject;
- (void)nextObjectToRect:(CGRect)rect duration:(NSTimeInterval)duration;
@optional
- (void)didAutoShowNextObject;
@end

typedef void(^UpdateValueBlock)(CGFloat value);

@interface WBVideoTableCommentEngine : NSObject<WBVideoTableCommentEngineProtocol>
@property (nonatomic, weak) UITableView *tableView;
@property(nonatomic) UIEdgeInsets contentInset;
- (void)updateAllObjects:(NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)objects;
- (NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)startPlayInitialObjects;
@end

NS_ASSUME_NONNULL_END
