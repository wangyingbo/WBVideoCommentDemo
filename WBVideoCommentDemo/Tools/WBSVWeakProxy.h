//
//  WBSVWeakProxy.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBSVWeakProxy : NSProxy
@property (nonatomic, weak, readonly, nullable) id target;

- (nonnull instancetype)initWithTarget:(nonnull id)target;
+ (nonnull instancetype)proxyWithTarget:(nonnull id)target;
@end

NS_ASSUME_NONNULL_END
