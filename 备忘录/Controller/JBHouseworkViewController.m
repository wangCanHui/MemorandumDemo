//
//  ViewController.m
//  备忘录
//
//  Created by ejb No.2 on 2016/10/19.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBHouseworkViewController.h"
#import "JBMemoViewController.h"
#import "JBMemoDAL.h"
#import "JBMemo.h"
#import "JBHeaderView.h"
#import "JBMemoViewCell.h"
#import "JBMyWebViewController.h"
#import "JBNavigationVController.h"

@interface JBHouseworkViewController ()<JBHeaderViewDelegate,JBMemoViewCellDelegate,UITableViewDataSource,UITabBarDelegate>
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) NSMutableArray *memos;
@property (nonatomic,strong) UIButton *writeBtn;
@property (nonatomic,strong) UIButton *NewInformationBtn;
@property (nonatomic,strong) UIView *NewInfoHeaderView;
@property (nonatomic,strong) NSArray *cellFrames;
@property (nonatomic,strong) UIView *tishidengluView;
@property (nonatomic,strong) UILabel *tishiLabel;
@property (nonatomic,strong) UIButton *tishidengluBtn;
@property (nonatomic,strong) UIView *chenggongtishiView;
@property (nonatomic,strong) UILabel *chenggongtishiLabel;
@end

@implementation JBHouseworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家务事";
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"JBMemoViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.writeBtn];
    self.writeBtn.hidden = ![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogined"];
    //    self.memos = [[JBMemoDAL sharedInstance] selectAllMemos];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewDidSelectItem:) name:@"imageViewDidSelectItemNotif" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewHouseworkInfo:) name:@"getNewHouseworkInfoNotif" object:nil];
    
    
    BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogined"];
    if (!isLogined) {
        [self tishidengluClick];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
    ///说明这个登录成功后，isLogined这个字段没保存为YES
    BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogined"];
    if (isLogined) {
        self.writeBtn.hidden = NO;
        [self.tishiLabel removeFromSuperview];
        [self.tishidengluBtn removeFromSuperview];
        // 设置角标清零
        [UIApplication sharedApplication].applicationIconBadgeNumber=-1;
        UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:0];
        item.badgeValue=nil;
    }else{
        self.writeBtn.hidden = YES;
        [self.view addSubview:self.tishiLabel];
        [self.view addSubview:self.tishidengluBtn];
    }
}


///没有数据的时候获取本地
- (void)refresh
{
    // 只有当本地没有数据的时候才获取服务器的数据
    __weak typeof(self) weakSelf = self;
    [[JBNetworkTools sharedInstance] loadListDataSuccessed:^(id memos) {
        weakSelf.memos = memos;
        if (weakSelf.memos.count == 0) {
            BOOL isLogined = [[NSUserDefaults standardUserDefaults]boolForKey:@"isLogined"];
            if (isLogined) {
                [self.view addSubview:self.chenggongtishiLabel];
            }
        }else{
            [self.chenggongtishiLabel removeFromSuperview];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSError *error) {
        [self.chenggongtishiLabel removeFromSuperview];
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
}

- (IBAction)newMemo {
    JBMemoViewController *memoVC = [[JBMemoViewController alloc] initWithNibName:@"JBMemoViewController" bundle:nil];
    memoVC.members = @[@""];
    __weak typeof(self) weakSelf = self;
    memoVC.saveBlock = ^{
        //        weakSelf.memos = [[JBMemoDAL sharedInstance] selectAllMemos];
        //        [weakSelf.tableView reloadData];
        [[JBNetworkTools sharedInstance] loadListDataSuccessed:^(id memos) {
            weakSelf.memos = memos;
            [weakSelf.tableView reloadData];
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    };
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:memoVC animated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.memos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JBMemo *memo = self.memos[indexPath.section];
    JBMemoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.memo = memo;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JBMemo *memo=self.memos[section];
    JBHeaderView *headerView=[JBHeaderView headerViewWithTableView:tableView];
    headerView.memo=memo;
    headerView.tag = section;
    headerView.delegate = self;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBMemo *memo = self.memos[indexPath.section];
    CGFloat height = [memo.title heightWithFontSize:14 Width:JBScreenWidth-129];
    if (height > 17) {
        memo.isShowExpandedView = YES;
    }else{
        memo.isShowExpandedView = NO;
    }
    if (!memo.isVisible) {
        height = 17;
    }
    if (memo.img.length > 10 || memo.voiceNum) {
        height += 70;
    }
    return height+31;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBMemo *memo = self.memos[indexPath.section];
    JBMemoViewController *memoVC = [[JBMemoViewController alloc] initWithNibName:@"JBMemoViewController" bundle:nil];
    memoVC.members = @[@""];
    
    memoVC.memo = memo;
    __weak typeof(self) weakSelf = self;
    memoVC.saveBlock = ^{
        //        weakSelf.memos = [[JBMemoDAL sharedInstance] selectAllMemos];
        //        [weakSelf.tableView reloadData];
        [[JBNetworkTools sharedInstance] loadListDataSuccessed:^(id memos) {
            weakSelf.memos = memos;
            [weakSelf.tableView reloadData];
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    };
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:memoVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JBMemo *memo = self.memos[indexPath.section];
    //    [[JBMemoDAL sharedInstance] deleteMemoWithMemo_id:memo.memo_id];
    //    self.memos = [[JBMemoDAL sharedInstance] selectAllMemos];
    [self.memos removeObject:memo];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    // 删除沙盒文件
    NSArray *imageNames = [memo.imageNames componentsSeparatedByString:@","];
    for (NSString *imageName in imageNames) {
        NSString *item,*filePath = nil;
        if (imageName.length == 36) {
            item = [imageName substringToIndex:18];
        }
        NSString *documentPath = [NSUserDefaults getDocumentPath];
        if (item) {
            filePath = [documentPath stringByAppendingPathComponent:item];
        }else{
            filePath = [documentPath stringByAppendingPathComponent:imageName];
        }
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    if (memo.jws_id>0) {
        // 不需要回调
        [[JBNetworkTools sharedInstance] deleteMemoWithJws_id:memo.jws_id Successed:nil failed:nil];
    }
}
#pragma mark - JBMemoViewCellDelegate
- (void)memoViewCellShowOrHide:(JBMemoViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    JBMemo *memo = self.memos[indexPath.section];
    memo.visible = !memo.visible;
    [self.tableView reloadData];
}
#pragma mark - JBHeaderViewDelegate
- (void)headerViewDidClickIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 处理通知
- (void)imageViewDidSelectItem:(NSNotification *)notify{
    NSDictionary *userInfo = notify.userInfo;
    NSIndexPath *indexPath = userInfo[@"indexPath"];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (void)getNewHouseworkInfo:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    self.tableView.tableHeaderView = self.NewInfoHeaderView;
    [self.NewInformationBtn setTitle:[NSString stringWithFormat:@"你有%@条新消息",userInfo[@"num"]] forState:UIControlStateNormal];
}

#pragma mark - 点击事件
- (void)NewInformation
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"houseworkNotifNum"];
    self.tableView.tableHeaderView = nil;
    __weak typeof(self) weakSelf = self;
    [[JBNetworkTools sharedInstance] loadListDataSuccessed:^(id memos) {
        weakSelf.memos = memos;
        [weakSelf.tableView reloadData];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

-(void)tishidengluClick {
    
    JBMyWebViewController *webVC = [[JBMyWebViewController alloc] init];
    webVC.urlStr = [NSString stringWithFormat:@"%@userapp/appLoginCallback.jsp?r=pf&key=userapp",JBDomainName];
    JBNavigationVController *nav = [[JBNavigationVController alloc] initWithRootViewController:webVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 懒加载
- (UIButton *)writeBtn
{
    if (!_writeBtn) {
        _writeBtn = [UIButton buttonWithTitle:nil titleColor:nil fontSize:0 imageName:@"write" bkgimageName:nil target:self action:@selector(newMemo)];
        ///设置内间距
        _writeBtn.imageEdgeInsets = UIEdgeInsetsMake(-30, -5, -30, 0);
    }
    return _writeBtn;
}

- (UIView *)NewInfoHeaderView
{
    if (!_NewInfoHeaderView) {
        _NewInfoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JBScreenWidth, 50)];
        self.NewInformationBtn.center = _NewInfoHeaderView.center;
        [_NewInfoHeaderView addSubview:self.NewInformationBtn];
    }
    return _NewInfoHeaderView;
}

-(UIButton *)NewInformationBtn {
    
    if (!_NewInformationBtn) {
        
        _NewInformationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _NewInformationBtn = [UIButton buttonWithTitle:@"你有一条新消息" titleColor:[UIColor whiteColor] fontSize:16 imageName:@"" bkgimageName:nil target:self action:@selector(NewInformation)];
        _NewInformationBtn.backgroundColor = [UIColor blackColor];
        _NewInformationBtn.size = CGSizeMake(140, 35);
        _NewInformationBtn.hidden = NO;
        _NewInformationBtn.alpha = 0.7;
        _NewInformationBtn.layer.cornerRadius = 12;
        _NewInformationBtn.clipsToBounds = YES;
    }
    return _NewInformationBtn;
}



-(UILabel *)chenggongtishiLabel {
    
    if (!_chenggongtishiLabel) {
        _chenggongtishiLabel = [[UILabel alloc]init];
        _chenggongtishiLabel.frame = CGRectMake(120, 180, 300, 50);
        _chenggongtishiLabel.textColor = kUIColorFromRGB(0x666666);
        _chenggongtishiLabel.text = @"您还没发布家务事呢";
        //适配plus
        if (JBScreenWidth == 414) {
            _chenggongtishiLabel.origin = CGPointMake(130, JBScreenHeight - 500);
        }else if(JBScreenWidth == 320 ) {
            _chenggongtishiLabel.origin = CGPointMake(28, JBScreenHeight - 115);
        }else {
            _chenggongtishiLabel.origin = CGPointMake(110, JBScreenHeight - 500);
        }
    }
    return _chenggongtishiLabel;
    
}

//-(UIView *)tishidengluView {
//
//    if (!_tishidengluView) {
//        _tishidengluView = [[UIView alloc]init];
//        _tishidengluView.frame = CGRectMake(40, 120, 300, 150);
//        _tishidengluView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_tishidengluView];
//    }
//    return _tishidengluView;
//}

-(UILabel *)tishiLabel {
    
    if (!_tishiLabel) {
        _tishiLabel = [[UILabel alloc]init];
        _tishiLabel.frame = CGRectMake(70, 150, 300, 20);
        _tishiLabel.textColor = kUIColorFromRGB(0x666666);
        _tishiLabel.text = @"马上登录，开启您的家务事管理";
        //适配plus
        if (JBScreenWidth == 414) {
            _tishiLabel.origin = CGPointMake(90, JBScreenHeight - 500);
        }else if(JBScreenWidth == 320 ) {
            _tishiLabel.origin = CGPointMake(28, JBScreenHeight - 115);
        }else {
            _tishiLabel.origin = CGPointMake(70, JBScreenHeight - 500);
        }
    }
    return _tishiLabel;
}

-(UIButton *)tishidengluBtn {
    
    if (!_tishidengluBtn) {
        _tishidengluBtn = [[UIButton alloc]init];
        _tishidengluBtn.frame = CGRectMake(120, 220, 150, 50);
        [_tishidengluBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_tishidengluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tishidengluBtn addTarget:self action:@selector(tishidengluClick) forControlEvents:UIControlEventTouchUpInside];
        _tishidengluBtn.backgroundColor = kUIColorFromRGB(0x228B22);
        _tishidengluBtn.layer.cornerRadius = 12;
        _tishidengluBtn.clipsToBounds = YES;
        if (JBScreenWidth == 414) {
            _tishidengluBtn.origin = CGPointMake(130, JBScreenHeight - 400);
        }else if(JBScreenWidth == 320 ) {
            _tishidengluBtn.origin = CGPointMake(28, JBScreenHeight - 115);
        }else {
            _tishidengluBtn.origin = CGPointMake(110, JBScreenHeight - 400);
        }
    }
    return _tishidengluBtn;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

