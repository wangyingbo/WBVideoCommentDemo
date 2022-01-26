//
//  WBVideoCommentRender.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "WBVideoCommentRender.h"
#import "WBVideoCommentEngine.h"
#import "WBVideoBaseCommentView.h"
#import "WBSVWeakProxy.h"
#import "WBVideoBaseCommentObject+Private.h"

@interface WBVideoCommentRender ()<WBVideoCommentEngineDelegate>
@property (nonatomic, strong) WBVideoCommentEngine<WBVideoCommentEngineProtocol> *engine;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation WBVideoCommentRender
@synthesize scrollFromFirstObject = _scrollFromFirstObject;
@synthesize timeInterval = _timeInterval;
@synthesize scrollAnimationDuration = _scrollAnimationDuration;

#pragma mark - override
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
    NSLog(@"<%@:%p> dealloc, congratulations!!!",NSStringFromClass(self.class),self);
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

- (WBVideoCommentEngine<WBVideoCommentEngineProtocol> *)engine {
    if (!_engine) {
        _engine = [[WBVideoCommentEngine alloc] init];
        if ([_engine respondsToSelector:@selector(setRender:)]) {
            _engine.render = self;
        }
        if ([_engine respondsToSelector:@selector(setDelegate:)]) {
            _engine.delegate = self;
        }
        if ([_engine respondsToSelector:@selector(setScrollFromFirstObject:)] && [self respondsToSelector:@selector(scrollFromFirstObject)]) {
            _engine.scrollFromFirstObject = self.scrollFromFirstObject;
        }
        if ([_engine respondsToSelector:@selector(setScrollAnimationDuration:)] && [self respondsToSelector:@selector(scrollAnimationDuration)]) {
            _engine.scrollAnimationDuration = self.scrollAnimationDuration;
        }
    }
    return _engine;
}

#pragma mark - public method

- (void)updateWithDatas:(NSArray<WBVideoBaseCommentObject *> *)datas {
    if ([self.engine respondsToSelector:@selector(updateWithDatas:)]) {
        [self.engine updateWithDatas:datas];
    }
}

- (void)startPlay {
    [self _addVisibleComments];
    [self _startTimer];
}

- (WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    NSArray<WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *> *reuseArr = [self.engine.reuseViewsDict objectForKey:identifier];
    if (!reuseArr) {
        return nil;
    }
    if (![reuseArr isKindOfClass:[NSArray class]]) {
        return nil;
    }
    WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *firstObj = [reuseArr firstObject];
    if (firstObj && [firstObj conformsToProtocol:@protocol(WBVideoBaseCommentViewProtocol)]) {
        if ([firstObj respondsToSelector:@selector(prepareForReuse)]) {
            [firstObj prepareForReuse];
        }
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:reuseArr];
        [mutArray removeObject:firstObj];
        if (mutArray.count) {
            [self.engine.reuseViewsDict setObject:mutArray.copy forKey:identifier];
        }else {
            [self.engine.reuseViewsDict removeObjectForKey:identifier];
        }
        return firstObj;
    }
    return nil;
}

#pragma mark - aoto play
- (void)_addVisibleComments {
    if ([self.engine respondsToSelector:@selector(startPlay)]) {
        [self.engine startPlay];
    }
}

- (void)_autoShowNextComment {
    if ([self.engine respondsToSelector:@selector(showNextComment)]) {
        [self.engine showNextComment];
    }
}

#pragma mark - private


#pragma mark - WBVideoCommentEngineDelegate
- (__kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)viewWithObject:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)object {
    if (self.delegate && [self.delegate respondsToSelector:@selector(render:viewWithObject:)]) {
        return [self.delegate render:self viewWithObject:object];
    }
    if (self.instanceCommentViewBlock) {
        WBVideoReuseCommentViewBlock reuseCommentViewBlock = ^WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *(NSString *identifier){
            return [self dequeueReusableCellWithIdentifier:identifier];
        };
        return self.instanceCommentViewBlock(reuseCommentViewBlock,self,object);
    }
    Class<WBVideoBaseCommentViewProtocol> cellClass = [object _validCellClass];
    NSString *identifier = [object _validCellReuseIdentifier];
    WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView = [self dequeueReusableCellWithIdentifier:identifier];
    if (!commentView) {
        commentView = [[[cellClass class] alloc] init];
    }
    return commentView;
}

@end
