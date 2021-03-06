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
        //??????cell object
        WBVideoTableCommentObject *object = [[WBVideoTableCommentObject alloc] init];
        object.commonInfo.maxWidth = self.render.frame.size.width;
        object.cellClass = WBVideoTestCommentCell.class;
        object.reuseIdentifier = NSStringFromClass(object.cellClass);
        //????????????
        WBVideoTestData *data = [[WBVideoTestData alloc] init];
        data.content = content;
        data.font = [UIFont systemFontOfSize:18.f];
        object.model = data;
        [mutArray addObject:object];
        return object;
    };
    createObject(@"???1?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????");
    createObject(@"???2????????????????????????????????????????????????");
    createObject(@"???3?????????????????????");
    createObject(@"???4????????????????????????????????????????????????");
    createObject(@"???5??????????????????????????????????????????????????????????????????");
    createObject(@"???6?????????????????????(GC)????????????????????????????????????????????????????????????????????????Java???Go");
    createObject(@"???7???????????????????????????????????????, ????????????????????????????????????????????????????????????????????????????????????C++");
    createObject(@"???8?????????????????????????????????????????????????????????????????????????????????????????????");
    createObject(@"???9?????????Rust?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????");
    createObject(@"???10???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????");
    return [mutArray copy];
}

#pragma mark - WBVideoTableCommentRenderDelegate

- (void)render:(WBVideoTableCommentRender *)render object:(WBVideoTableCommentObject<WBVideoTableCommentObjectProtocol> *)object tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath cell:(WBVideoTableCommentCell<WBVideoTableCommentCellProtocol> *)cell {
    
}

@end
