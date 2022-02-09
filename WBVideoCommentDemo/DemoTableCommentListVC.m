//
//  DemoTableCommentListVC.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/19.
//

#import "DemoTableCommentListVC.h"
#import "VideoCommentListHeader.h"
#import "WBVideoTableCommentRender.h"
#import "WBVideoTestCommentCell.h"
#import "WBVideoTestData.h"

@interface DemoTableCommentListVC ()<WBVideoTableCommentRenderDelegate>
@property (nonatomic, strong) WBVideoTableCommentRender *render;

@end

@implementation DemoTableCommentListVC

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
    [self initNavi];
    [self initRender];
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(30.f, 300.f, FULL_SCREEN_WIDTH - 60.f, 300.f)];
    bgView.backgroundColor = [UIColor greenColor];
    bgView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bgView.bounds, 3.f, 3.f) cornerRadius:10].CGPath;
    bgView.layer.shadowColor = [UIColor redColor].CGColor;
    bgView.layer.shadowRadius = 10.f;
    bgView.layer.shadowOpacity = .5f;
    [self.view addSubview:bgView];
    
    WBVideoTableCommentRender *commentRender = [[WBVideoTableCommentRender alloc] initWithFrame:bgView.frame];
    commentRender.backgroundColor = [UIColor colorWithWhite:0 alpha:.2];
    commentRender.delegate = self;
    commentRender.scrollByCalculated = NO;
    if ([commentRender respondsToSelector:@selector(setScrollFromFirstObject:)]) {
        [commentRender setScrollFromFirstObject:YES];
    }
    if ([commentRender respondsToSelector:@selector(setTimeInterval:)]) {
        [commentRender setTimeInterval:2.f];
    }
    if ([commentRender respondsToSelector:@selector(setScrollAnimationDuration:)]) {
        [commentRender setScrollAnimationDuration:.5f];
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

- (NSArray<WBVideoTableCommentObject *> *)getOtherObjects {
    NSMutableArray *mutArray = [NSMutableArray array];
    WBVideoTableCommentObject *(^createObject)(NSString *) = ^WBVideoTableCommentObject *(NSString *content) {
        //组装cell object
        WBVideoTableCommentObject *object = [[WBVideoTableCommentObject alloc] init];
        object.commonInfo.maxWidth = self.render.frame.size.width;
        object.cellClass = WBVideoTestCommentCell.class;
        object.reuseIdentifier = NSStringFromClass(object.cellClass);
        //业务数据
        WBVideoTestData *data = [[WBVideoTestData alloc] init];
        data.content = content;
        data.font = [UIFont systemFontOfSize:18.f];
        object.model = data;
        [mutArray addObject:object];
        return object;
    };
    createObject(@"第1：所有的程序都必须和计算机内存打交道，如何从内存中申请空间来存放程序的运行内容");
    createObject(@"第2：如何在不需要的时候释放这些空间");
    createObject(@"第3：成了重中之重");
    createObject(@"第4：也是所有编程语言设计的难点之一");
    createObject(@"第5：在计算机语言不断演变过程中，出现了三种流派");
    createObject(@"第6：垃圾回收机制(GC)，在程序运行时不断寻找不再使用的内存，典型代表：Java、Go");
    createObject(@"第7：手动管理内存的分配和释放, 在程序中，通过函数调用的方式来申请和释放内存，典型代表：C++");
    createObject(@"第8：通过所有权来管理内存，编译器在编译时会根据一系列规则进行检查");
    createObject(@"第9：其中Rust选择了第三种，最妙的是，这种检查只发生在编译期，因此对于程序运行期，不会有任何性能上的");
    createObject(@"第10：由于所有权是一个新概念，因此读者需要花费一些时间来掌握它，一旦掌握，海阔天空任你飞跃，我们将通过字符串来引导讲解所有权的相关知识");
    return [mutArray copy];
}

#pragma mark - WBVideoTableCommentRenderDelegate

- (void)render:(WBVideoTableCommentRender *)render data:(WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)data tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cell:(WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *)cell {
    
}

@end
