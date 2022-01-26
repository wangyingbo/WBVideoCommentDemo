//
//  WBVideoCommentRenderProtocol.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoCommentRenderProtocol <NSObject>
/**scroll from first*/
@property (nonatomic, assign) BOOL scrollFromFirstObject;
/**the timer interval,when you want to change the timer interval, you must call the -setTimeInterval before call -startPlay method;*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**the scroll animation duration when scroll a item*/
@property (nonatomic, assign) NSTimeInterval scrollAnimationDuration;


- (void)updateWithDatas:(NSArray *)datas;
- (void)startPlay;
@end

NS_ASSUME_NONNULL_END
