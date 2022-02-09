//
//  WBVideoTableCommentEngine.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "WBVideoTableCommentEngine.h"
#import "WBVideoTableCommentObject.h"
#import "WBVideoTableCommentCell.h"
#import "WBVideoTableCommentObject+Private.h"

@interface WBVideoTableCommentEngine ()
@property (nonatomic, strong) NSMutableArray<WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *> *totalObjectsArray;
@property (nonatomic, weak) WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *wanderObject;//游走指针
@end

@implementation WBVideoTableCommentEngine
@synthesize scrollFromFirstObject = _scrollFromFirstObject;
@synthesize linearAnimation = _linearAnimation;

#pragma mark - getter
- (NSMutableArray<WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *> *)totalObjectsArray {
    if (!_totalObjectsArray) {
        _totalObjectsArray = [NSMutableArray array];
    }
    return _totalObjectsArray;
}

#pragma mark - public
- (void)updateAllObjects:(NSArray<WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *> *)objects {
    [self _resetData];
    if (objects.count) {
        [self.totalObjectsArray addObjectsFromArray:objects];
    }
}

- (NSArray<WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *> *)startPlayInitialObjects {
    return [self _handleVisibleObjects];
}

#pragma mark - private
- (void)_resetData {
    if (self.totalObjectsArray.count) {
        [self.totalObjectsArray removeAllObjects];
    }
    if (self.wanderObject) {
        self.wanderObject = nil;
    }
}

- (NSArray<WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *> *)_handleVisibleObjects {
    CGFloat visibleObjectHeight = 0.f;
    NSMutableArray *visibleObjectsMutArr = [NSMutableArray array];
    
    if ([self respondsToSelector:@selector(scrollFromFirstObject)]) {
        if (self.scrollFromFirstObject) {
            UIEdgeInsets inset = self.contentInset;
            inset.top = CGRectGetHeight(self.tableView.frame);
            self.tableView.contentInset = inset;
            [self _handleVisibleRectWithLastObjectBottom:CGRectGetMaxY(self.tableView.frame) updateContentInsetBlock:nil updateContentOffsetBlock:nil];
            return [visibleObjectsMutArr copy];
        }
    }
    
    for (WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *object in self.totalObjectsArray) {
        if (![object isKindOfClass:[WBVideoTableCommentObject class]]) {
            continue;
        }
        Class<WBVideoTableCommentCellProtocol> cellClass = [object _validCellClass];
        if (!cellClass) {
            continue;
        }
        CGFloat perObjectHeight = 0.f;
        if ([cellClass respondsToSelector:@selector(heightForCellWithObject:)]) {
            perObjectHeight = [cellClass heightForCellWithObject:object];
        }
        [visibleObjectsMutArr addObject:object];
        visibleObjectHeight += perObjectHeight;
        self.wanderObject = object;
        
        if (visibleObjectHeight > self.tableView.frame.size.height) {
            break;
        }
    }
    
    [self _handleVisibleRectWithLastObjectBottom:visibleObjectHeight updateContentInsetBlock:nil updateContentOffsetBlock:nil];
    return [visibleObjectsMutArr copy];
}

- (void)_handleVisibleRectWithLastObjectBottom:(CGFloat)bottom updateContentInsetBlock:(UpdateValueBlock)updateContentInsetBlock updateContentOffsetBlock:(UpdateValueBlock)updateContentOffsetBlock {
    CGFloat topInset = self.contentInset.top;
    CGFloat bottomInset = self.contentInset.bottom;
    CGFloat actualVisibleHeight = self.tableView.frame.size.height - topInset - bottomInset;
    CGFloat difference = bottom - actualVisibleHeight;
    CGFloat topInsetDifference = self.tableView.contentInset.top - topInset;
    CGFloat fix = difference - topInsetDifference;
    
    if (!updateContentInsetBlock) {
        updateContentInsetBlock = ^void(CGFloat value) {
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top += value;
            self.tableView.contentInset = inset;
        };
    }
    if (!updateContentOffsetBlock) {
        updateContentOffsetBlock = ^void(CGFloat value) {
            CGPoint originOffset = self.tableView.contentOffset;
            [self.tableView setContentOffset:CGPointMake(originOffset.x, (originOffset.y+value))];
        };
    }
    
    if (ABS(difference) < 1e-4) {
        return;
    }
    
    if (difference < 0) {
        updateContentInsetBlock(-difference);
        return;
    }
    
    //difference > 0，contentInset无偏移，直接滚动到合适位置；
    if (ABS(topInsetDifference) < 1e-4) {
        updateContentOffsetBlock(difference);
        return;
    }
    
    //difference > 0，且difference偏移量小于contentInset偏移量，直接调整偏移量即可；
    if (fix < 0) {
        updateContentInsetBlock(-difference);
        return;
    }
    
    //difference > 0，且difference比contentInset偏移量大，则先使contentInset偏移归位，再滚动；
    if (fix >= 0) {
        updateContentInsetBlock(-topInsetDifference);
        updateContentOffsetBlock(fix);
    }
    
}

- (WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)_getNextObject {
    if (!self.totalObjectsArray.count) {
        return nil;
    }
    if (!_wanderObject) {
        self.wanderObject = [self.totalObjectsArray firstObject];
        return [self.totalObjectsArray firstObject];
    }
    WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *nextObject = nil;
    NSInteger index = [self.totalObjectsArray indexOfObject:self.wanderObject];
    if (index+1 >= self.totalObjectsArray.count) {
        nextObject = (WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)[self.totalObjectsArray firstObject];
    }else if (index+1 < self.totalObjectsArray.count) {
        nextObject = (WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)[self.totalObjectsArray objectAtIndex:index+1];
    }
    if (!nextObject) {
        return nil;
    }
    self.wanderObject = nextObject;
    return nextObject;
}

- (void)_handleDidAutoShowNextObject {
    
}


#pragma mark - WBVideoTableCommentEngine

- (WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)getNextObject {
    return [self _getNextObject];
}

- (void)adjustNextObjectRect:(CGRect)rect duration:(NSTimeInterval)duration {
    CGRect convertRect = [self.tableView convertRect:rect fromView:self.tableView];
    [self _handleVisibleRectWithLastObjectBottom:CGRectGetMaxY(convertRect) updateContentInsetBlock:^(CGFloat value) {
        [UIView animateWithDuration:duration animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top += value;
            self.tableView.contentInset = inset;
        }];
    } updateContentOffsetBlock:^(CGFloat value) {
        if (@available(iOS 11.0, *)) {
            /**
             解决在UIView动画中setContentOffset导致的顶部的cell消失问题，详细问题描述见stackoverflow:
             https://stackoverflow.com/questions/4404745/change-the-speed-of-setcontentoffsetanimated
             */
            [UIView animateWithDuration:duration animations:^{
                CGPoint originOffset = self.tableView.contentOffset;
                [self.tableView setContentOffset:CGPointMake(originOffset.x, (originOffset.y+value)) animated:NO];
                [self.tableView layoutIfNeeded];
            }];
        }else {
            CGPoint originOffset = self.tableView.contentOffset;
            if (duration < 1e-4) {
                [self.tableView setContentOffset:CGPointMake(originOffset.x, (originOffset.y+value)) animated:NO];
                return;
            }
            if (duration <= 0.5f || value < 5.f) {
                [self.tableView setContentOffset:CGPointMake(originOffset.x, (originOffset.y+value)) animated:YES];
                return;
            }
            if ([self _isUseLinearAnimation]) {
                //模拟线性动画
                NSInteger scale = (value > 20 ? (value/20) : 1 );
                NSInteger times = (duration * 20) * scale;
                NSTimeInterval secTime = duration/times;
                NSTimeInterval secValue = value/times;
                for (NSInteger i = 0; i<times; i++) {
                    CGPoint newOffset = CGPointMake(originOffset.x, originOffset.y+secValue*i);
                    NSValue *offsetValue = [NSValue valueWithCGPoint:newOffset];
                    [self performSelector:@selector(_setContnetOffset:) withObject:offsetValue afterDelay:secTime*i];
                }
                return;
            }
            [self.tableView setContentOffset:CGPointMake(originOffset.x, (originOffset.y+value)) animated:YES];
        }
    }];
}

/// 是否使用自定义线性动画
- (BOOL)_isUseLinearAnimation {
    if ([self respondsToSelector:@selector(linearAnimation)]) {
        return self.linearAnimation;
    }
    return NO;
}

- (void)_setContnetOffset:(id)object {
    if (!self.tableView) { return; }
    if (![object isKindOfClass:[NSValue class]]) { return; }
    NSValue *offsetValue = (NSValue *)object;
    if (!offsetValue) { return; }
    CGPoint offset = [offsetValue CGPointValue];
    [self.tableView setContentOffset:offset];
    
}

- (void)didAutoShowNextObject {
    [self _handleDidAutoShowNextObject];
}

@end
