//
//  ViewController.m
//  WBVideoCommentDemo
//
//  Created by yingbo5 on 2022/1/18.
//

#import "ViewController.h"
#import "DemoCustomCommentListVC.h"
#import "DemoTableCommentListVC.h"
#import "VideoCommentListHeader.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}

- (void)initUI {
    UIButton *customCommentListButton = [[UIButton alloc] initWithFrame:CGRectMake(FULL_SCREEN_WIDTH/2 - 60.f, 200.f, 120.f, 45.f)];
    [customCommentListButton setTitle:@"自实现" forState:UIControlStateNormal];
    [customCommentListButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    customCommentListButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    customCommentListButton.layer.borderColor = [UIColor redColor].CGColor;
    customCommentListButton.layer.borderWidth = .8f;
    [customCommentListButton addTarget:self action:@selector(customCommentListAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customCommentListButton];
    
    UIButton *tableCommentListButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(customCommentListButton.frame), CGRectGetMaxY(customCommentListButton.frame) + 40.f, CGRectGetWidth(customCommentListButton.frame), CGRectGetHeight(customCommentListButton.frame))];
    [tableCommentListButton setTitle:@"tableView实现" forState:UIControlStateNormal];
    [tableCommentListButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    tableCommentListButton.layer.borderColor = [UIColor redColor].CGColor;
    tableCommentListButton.layer.borderWidth = .8f;
    tableCommentListButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [tableCommentListButton addTarget:self action:@selector(tableCommentListAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tableCommentListButton];
}

#pragma mark - actions
- (void)customCommentListAction {
    DemoCustomCommentListVC *demoCustomCommentListVC = [[DemoCustomCommentListVC alloc] init];
    demoCustomCommentListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:demoCustomCommentListVC animated:YES completion:nil];
}

- (void)tableCommentListAction {
    DemoTableCommentListVC *demoTableCommentListVC = [[DemoTableCommentListVC alloc] init];
    demoTableCommentListVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:demoTableCommentListVC animated:YES completion:nil];
}

@end
