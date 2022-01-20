//
//  WBVideoBaseCommentModel.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol WBVideoBaseCommentViewProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface WBVideoBaseCommonInfo : NSObject
@property (nonatomic, assign) CGFloat maxWidth;
@end

@protocol WBVideoBaseCommentObjectProtocol <NSObject>
@end

@interface WBVideoBaseCommentObject : NSObject<WBVideoBaseCommentObjectProtocol>
@property (nonatomic, strong) id model;
@property (nonatomic, strong) WBVideoBaseCommonInfo *commonInfo;

@end

NS_ASSUME_NONNULL_END
