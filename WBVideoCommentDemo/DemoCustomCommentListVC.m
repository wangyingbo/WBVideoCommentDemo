//
//  DemoViewController.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "DemoCustomCommentListVC.h"
#import "WBVideoCommentRender.h"
#import "WBVideoTestCommentView.h"
#import "VideoCommentListHeader.h"
#import "WBVideoTestData.h"


@interface DemoCustomCommentListVC ()<WBVideoCommentRenderDelegate>
@property (nonatomic, strong) WBVideoCommentRender *render;
@end

@implementation DemoCustomCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)initUI {
    [self initRender];
    [self initNavi];
    [self updateRender];
}

- (void)initNavi {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64.f, FULL_SCREEN_WIDTH, 30.f)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    titleLabel.text = NSStringFromClass(self.class);
    [self.view addSubview:titleLabel];
}

- (void)initRender {
    WBVideoCommentRender *commentRender = [[WBVideoCommentRender alloc] initWithFrame:CGRectMake(30.f, 300.f, FULL_SCREEN_WIDTH - 60.f, 300.f)];
    commentRender.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    commentRender.delegate = self;
    commentRender.clipsToBounds = NO;
    if ([commentRender respondsToSelector:@selector(setScrollFromFirstObject:)]) {
        [commentRender setScrollFromFirstObject:YES];
    }
    if ([commentRender respondsToSelector:@selector(setTimeInterval:)]) {
        [commentRender setTimeInterval:1.5f];
    }
    if ([commentRender respondsToSelector:@selector(setScrollAnimationDuration:)]) {
        [commentRender setScrollAnimationDuration:1.f];
    }
    [self.view addSubview:commentRender];
    _render = commentRender;
}

- (void)updateRender {
    if ([self.render respondsToSelector:@selector(updateWithDatas:)]) {
        [self.render updateWithDatas:[self getOtherObjects]];
    }
    if ([self.render respondsToSelector:@selector(startPlay)]) {
        [self.render startPlay];
    }
}

#pragma mark - DATA
- (NSArray<WBVideoBaseCommentObject *> *)getTestObjects {
    NSMutableArray *mutArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 30; i++) {
        //组装cell object
        WBVideoBaseCommentObject *commentObject = [[WBVideoBaseCommentObject alloc] init];
        commentObject.cellClass = [WBVideoTestCommentView class];
        commentObject.commonInfo.maxWidth = self.render.frame.size.width;
        //业务数据
        WBVideoTestData *data = [[WBVideoTestData alloc]init];
        NSString *contentStr = [NSString stringWithFormat:@"第%@: ",[NSNumber numberWithInteger:i].stringValue];
        NSString *appendStr = @"";
        NSInteger arrCount = (arc4random() % 20) + 1;
        for (NSInteger i = 0; i<arrCount; i++) {
            NSInteger numInt = arc4random() % 1000;
            NSNumber *number = [NSNumber numberWithInteger:numInt];
            if (appendStr.length) {
                appendStr  = [appendStr stringByAppendingString:@","];
            }
            appendStr = [appendStr stringByAppendingString:number.stringValue];
        }
        contentStr = [contentStr stringByAppendingString:appendStr];
        data.content = contentStr;
        data.font = [UIFont systemFontOfSize:18.f];
        commentObject.model = data;
        [mutArray addObject:commentObject];
    }
    
    return mutArray.copy;
}

- (NSArray<WBVideoBaseCommentObject *> *)getOtherObjects {
    NSMutableArray *mutArray = [NSMutableArray array];
    WBVideoBaseCommentObject *(^createOjbect)(NSString *) = ^WBVideoBaseCommentObject *(NSString *content) {
        //组装cell object
        WBVideoBaseCommentObject *object = [[WBVideoBaseCommentObject alloc] init];
        object.cellClass = [WBVideoTestCommentView class];
        object.commonInfo.maxWidth = self.render.frame.size.width;
        //业务数据
        WBVideoTestData *data = [[WBVideoTestData alloc] init];
        data.content = content;
        data.font = [UIFont systemFontOfSize:18.f];
        object.model = data;
        [mutArray addObject:object];
        return object;
    };
    createOjbect(@"第1：所有的程序都必须和计算机内存打交道，如何从内存中申请空间来存放程序的运行内容");
    createOjbect(@"第2：如何在不需要的时候释放这些空间");
    createOjbect(@"第3：成了重中之重");
    createOjbect(@"第4：也是所有编程语言设计的难点之一");
    createOjbect(@"第5：在计算机语言不断演变过程中，出现了三种流派");
    createOjbect(@"第6：垃圾回收机制(GC)，在程序运行时不断寻找不再使用的内存，典型代表：Java、Go");
    createOjbect(@"第7：手动管理内存的分配和释放, 在程序中，通过函数调用的方式来申请和释放内存，典型代表：C++");
    createOjbect(@"第8：通过所有权来管理内存，编译器在编译时会根据一系列规则进行检查");
    createOjbect(@"第9：其中Rust选择了第三种，最妙的是，这种检查只发生在编译期，因此对于程序运行期，不会有任何性能上的");
    createOjbect(@"第10：由于所有权是一个新概念，因此读者需要花费一些时间来掌握它，一旦掌握，海阔天空任你飞跃，我们将通过字符串来引导讲解所有权的相关知识");
    return [mutArray copy];
}

#pragma mark - WBVideoCommentRenderDelegate
//- (__kindof WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *)render:(WBVideoCommentRender *)render data:(WBVideoBaseCommentObject<WBVideoBaseCommentObjectProtocol> *)data {
//    WBVideoBaseCommentView<WBVideoBaseCommentViewProtocol> *commentView = [render dequeueReusableCellWithIdentifier:NSStringFromClass(WBVideoTestCommentView.class)];
//    if (!commentView) {
//        commentView = [[WBVideoTestCommentView alloc] init];
//    }
//    return commentView;
//}

@end
