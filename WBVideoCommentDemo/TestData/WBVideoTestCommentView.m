//
//  WBVideoTestCommentView.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "WBVideoTestCommentView.h"
#import "WBVideoTestData.h"

@interface WBVideoTestCommentView ()
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) WBVideoBaseCommentObject<WBVideoBaseCommentViewProtocol> *object;
@end

@implementation WBVideoTestCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentLabel.numberOfLines = 0;
        _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _commentLabel;
}

- (void)initUI {
    [self addSubview:self.commentLabel];
}

- (void)layoutSubviews {
    CGFloat commentH = [self _getCommentsHeightWithObject:self.object];
    self.commentLabel.frame = CGRectMake(0, 0, self.object.commonInfo.maxWidth, commentH);
}

#pragma mark - WBVideoBaseCommentViewProtocol
- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)prepareForReuse {
    
}

- (CGFloat)heightForViewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentViewProtocol> *)object {
    return [self _getCommentsHeightWithObject:object];
}

- (void)updateViewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentViewProtocol> *)object {
    self.object = object;
    WBVideoTestData *model = object.model;

    self.commentLabel.text = model.content?:@"";
    self.commentLabel.font = model.font?:[UIFont systemFontOfSize:14.f];
    self.commentLabel.textColor = [UIColor redColor];
}

- (CGFloat)_getCommentsHeightWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentViewProtocol> *)object {
    if (!object) {
        return 0.f;
    }
    WBVideoTestData *model = object.model;
    CGSize strSize = [model.content boundingRectWithSize:CGSizeMake(object.commonInfo.maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:model.font} context:nil].size;
    return strSize.height;
}

@end
