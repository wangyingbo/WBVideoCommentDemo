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
@synthesize scrollFromFirstObject = _scrollFromFirstObject;
@synthesize timeInterval = _timeInterval;
@synthesize scrollAnimationDuration = _scrollAnimationDuration;

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
    
    NSTimeInterval interval = 1.f;
    if ([self respondsToSelector:@selector(timeInterval)]) {
        interval = self.timeInterval;
    }
    self.timer = [NSTimer timerWithTimeInterval:interval target:[WBSVWeakProxy proxyWithTarget:self] selector:@selector(playTimerRun) userInfo:nil repeats:YES];
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
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 44.f;
        _tableView.estimatedSectionFooterHeight = 0.1f;
        _tableView.estimatedSectionHeaderHeight = 0.1f;
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
        if ([_engine respondsToSelector:@selector(setScrollFromFirstObject:)] && [self respondsToSelector:@selector(scrollFromFirstObject)]) {
            _engine.scrollFromFirstObject = self.scrollFromFirstObject;
        }
    }
    return _engine;
}

#pragma mark - UI
- (void)initUI {
    
    [self _initTableView];
    [self _registerCellClass];
    
}

- (void)_initTableView {
    [self addSubview:self.tableView];
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.1f)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = tableFooterView;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.1f)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = tableHeaderView;
}

- (void)_registerCellClass {
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
    
    NSInteger newIndex = self.dataArray.count ? self.dataArray.count : 0;
    //new indexPath
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newIndex inSection:0];
    
    //insert data
    void(^insertDataBlock)(WBVideoTableCommentOjbect *) = ^void(WBVideoTableCommentOjbect *object) {
        NSMutableArray *mutDataArr = [self.dataArray mutableCopy];
        if (![mutDataArr isKindOfClass:[NSMutableArray class]]) {
            return;
        }
        if (!object) {
            return;
        }
        [mutDataArr addObject:object];
        self.dataArray = [mutDataArr copy];
    };
    
    //调用scrollToRowAtIndexPath:自动滚到下一个
    if (!self.scrollByCalculated) {
        insertDataBlock(nextObject);
        if (newIndexPath.row + 1 > self.dataArray.count) { return; }
        //直接刷新reloadData
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        return;
    }
    
    //处理手动计算滚动逻辑
    if (!self.tableView.superview) { return; }
    if (@available(iOS 11.0, *)) {
        [self.tableView performBatchUpdates:^{
            insertDataBlock(nextObject);
            //插入cell更新
            NSMutableArray *mutIndexpaths = [NSMutableArray array];
            [mutIndexpaths addObject:newIndexPath];
            [self.tableView insertRowsAtIndexPaths:[mutIndexpaths copy] withRowAnimation:UITableViewRowAnimationNone];
        } completion:^(BOOL finished) {
            [self _calculateNextObject:nextObject];
        }];
    }else {
        insertDataBlock(nextObject);
        //插入cell更新
        NSMutableArray *mutIndexpaths = [NSMutableArray array];
        [mutIndexpaths addObject:newIndexPath];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[mutIndexpaths copy] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self _calculateNextObject:nextObject];
    }
    
}

- (void)_calculateNextObject:(WBVideoTableCommentOjbect<WBVideoTableCommentOjbectProtocol> *)nextObject {
    //获取上一个last cell相对render的位置
    WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *lastVisibleCell = nil;
    NSIndexPath *lastVisibleIndexPath = nil;
    if (!lastVisibleCell) {
        lastVisibleCell = [self _currentLastVisibleCell];
        lastVisibleIndexPath = [self _currentLastVisibleIndexPath];
    }
    if (!lastVisibleCell && self.dataArray.count >= 2) {
        NSInteger lastIndex = (self.dataArray.count - 2);
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
        lastVisibleCell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
        lastVisibleIndexPath = lastIndexPath;
    }
    if (!lastVisibleCell && self.tableView.visibleCells.count >= 2) {
        NSArray *visibleCells = self.tableView.visibleCells;
        for (NSInteger i = visibleCells.count - 2; i >= 0; i--) {//倒序遍历，找出新cell前面的显示的cell
            WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *tempCell = nil;
            if (i<0) {  break; }
            tempCell = [visibleCells objectAtIndex:i];
            CGRect tempCellRect = [self.tableView convertRect:tempCell.frame toView:self];
            CGFloat tempCellCenterY = CGRectGetMaxY(tempCellRect) - CGRectGetHeight(tempCellRect)/2;
            if ((CGRectGetMaxY(self.tableView.frame) - self.engine.contentInset.bottom) > tempCellCenterY) {
                lastVisibleCell = tempCell;
                lastVisibleIndexPath = [self.tableView indexPathForCell:lastVisibleCell];
                break;
            }
        }
    }
    CGRect lastVisibleRect = CGRectZero;
    if (lastVisibleIndexPath) {
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:lastVisibleIndexPath];
        lastVisibleRect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    }
    
    //算出即将自动滚出的cell相对render的位置
    CGFloat newCellHeight = 0.f;
    Class<WBVideoTableCommentCellProtocol> cellClass = [nextObject _validCellClass];
    if ([cellClass respondsToSelector:@selector(heightForCellWithObject:)]) {
        newCellHeight = [cellClass heightForCellWithObject:nextObject];
    }
    CGRect newCellVisibleRect = CGRectZero;
    if (!CGRectEqualToRect(lastVisibleRect, CGRectZero)) {
        newCellVisibleRect = CGRectMake(CGRectGetMinX(lastVisibleRect), CGRectGetMaxY(lastVisibleRect), CGRectGetWidth(lastVisibleRect), newCellHeight);
    } else {
        newCellVisibleRect = CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetHeight(self.tableView.frame), CGRectGetWidth(self.tableView.frame) - self.engine.contentInset.bottom, newCellHeight);
    }
    NSLog(@"contentInset.top:%f",self.tableView.contentInset.top);
    NSLog(@"last cell rect:%@, next object rect:%@",NSStringFromCGRect(lastVisibleRect),NSStringFromCGRect(newCellVisibleRect));
    
    if ([self.engine respondsToSelector:@selector(adjustNextObjectRect:duration:)]) {
        NSTimeInterval duration = .5f;
        if ([self respondsToSelector:@selector(scrollAnimationDuration)]) {
            duration = self.scrollAnimationDuration;
        }
        [self.engine adjustNextObjectRect:newCellVisibleRect duration:duration];
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
    if (!cell) {
        cell = [[[cellClass class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"%@Header",NSStringFromClass([self class])]];
    headerView.backgroundView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"%@Footer",NSStringFromClass([self class])]];
    footerView.backgroundView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"=====%f",scrollView.contentOffset.y);
}

@end
