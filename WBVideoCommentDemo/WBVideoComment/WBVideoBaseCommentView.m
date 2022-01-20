//
//  WBVideoBaseCommentView.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "WBVideoBaseCommentView.h"

@implementation WBVideoBaseCommentView

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - WBVideoBaseCommentViewProtocol
- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)prepareForReuse {
    
}

- (void)prepareForHidden {
    
}

- (CGFloat)heightForViewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentViewProtocol> *)object {
    return 0.f;
}

- (void)updateViewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentViewProtocol> *)object {
    
}

@end
