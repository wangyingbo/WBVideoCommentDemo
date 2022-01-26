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
@property (nonatomic, strong) UIControl *transView;
@property (nonatomic, assign) BOOL isTransAnimationed;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
    [self initTransformView];
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

- (void)initTransformView {
    UIControl *transView = [[UIControl alloc] initWithFrame:[self getTransViewFrame]];
    transView.backgroundColor = [UIColor redColor];
    [self.view addSubview:transView];
    [transView addTarget:self action:@selector(transAction) forControlEvents:UIControlEventTouchUpInside];
    self.transView = transView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:transView.bounds];
    label.textColor = [UIColor greenColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18.f];
    label.text = @"视频榜单互动需求";
    [transView addSubview:label];
    
}

- (CGRect)getTransViewFrame {
    CGFloat trans_w = 200.f;
    CGFloat trans_h = 100.f;
    return CGRectMake(FULL_SCREEN_WIDTH/2 - trans_w/2, FULL_SCREEN_HEIGHT - trans_h - 50.f, trans_w, trans_h);
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

- (void)transAction {
    CGFloat animationDuration = 1.f;
    
    CGRect originFrame = [self getTransViewFrame];
    CGFloat scale = .7f;
    
    if (CGAffineTransformIsIdentity(self.transView.transform)) {
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat tx = originFrame.size.width/2 - (originFrame.size.width*scale)/2;
            CGFloat ty = originFrame.size.height/2 - (originFrame.size.height*scale)/2;
            
//            self.transView.transform = CGAffineTransformMake(scale, 0, 0, scale, -tx, ty);
            
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scale, scale), CGAffineTransformMakeTranslation(-tx, ty));
            self.transView.transform = transform;
            
            self.transView.alpha = .2f;
        } completion:^(BOOL finished) {
            NSLog(@"%@",NSStringFromCGRect(self.transView.frame));
        }];
    }else {
        [UIView animateWithDuration:animationDuration animations:^{
            self.transView.transform = CGAffineTransformIdentity;
            self.transView.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
    return;
    if (self.isTransAnimationed) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.transView.frame = originFrame;
        } completion:^(BOOL finished) {
            self.isTransAnimationed = NO;
        }];
    }else {
        [UIView animateWithDuration:animationDuration animations:^{
            CGRect newFrame = originFrame;
            newFrame.size.width = 100.f;
            newFrame.size.height = 100.f;
            self.transView.frame = newFrame;
        } completion:^(BOOL finished) {
            self.isTransAnimationed = YES;
        }];
    }
}

@end
