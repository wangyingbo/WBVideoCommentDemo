//
//  WBVideoTableCommentRender.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "WBVideoTableCommentRender.h"
#import "WBSVWeakProxy.h"
#import "WBVideoTableCommentEngine.h"
#import "WBVideoTableCommentOjbect+Private.h"
#import "WBVideoTableCommentCell.h"

@interface WBVideoTableCommentRender ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *dataArray;
@property (nonatomic, strong) WBVideoTableCommentEngine<WBVideoTableCommentEngineProtocol> *engine;
@end

@implementation WBVideoTableCommentRender

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)dealloc {
     [self.timer invalidate];
    NSLog(@"<%@:%p> dealloc, congratulations!!!",NSStringFromClass(self.class),self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - timer
- (void)_startTimer {
    
    if (self.timer) { [self _stopTimer]; }
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:[WBSVWeakProxy proxyWithTarget:self] selector:@selector(playTimerRun) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)_stopTimer {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)playTimerRun {
    [self _autoShowNextComment];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (WBVideoTableCommentEngine<WBVideoTableCommentEngineProtocol> *)engine {
    if (!_engine) {
        _engine = (WBVideoTableCommentEngine<WBVideoTableCommentEngineProtocol> *)[[WBVideoTableCommentEngine alloc] init];
        if ([_engine respondsToSelector:@selector(setTableView:)]) {
            _engine.tableView = self.tableView;
        }
    }
    return _engine;
}

#pragma mark - UI
- (void)initUI {
    
    [self addSubview:self.tableView];
    [self registerCellClass];
    
}

- (void)registerCellClass {
    if ([WBVideoTableCommentCell respondsToSelector:@selector(reuseIdentifier)]) {
        [_tableView registerClass:[WBVideoTableCommentCell class] forCellReuseIdentifier:[WBVideoTableCommentCell reuseIdentifier]];
    }
    if (!self.registerTableCellClassBlock) {
        return;
    }
    RegisterCellClassBlock registerCellBlock = ^void(Class class, NSString *identifer) {
        NSString *identifierString = identifer;
        if (identifierString) {
            return;
        }
        identifierString = NSStringFromClass(class);
        if ([class respondsToSelector:@selector(reuseIdentifier)]) {
            identifierString = [(WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *)class reuseIdentifier];
        }
        [self.tableView registerClass:class forCellReuseIdentifier:identifierString];
    };
    self.registerTableCellClassBlock(registerCellBlock);
}

#pragma mark - public
- (void)updateWithDatas:(NSArray<WBVideoTableCommentOjbect *> *)datas {
    if ([self.engine respondsToSelector:@selector(updateAllObjects:)]) {
        [self.engine updateAllObjects:datas];
    }
}

- (void)startPlay {
    [self _startInitialVisibleComments];
    [self _startTimer];
}

#pragma mark - aoto play

/// 首次进来只显示可见区域的cell
- (void)_startInitialVisibleComments {
    NSArray<WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *> *initialObjects = nil;
    if ([self.engine respondsToSelector:@selector(startPlayInitialObjects)]) {
        initialObjects = [self.engine startPlayInitialObjects];
    }
    self.dataArray = initialObjects;
    [self.tableView reloadData];
}

/// 自动添加下一个
- (void)_autoShowNextComment {
    WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *nextObject = nil;
    if ([self.engine respondsToSelector:@selector(getNextObject)]) {
        nextObject = [self.engine getNextObject];
    }
    if (!nextObject) {
        return;
    }
    NSMutableArray *mutDataArr = [self.dataArray mutableCopy];
    if (![mutDataArr isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    NSInteger newIndex = self.dataArray.count ? self.dataArray.count : 0;
    [mutDataArr addObject:nextObject];
    self.dataArray = [mutDataArr copy];
    
    //new indexPath
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newIndex inSection:0];
    
    //插入cell更新
//    NSMutableArray *mutIndexpaths = [NSMutableArray array];
//    [mutIndexpaths addObject:newIndexPath];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:[mutIndexpaths copy] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
    
    //调用scrollToRowAtIndexPath:自动滚到下一个
    if (newIndexPath.row < self.dataArray.count && !self.scrollByCalculated) {
        //直接刷新reloadData
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        return;
    }
    
    //处理手动计算滚动逻辑
    [self.tableView performBatchUpdates:^{
        //插入cell更新
        NSMutableArray *mutIndexpaths = [NSMutableArray array];
        [mutIndexpaths addObject:newIndexPath];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[mutIndexpaths copy] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } completion:^(BOOL finished) {
        [self _calculateNextObject:nextObject];
    }];
    
}

- (void)_calculateNextObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)nextObject {
    //获取上一个last cell相对render的位置
    WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *lastVisibleCell = nil;
    if (!lastVisibleCell) {
        lastVisibleCell = [self _currentLastVisibleCell];
    }
    else if (!lastVisibleCell && self.dataArray.count >= 2) {
        NSInteger lastIndex = (self.dataArray.count - 2);
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
        lastVisibleCell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
    }
    else if (!lastVisibleCell && self.tableView.visibleCells.count >= 2) {
        NSArray *visibleCells = self.tableView.visibleCells;
        for (NSInteger i = visibleCells.count - 2; i >= 0; i--) {//倒序遍历，找出没添加新cell前的最后一个显示的cell
            WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *tempCell = nil;
            if (i<0) {  break; }
            tempCell = [visibleCells objectAtIndex:i];
            CGRect tempCellRect = [self.tableView convertRect:tempCell.frame toView:self];
            CGFloat tempCellCenterY = CGRectGetMaxY(tempCellRect) - CGRectGetHeight(tempCellRect)/2;
            if ((CGRectGetMaxY(self.tableView.frame) - self.engine.contentInset.bottom) > tempCellCenterY) {
                lastVisibleCell = tempCell;
                break;
            }
        }
    }
    CGRect lastVisibleRect = CGRectZero;
    if (lastVisibleCell) {
        lastVisibleRect = [self.tableView convertRect:lastVisibleCell.frame toView:self];
    }
    NSLog(@"last cell:%@, last object rect:%@ maxY:%@",lastVisibleCell,NSStringFromCGRect(lastVisibleRect),[NSNumber numberWithFloat:CGRectGetMaxY(lastVisibleRect)]);
    
    //算出即将自动滚出的cell相对render的位置
    CGFloat newCellHeight = 0.f;
    Class<WBVideoTableCommentCellProtocol> cellClass = [nextObject _validCellClass];
    if ([cellClass respondsToSelector:@selector(heightForCellWithObject:)]) {
        newCellHeight = [cellClass heightForCellWithObject:nextObject];
    }
    CGRect newCellVisibleRect = CGRectZero;
    if (newCellHeight > 1e-4) {
        newCellVisibleRect = CGRectMake(CGRectGetMinX(lastVisibleRect), CGRectGetMaxY(lastVisibleRect), CGRectGetWidth(lastVisibleRect), newCellHeight);
    }
    if ([self.engine respondsToSelector:@selector(nextObjectToRect:duration:)]) {
        [self.engine nextObjectToRect:newCellVisibleRect duration:.2f];
    }
    
    //滚完以后回调
    if ([self.engine respondsToSelector:@selector(didAutoShowNextObject)]) {
        [self.engine didAutoShowNextObject];
    }
}

- (WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *)_currentLastVisibleCell
{
    NSIndexPath *lastVisibleIndexPath = [self _currentLastVisibleIndexPath];
    if (!lastVisibleIndexPath) {
        return nil;
    }
    return [self _cellForIndexPath:lastVisibleIndexPath];
}

- (NSIndexPath *)_currentLastVisibleIndexPath
{
    CGPoint bottomPoint = CGPointMake(self.tableView.center.x, (CGRectGetMaxY(self.tableView.frame) - self.engine.contentInset.bottom - 1.f));
    CGPoint testPosition = [self.tableView.superview convertPoint:bottomPoint toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:testPosition];
    return indexPath;
}

- (WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *)_cellForIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[WBVideoTableCommentCell class]]) {
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row+1 > self.dataArray.count) {
        return 0.f;
    }
    WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *object = [self.dataArray objectAtIndex:indexPath.row];
    Class<WBVideoTableCommentCellProtocol> cellClass = [object _validCellClass];
    if ([cellClass respondsToSelector:@selector(heightForCellWithObject:)]) {
        return [cellClass heightForCellWithObject:object];
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row+1 > self.dataArray.count) {
        return nil;
    }
    WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *cell = nil;
    WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *object = [self.dataArray objectAtIndex:indexPath.row];
    Class<WBVideoTableCommentCellProtocol> cellClass = [object _validCellClass];
    NSString *identifier = [object _validCellReuseIdentifier];
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerClass:cellClass forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    if (cell && [cell respondsToSelector:@selector(updateCellWithObject:)]) {
        [cell updateCellWithObject:object];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row+1 > self.dataArray.count) {
        return;
    }
    WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *object = [self.dataArray objectAtIndex:indexPath.row];
    WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(render:data:tableView:didSelectRowAtIndexPath:cell:)]) {
        [self.delegate render:self data:object tableView:tableView didSelectRowAtIndexPath:indexPath cell:cell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"=====%f",scrollView.contentOffset.y);
}

@end
