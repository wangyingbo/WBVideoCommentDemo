//
//  WBVideoTableCommentObject.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol WBVideoTableCommentCellProtocol;


NS_ASSUME_NONNULL_BEGIN

@interface WBVideoTableCommonInfo : NSObject
@property (nonatomic, assign) CGFloat maxWidth;
@end

@protocol WBVideoTableCommentObjectProtocol <NSObject>
- (NSString *)reuseIdentifier;
- (Class<WBVideoTableCommentCellProtocol>)cellClass;
@end

@interface WBVideoTableCommentObject : NSObject<WBVideoTableCommentObjectProtocol>
@property (nonatomic, strong) Class<WBVideoTableCommentCellProtocol> cellClass;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) id model;
@property (nonatomic, strong) WBVideoTableCommonInfo *commonInfo;
@end

NS_ASSUME_NONNULL_END
