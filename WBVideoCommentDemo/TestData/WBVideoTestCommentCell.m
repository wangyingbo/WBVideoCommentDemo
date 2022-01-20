//
//  WBVideoTestCommentCell.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "WBVideoTestCommentCell.h"
#import "WBVideoTestData.h"

@interface WBVideoTestCommentCell ()
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *object;
@end
@implementation WBVideoTestCommentCell

#pragma mark - override

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.commentLabel];
}

- (void)layoutSubviews {
    CGFloat commentH = [WBVideoTestCommentCell _getCommentsHeightWithObject:self.object];
    self.commentLabel.frame = CGRectMake(0, 0, self.object.commonInfo.maxWidth, commentH);
}

#pragma mark - getter
- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.numberOfLines = 0;
        _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _commentLabel;
}

#pragma mark - WBVideoTableCommentCell
+ (CGFloat)heightForCellWithObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)object {
    return [WBVideoTestCommentCell _getCommentsHeightWithObject:object];
}

- (void)updateCellWithObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)object {
    self.object = object;
    WBVideoTestData *model = object.model;
    self.commentLabel.text = model.content?:@"";
    self.commentLabel.font = model.font?:[UIFont systemFontOfSize:14.f];
    self.commentLabel.textColor = [UIColor redColor];
}

+ (CGFloat)_getCommentsHeightWithObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)object {
    if (!object) {
        return 0.f;
    }
    WBVideoTestData *model = object.model;
    CGSize strSize = [model.content boundingRectWithSize:CGSizeMake(object.commonInfo.maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:model.font} context:nil].size;
    return strSize.height;
}

@end
