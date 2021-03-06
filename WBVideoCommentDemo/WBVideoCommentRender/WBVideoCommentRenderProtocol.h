//
//  WBVideoCommentRenderProtocol.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef WBVideoRGBColor
#define WBVideoRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#endif

#ifndef WBVideoRandomColor
#define WBVideoRandomColor WBVideoRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#endif


@protocol WBVideoCommentRenderProtocol <NSObject>
/**scroll from first*/
@property (nonatomic, assign) BOOL scrollFromFirstObject;
/**the timer interval,when you want to change the timer interval, you must call -setTimeInterval method before call the -startPlay method;*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**the scroll animation duration when scroll a item*/
@property (nonatomic, assign) NSTimeInterval scrollAnimationDuration;
/**prevent auto scroll to next*/
@property (nonatomic, assign) BOOL preventAutoScroll;


- (void)reset;
- (void)updateWithDatas:(NSArray *)datas;
- (void)startPlay;
- (void)manualScrollToNextOnce;
@end

NS_ASSUME_NONNULL_END
