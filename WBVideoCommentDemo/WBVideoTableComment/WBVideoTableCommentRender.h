//
//  WBVideoTableCommentRender.h
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import <UIKit/UIKit.h>
#import "WBVideoTableCommentOjbect.h"
#import "WBVideoTableCommentCell.h"
@class WBVideoTableCommentRender;

NS_ASSUME_NONNULL_BEGIN

@protocol WBVideoTableCommentRenderDelegate <NSObject>

- (void)render:(WBVideoTableCommentRender *)render data:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)data tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cell:(WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *)cell;

@end
typedef void(^RegisterCellClassBlock)(Class class, NSString *identifer);

@interface WBVideoTableCommentRender : UIView
@property (nonatomic, copy) void(^registerTableCellClassBlock)(RegisterCellClassBlock registerCellBlock);
@property (nonatomic, weak) id<WBVideoTableCommentRenderDelegate> delegate;
/**
 TableView scrolls by calculating, Default is NO;
 If return value is NO, use tableView -scrollToRowAtIndexPath:atScrollPosition: to scroll, but the time interval can't be controled;
 */
@property (nonatomic, assign) BOOL scrollByCalculated;


- (void)updateWithDatas:(NSArray<WBVideoTableCommentOjbect *> *)datas;
- (void)startPlay;
@end

NS_ASSUME_NONNULL_END
