//
//  QFRootViewController.m
//  ScrollPageForTaoBao
//
//  Created by wang on 15/12/15.
//  Copyright © 2015年 wang. All rights reserved.
//

#import "QFRootViewController.h"
#import <MJRefresh/MJRefresh.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static NSString *const kUITableViewIdentifier = @"UITabViewCell";

@interface QFRootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UIWebView *webView;

@end

@implementation QFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setUpViews];
}

- (void)setUpViews{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kUITableViewIdentifier];
        tableView.delegate =self;
        tableView.dataSource =self;
        tableView;
    });
 
    self.webView = ({
        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,kScreenHeight , kScreenWidth, kScreenHeight)];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        webView.backgroundColor = [UIColor whiteColor];
        [webView loadRequest:request];
        webView;
    });
    
    [self.scrollerView addSubview:self.tableView];
    [self.scrollerView addSubview:self.webView];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5f delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.scrollerView.contentOffset = CGPointMake(0, kScreenHeight);
        } completion:^(BOOL finished) {
            //结束加载
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    
    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:1.f animations:^{
            self.scrollerView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            [self.webView.scrollView.mj_header endRefreshing];
        }];
        
    }];

}

-(UIScrollView *)detailScrollerView
{
    _scrollerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight * 2);
    //设置分页效果
    _scrollerView.pagingEnabled = YES;
    //禁用滚动
    _scrollerView.scrollEnabled = NO;
    return _scrollerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUITableViewIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
