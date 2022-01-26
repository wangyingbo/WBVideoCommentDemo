//
//  WBVideoCommentEngine.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "WBVideoCommentEngine.h"
#import "WBVideoCommentRender.h"
#import "WBVideoBaseCommentView.h"
#import "WBVideoBaseCommentObject.h"
#import "WBVideoBaseCommentObject+Private.h"

@interface WBVideoComment ()
@property (nonatomic, strong) __kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView;
@property (nonatomic, strong) __kindof WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *object;
@end
@implementation WBVideoComment

@end

@interface WBVideoCommentEngine ()
@property (nonatomic, strong) NSMutableArray<WBVideoBaseCommentObject *> *totalDatas;
@property (nonatomic, strong) NSMutableArray<WBVideoComment *> *visibleComments;
@property (nonatomic, weak) WBVideoBaseCommentObject *tail;//游走指针，指向最后一个添加的数据

@end
@implementation WBVideoCommentEngine
@synthesize scrollFromFirstObject = _scrollFromFirstObject;
@synthesize scrollAnimationDuration = _scrollAnimationDuration;

#pragma mark - getter
- (NSMutableArray<WBVideoBaseCommentObject *> *)totalDatas {
    if (!_totalDatas) {
        _totalDatas = [NSMutableArray array];
    }
    return _totalDatas;
}

- (NSMutableArray<WBVideoComment *> *)visibleComments {
    if (!_visibleComments) {
        _visibleComments = [NSMutableArray array];
    }
    return _visibleComments;
}

- (NSMutableDictionary<NSString *,NSArray<WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *> *> *)reuseViewsDict {
    if (!_reuseViewsDict) {
        _reuseViewsDict = [NSMutableDictionary dictionary];
    }
    return _reuseViewsDict;
}

#pragma mark - public
- (void)updateWithDatas:(NSArray<WBVideoBaseCommentObject *> *)datas {
    [self _resetData];
    if (datas.count) {
        [self.totalDatas addObjectsFromArray:datas];
    }
}

- (void)startPlay {
    [self _startGetVisibleComments];
}

#pragma mark - private
- (void)_resetData {
    if (_totalDatas.count) {
        [self.totalDatas removeAllObjects];
    }
    if (self.tail) {
        self.tail = nil;
    }
}
- (void)_startGetVisibleComments {
    if (self.visibleComments.count) {
        [self.visibleComments removeAllObjects];
    }
    
    if ([self respondsToSelector:@selector(scrollFromFirstObject)]) {
        if (self.scrollFromFirstObject) {
            return;
        }
    }
    
    CGFloat visibleViewsHeight = 0.f;
    WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *lastCommentView = nil;
    for (WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *object in self.totalDatas) {
        if (![object isKindOfClass:[WBVideoBaseCommentObject class]]) {
            continue;
        }
        float perCommentHeight = 0;
        WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView = nil;
        commentView = [self _getCommentViewWithModel:object];
        if (!commentView) {
            continue;
        }
        perCommentHeight = [self _getCommentViewHeightWithCommentView:commentView model:object];
        commentView.frame = CGRectMake(0, CGRectGetMaxY(lastCommentView.frame), object.commonInfo.maxWidth, perCommentHeight);
        [self.render addSubview:commentView];
        lastCommentView = commentView;
        visibleViewsHeight += perCommentHeight;
        self.tail = object;
        
        WBVideoComment *comment = [[WBVideoComment alloc] init];
        comment.commentView = commentView;
        comment.object = object;
        [self.visibleComments addObject:comment];
        
        CGFloat restSpace = CGRectGetHeight(self.render.frame) - CGRectGetMaxY(commentView.frame);
        NSTimeInterval duration = .5f;
        if ([self respondsToSelector:@selector(scrollAnimationDuration)]) {
            duration = self.scrollAnimationDuration;
        }
        [self _visibleViewMove:restSpace duration:duration completion:nil];
        
        if (visibleViewsHeight > self.render.frame.size.height) {
            return;
        }
        if ([self respondsToSelector:@selector(scrollFromFirstObject)]) {
            if (self.scrollFromFirstObject && visibleViewsHeight > 1e-4) {
                break;
            }
        }
    }
}

- (CGFloat)_getCommentViewHeightWithCommentView:(WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)commentView model:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object {
    if (object && [object.cellClass respondsToSelector:@selector(heightForViewWithObject:)]) {
        return [object.cellClass heightForViewWithObject:object];
    }
    return 0.f;
}

- (WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)_getCommentViewWithModel:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object {
    WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewWithObject:)]) {
        commentView = [self.delegate viewWithObject:object];
    }
    NSAssert(commentView, @"commentView is nil");
    if (!commentView) {
        return nil;
    }
    
    if (commentView && [commentView respondsToSelector:@selector(updateViewWithObject:)]) {
        [commentView updateViewWithObject:object];
        
    }
    return commentView;
}

- (WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)_getNextObject {
    if (!self.totalDatas.count) {
        return nil;
    }
    if (!_tail) {
        return [self.totalDatas firstObject];
    }
    WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *nextObject = nil;
    NSInteger index = [self.totalDatas indexOfObject:self.tail];
    if (index+1 >= self.totalDatas.count) {
        nextObject = (WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)[self.totalDatas firstObject];
    }else if (index+1 < self.totalDatas.count) {
        nextObject = (WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)[self.totalDatas objectAtIndex:index+1];
    }
    if (!nextObject) {
        return nil;
    }
    return nextObject;
}

- (void)_handleAutoShowNextComment {
    WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *nextObject = [self _getNextObject];
    if (!nextObject) {
        return;
    }
    
    float perCommentHeight = 0;
    WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView = nil;
    commentView = [self _getCommentViewWithModel:nextObject];
    if (!commentView) {
        return;
    }
    perCommentHeight = [self _getCommentViewHeightWithCommentView:commentView model:nextObject];
    
    commentView.frame = CGRectMake(0, CGRectGetHeight(self.render.frame), nextObject.commonInfo.maxWidth, perCommentHeight);
    [self.render addSubview:commentView];
    
    WBVideoComment *comment = [[WBVideoComment alloc] init];
    comment.commentView = commentView;
    comment.object = nextObject;
    [self.visibleComments addObject:comment];
    NSTimeInterval duration = .5f;
    if ([self respondsToSelector:@selector(scrollAnimationDuration)]) {
        duration = self.scrollAnimationDuration;
    }
    [self _visibleViewMove:-perCommentHeight duration:duration completion:^{
        [self _filterVisibleViews];
    }];
    self.tail = nextObject;
}

- (void)_visibleViewMove:(CGFloat)space duration:(NSTimeInterval)duration completion:(void(^)(void))completion {
    for (NSInteger i = 0;i < self.visibleComments.count;i++) {
        WBVideoComment *comment = [self.visibleComments objectAtIndex:i];
        if (![comment isKindOfClass:[WBVideoComment class]]) {
            continue;
        }
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = comment.commentView.frame;
            frame.origin.y = frame.origin.y + space;
            comment.commentView.frame = frame;
        } completion:^(BOOL finished) {
            comment.suspend = (CGRectGetMaxY(comment.commentView.frame) < 0);
            if (i+1 == self.visibleComments.count) {
                !completion?:completion();
            }
        }];
    }
}

- (void)_filterVisibleViews {
    NSMutableArray *mutArray = [NSMutableArray array];
    for (WBVideoComment *comment in self.visibleComments) {
        if (![comment isKindOfClass:[WBVideoComment class]]) {
            continue;
        }
        if (!comment.suspend) {
            [mutArray addObject:comment];
            continue;
        }
        NSString *identifier = [comment.object _validCellReuseIdentifier];
        if (!identifier) {
            continue;
        }
        NSArray *reuseArr = [self.reuseViewsDict objectForKey:identifier];
        NSMutableArray *mutReuseArr = [NSMutableArray array];
        if (reuseArr && [reuseArr isKindOfClass:[NSArray class]]) {
            [mutReuseArr addObjectsFromArray:reuseArr];
        }
        if ([comment.commentView respondsToSelector:@selector(prepareForHidden)]) {
            [comment.commentView prepareForHidden];
        }
        [comment.commentView removeFromSuperview];
        [mutReuseArr addObject:comment.commentView];
        if (mutReuseArr.count) {
            [self.reuseViewsDict setObject:mutReuseArr forKey:identifier];
        }
    }
    self.visibleComments = mutArray;
}

#pragma mark - WBVideoCommentEngineProtocol
- (NSArray<WBVideoComment *> *)getVisibleComments {
    return [self.visibleComments copy];
}

- (void)showNextComment {
    [self _handleAutoShowNextComment];
}

@end
