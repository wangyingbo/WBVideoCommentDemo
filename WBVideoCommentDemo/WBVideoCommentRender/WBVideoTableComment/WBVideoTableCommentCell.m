//
//  WBVideoTableCommentCell.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "WBVideoTableCommentCell.h"

@implementation WBVideoTableCommentCell

#pragma mark - override
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - getter

#pragma mark - WBVideoTableCommentCellProtocol
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)heightForCellWithObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)object {
    return 0.f;
}

- (void)updateCellWithObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)object {
    
}

@end
