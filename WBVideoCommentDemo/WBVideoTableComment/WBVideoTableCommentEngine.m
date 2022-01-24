//
//  WBVideoTableCommentEngine.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "WBVideoTableCommentEngine.h"
#import "WBVideoTableCommentOjbect.h"
#import "WBVideoTableCommentCell.h"
#import "WBVideoTableCommentOjbect+Private.h"

@interface WBVideoTableCommentEngine ()
@property (nonatomic, strong) NSMutableArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *totalObjectsArray;
@property (nonatomic, weak) WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *wanderObject;//游走指针
@end

@implementation WBVideoTableCommentEngine

#pragma mark - getter
- (NSMutableArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)totalObjectsArray {
    if (!_totalObjectsArray) {
        _totalObjectsArray = [NSMutableArray array];
    }
    return _totalObjectsArray;
}

#pragma mark - public
- (void)updateAllObjects:(NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)objects {
    [self _resetData];
    if (objects.count) {
        [self.totalObjectsArray addObjectsFromArray:objects];
    }
}

- (NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)startPlayInitialObjects {
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

- (NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *)_handleVisibleObjects {
    CGFloat visibleObjectHeight = 0.f;
    NSMutableArray *visibleObjectsMutArr = [NSMutableArray array];
    for (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *object in self.totalObjectsArray) {
        if (![object isKindOfClass:[WBVideoTableCommentOjbect class]]) {
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

- (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)_getNextObject {
    if (!self.totalObjectsArray.count) {
        return nil;
    }
    if (!_wanderObject) {
        return [self.totalObjectsArray firstObject];
    }
    WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *nextObject = nil;
    NSInteger index = [self.totalObjectsArray indexOfObject:self.wanderObject];
    if (index+1 >= self.totalObjectsArray.count) {
        nextObject = (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)[self.totalObjectsArray firstObject];
    }else if (index+1 < self.totalObjectsArray.count) {
        nextObject = (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)[self.totalObjectsArray objectAtIndex:index+1];
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

- (WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)getNextObject {
    return [self _getNextObject];
}

- (void)nextObjectToRect:(CGRect)rect duration:(NSTimeInterval)duration {
    [self _handleVisibleRectWithLastObjectBottom:CGRectGetMaxY(rect) updateContentInsetBlock:^(CGFloat value) {
        [UIView animateWithDuration:duration animations:^{
            UIEdgeInsets inset = self.tableView.contentInset;
            inset.top += value;
            self.tableView.contentInset = inset;
        }];
    } updateContentOffsetBlock:^(CGFloat value) {
        [UIView animateWithDuration:duration animations:^{
            CGPoint originOffset = self.tableView.contentOffset;
            [self.tableView setContentOffset:CGPointMake(originOffset.x, (originOffset.y+value))];
        }];
    }];
}

- (void)didAutoShowNextObject {
    [self _handleDidAutoShowNextObject];
}

@end
