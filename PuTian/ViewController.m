//
//  ViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "ViewController.h"
#import "EScrollerView.h"
#import "MetroButton.h"
#import "OffPriceViewController.h"
#import "MazuViewController.h"
#import "LocalInfoViewController.h"
#import "RecreationChannelListViewController.h"
#import "RecreationViewController.h"
#import "VideoViewController.h"
#import "WobiViewController.h"
#import "LoginViewController.h"
#import "PTWebViewController.h"
#import "QRCodeViewController.h"
#import "AddIndexModelViewController.h"
#import "IndexModelCell.h"
#import "WoBiDuanHuanViewController.h"
#import "MeishiViewController.h"
#import "MiniShopViewController.h"

#import "AdvertInfoList.h"
#import "UserInfo.h"
#import "IndexModelList.h"

#import "LXReorderableCollectionViewFlowLayout.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>

// LX_LIMITED_MOVEMENT:
// 0 = Any card can move anywhere
// 1
#define LX_LIMITED_MOVEMENT 1

#define IndexModelColumn 3

@interface ViewController ()<EScrollerViewDelegate,MetroButtonDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,IndexModelCellDelegate>
{
    NSObject *_lockObj;
}

@property (nonatomic,strong) EScrollerView *viewAD;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionView *collectionView;

/** 是否正在编辑cell */
@property (nonatomic,assign) BOOL isEdittingCell;
@property (nonatomic,assign) NSInteger edittingItem;

@property (nonatomic,strong) NSMutableArray *listModel;

@property (nonatomic,strong) AdvertInfoList *adInfoList;

@property (nonatomic,strong) IndexModelList *modelList;

@property (nonatomic,assign) BOOL isLoadedView;

@property (nonatomic,assign) BOOL isDidAppear;

@end

@implementation ViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.navigationItem.title=@"指尖上的莆田";
        self.tabBarItem.title=@"首页";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_icon_index"];
        
        _lockObj=[[NSObject alloc] init];
    }
    return self;
}

/** 当没有数据时重新加载 */
-(void)reloadWhenNoData
{
    if(self.isLoadedView)
    {
        if(_adInfoList.list.count==0)
        {
            [_adInfoList loadData];
        }
        
        if(_listModel.count==0)
        {
            [_modelList loadDefaultData];
        }
    }
}

-(void)reloadWhenLongInterval
{
    [_adInfoList loadData];
    
    if(_listModel.count==0)
    {
        [_modelList loadDefaultData];
    }
    else
    {
        [_modelList loadAllDataForChecking];
    }
}

-(void)scanQRCodeTouchUp
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        QRCodeViewController *QRCodeVC=[[QRCodeViewController alloc] init];
        QRCodeVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:QRCodeVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *navigation=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.navigationHeight)];
    self.navigationItem.titleView=navigation;
    
    UIImageView *navLogo=[[UIImageView alloc] initWithFrame:CGRectMake(0, (navigation.height-34)/2.0, 72, 34)];
    navLogo.image=[UIImage imageNamed:@"index_logo_unicom"];
    navLogo.hidden=YES;
    navLogo.contentMode=UIViewContentModeScaleAspectFill;
    [navigation addSubview:navLogo];
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, (navigation.height-20)/2.0, navigation.width, 20)];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.font=[UIFont boldSystemFontOfSize:17.0];
    lblTitle.text=@"指尖上的莆田";
    lblTitle.hidden=YES;
    [navigation addSubview:lblTitle];
    
    UIButton *btnScan=[[UIButton alloc] initWithFrame:CGRectMake(navigation.width-50, (navigation.height-35)/2.0, 35, 35)];
    [btnScan setImage:[UIImage imageNamed:@"index_scan"] forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(scanQRCodeTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:btnScan];
    
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.marginTop+1, self.view.width, self.viewHeight-1)];
    [self.view addSubview:_scrollView];
    
    //_scrollView.contentInset=UIEdgeInsetsMake(-([Common marginTop]+self.navigationController.navigationBar.height+1), 0, 0, 0);
    
    //    UIImage *image=[UIImage imageNamed:@"index_ad1.jpg"];
    //    float adWidth=self.view.width;
    //    float adHeight=adWidth*image.size.height/image.size.width;
    float adWidth=320*[Common ratioWidthScreenWidthTo320];
    float adHeight=134.152634*[Common ratioWidthScreenWidthTo320];
    adHeight=139.152634*[Common ratioWidthScreenWidthTo320];
    _viewAD=[[EScrollerView alloc] initWithFrame:CGRectMake(0, 0, adWidth, adHeight) isShowTitle:YES];
    //[_viewAD fillAdvertDataWithImageArray:[NSArray arrayWithObjects:@"index_ad1.jpg",@"index_ad1.jpg", nil] TitleArray:[NSArray arrayWithObjects:@"广告1",@"广告2", nil]];
    _viewAD.delegate=self;
    [_scrollView addSubview:_viewAD];
    
    
    _listModel=[[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameAdvertInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameIndexModelList object:nil];
    
    _adInfoList=[[AdvertInfoList alloc] init];
    _adInfoList.type=AdvertTypeIndex;
    _adInfoList.notificationName=kNotificationNameAdvertInfoList;
    [_adInfoList loadData];
    
    _modelList=[[IndexModelList alloc] init];
    _modelList.notificationName=kNotificationNameIndexModelList;
    [_modelList readCacheList:_listModel];
    
    if(_listModel.count==0)
    {
        [MBProgressHUDManager showIndicatorWithTitle:@"正在加载首页模块" inView:self.view];
        [_modelList loadDefaultData];
    }
    else
    {
        IndexModel *model=[[IndexModel alloc] init];
        model.modelid=0;
        model.sign=0;
        model.iconUrl=@"index_add";
        [_listModel addObject:model];
        
        [_modelList loadAllDataForChecking];
    }
    
    
    float top=_viewAD.y+_viewAD.height;
    
    
    LXReorderableCollectionViewFlowLayout *flowLayout=[[LXReorderableCollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=1;
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, top, _scrollView.width, _scrollView.height-top) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[IndexModelCell class] forCellWithReuseIdentifier:@"gIndexModelCellIdentifier"];
    [_scrollView addSubview:_collectionView];
    
    self.isLoadedView=YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.isDidAppear)
    {
        [self reloadWhenNoData];
    }
    else
    {
        self.isDidAppear=YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameAdvertInfoList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameIndexModelList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameAdvertInfoList])
    {
        if(notification.object==_adInfoList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [_viewAD fillAdvertData:_adInfoList ImgStr:nil];
                [_viewAD startAutoPlayWithInterval:3];
            }
            else
            {
                if(!hasNetworkFlags)
                {
                    [MBProgressHUDManager hideMBProgressInView:self.view];
                    [MBProgressHUDManager showTextWithTitle:@"未连接网络" inView:self.view];
                }
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameIndexModelList])
    {
        if(notification.object==_modelList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            if(succeed)
            {
                switch(nType)
                {
                    case 1:
                    {
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        if(_modelList.listDefault.count>0)
                        {
                            if(_listModel.count==0)
                            {
                                [_listModel addObjectsFromArray:_modelList.listDefault];
                                
                                [_modelList saveDefaultList:_listModel];
                                
                                IndexModel *model=[[IndexModel alloc] init];
                                model.modelid=0;
                                model.sign=0;
                                model.iconUrl=@"index_add";
                                [_listModel addObject:model];
                                
                                [_collectionView reloadData];
                            }
                        }
                    }
                        break;
                    case 3:
                    {
                        if(_listModel.count>0 && _modelList.listAllForChecking.count>0)
                        {
                            BOOL isChanged=NO;
                            NSMutableArray *listRemoved=[[NSMutableArray alloc] init];
                            NSMutableArray *listAdd=[[NSMutableArray alloc] init];
                            
                            for(int i=0;i<_listModel.count;i++)
                            {
                                IndexModel *model=[_listModel objectAtIndex:i];
                                if(model.modelid>0)
                                {
                                    int index=-1;
                                    if([_modelList allListForChechingContains:model index:&index])
                                    {
                                        IndexModel *m=[_modelList.listAllForChecking objectAtIndex:index];
                                        if([m.iconUrl isNotNilOrEmptyString] && ![m.iconUrl isEqualToString:model.iconUrl])
                                        {
                                            model.iconUrl=m.iconUrl;
                                            if(!isChanged)
                                                isChanged=YES;
                                        }
                                        if([m.url isNotNilOrEmptyString] && ![m.url isEqualToString:model.url])
                                        {
                                            model.url=m.url;
                                            if(!isChanged)
                                                isChanged=YES;
                                        }
                                    }
                                    else
                                    {
                                        [listRemoved addObject:model];
                                    }
                                }
                            }
                            
                            if(listRemoved.count>0)
                            {
                                if(!isChanged)isChanged=YES;
                                for(int i=0;i<listRemoved.count;i++)
                                {
                                    if([_listModel containsObject:listRemoved[i]])
                                        [_listModel removeObject:listRemoved[i]];
                                }
                            }
                            
                            NSMutableArray *listDelete=[_modelList readDeleteCacheList];
                            
                            for(int i=0;i<_modelList.listAllForChecking.count;i++)
                            {
                                IndexModel *model=[_modelList.listAllForChecking objectAtIndex:i];
                                if(model.modelid>0 && model.isDefault)
                                {
                                    int index=-1;
                                    NSNumber *modelId=[[NSNumber alloc] initWithInteger:model.modelid];
                                    if(![listDelete containsObject:modelId] && ![_modelList list:_listModel isContains:model atIndex:&index])
                                    {
                                        [listAdd addObject:model];
                                    }
                                }
                            }
                            
                            if(listAdd.count>0)
                            {
                                if(!isChanged)isChanged=YES;
                                for(int i=0;i<listAdd.count;i++)
                                {
                                    [_listModel insertObject:listAdd[i] atIndex:_listModel.count-1];
                                }
                            }
                            
                            if(isChanged)
                            {
                                [_collectionView reloadData];
                                
                                [_modelList saveDefaultList:_listModel];
                            }
                        }
                    }
                        break;
                }
            }
            else
            {
                if(nType==1)
                {
                    if(hasNetworkFlags)
                    {
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        [MBProgressHUDManager showWrongWithTitle:@"加载首页模块失败" inView:self.view];
                    }
                }
            }
        }
    }
}

-(void)openModel:(IndexModel *)model
{
    NSLog(@"%ld %d %d",model.sign,model.term_id,model.nav_style);
    switch(model.sign)
    {
        case 0: //添加模块
        {
            AddIndexModelViewController *addVC=[[AddIndexModelViewController alloc] init];
            addVC.hidesBottomBarWhenPushed=YES;
            addVC.modelList=_modelList;
            addVC.listOriginal=_listModel;
            addVC.willDismissBlock=^(NSArray *listAdd, NSMutableArray *listRemovedIndex)
            {
                BOOL isChanged=NO;
                if(listRemovedIndex && listRemovedIndex.count>0)
                {
                    isChanged=YES;
                    
                    NSMutableArray *listDelete=[_modelList readDeleteCacheList];
                    
                    [Common sortList:listRemovedIndex isASC:NO];
                    for(int i=0;i<listRemovedIndex.count;i++)
                    {
                        int index=[listRemovedIndex[i] intValue];
                        if(_listModel.count>index)
                        {
                            IndexModel *model=[_listModel objectAtIndex:index];
                            NSNumber *modelId=[[NSNumber alloc] initWithInteger:model.modelid];
                            if(![listDelete containsObject:modelId])
                            {
                                [listDelete addObject:modelId];
                            }
                            
                            [_listModel removeObjectAtIndex:index];
                        }
                    }
                    
                    [_modelList saveDeleteList:listDelete];
                }
                
                if(listAdd && listAdd.count>0)
                {
                    if(!isChanged)isChanged=YES;
                    
                    for(IndexModel *m in listAdd)
                    {
                        [_listModel insertObject:m atIndex:_listModel.count-1];
                    }
                }
                
                if(isChanged)
                {
                    [_modelList saveDefaultList:_listModel];
                    [_collectionView reloadData];
                }
            };
            [self.navigationController pushViewController:addVC animated:YES];
        }
            break;
        case IndexModelTypeYouhui: //商家优惠
        {
            OffPriceViewController *offpriceVC=[[OffPriceViewController alloc] init];
            offpriceVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:offpriceVC animated:YES];
        }
            break;
        case IndexModelTypeMazu: //妈祖故乡
        {
            MazuViewController *mazuVC=[[MazuViewController alloc] init];
            mazuVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mazuVC animated:YES];
        }
            break;
        case IndexModelTypeShipin: //莆田视频
        {
            VideoViewController *videoVC=[[VideoViewController alloc] init];
            videoVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:videoVC animated:YES];
        }
            break;
        case IndexModelTypeYule: //莆田娱乐（二级分类）
        {
            RecreationChannelListViewController *recreationVC=[[RecreationChannelListViewController alloc] init];
            recreationVC.title = model.modelName;
            recreationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:recreationVC animated:YES];
        }
            break;
        case 5: // 微店
        {
            MiniShopViewController *miniShopVC=[[MiniShopViewController alloc] init];
            miniShopVC.hidesBottomBarWhenPushed=YES;
            miniShopVC.navigationItem.title=model.modelName;
            //            NSLog(@"%@",model.url);
            [self.navigationController pushViewController:miniShopVC animated:YES];
        }
            break;
        case IndexModelTypeWobi: //沃币中心
        {
            if([UserInfo sharedInstance].isLogin)
            {
                WobiViewController  *wobiVC=[[WobiViewController alloc] init];
                wobiVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:wobiVC animated:YES];
            }
            else
            {
                LoginViewController *loginVC=[[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case IndexModelTypeZixun: //本地资讯
        {
            LocalInfoViewController *localInfoVC=[[LocalInfoViewController alloc] init];
            localInfoVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:localInfoVC animated:YES];
        }
            break;
        case IndexModelTypeWobiDuanHuan: //沃币兑换
        {
            WoBiDuanHuanViewController *localInfoVC=[[WoBiDuanHuanViewController alloc] init];
            localInfoVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:localInfoVC animated:YES];
        }
            break;
            
        case IndexModelTypeMeishi: // 莆田美食
        {
            MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
            meishiVC.hidesBottomBarWhenPushed=YES;
            meishiVC.term_id = 14;
            meishiVC.navigationItem.title= model.modelName;
            [self.navigationController pushViewController:meishiVC animated:YES];
        }
            break;
        case 31: //
        {
            [self ShareApp:self.view];
        }
            break;
        case 32: // 莆田美景
        {
            MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
            meishiVC.hidesBottomBarWhenPushed=YES;
            meishiVC.term_id = 15;
            meishiVC.navigationItem.title = model.modelName;
            [self.navigationController pushViewController:meishiVC animated:YES];
        }
            break;
            //        case 11: //
            //        {
            //            MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
            //            meishiVC.hidesBottomBarWhenPushed=YES;
            //            meishiVC.term_id = 22;
            //            meishiVC.navigationItem.title = model.modelName;
            //            [self.navigationController pushViewController:meishiVC animated:YES];
            //        }
            //            break;
            //        case 21: //
            //        {
            //            MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
            //            meishiVC.hidesBottomBarWhenPushed=YES;
            //            meishiVC.term_id = 20;
            //            meishiVC.navigationItem.title = model.modelName;
            //            [self.navigationController pushViewController:meishiVC animated:YES];
            //        }
            //            break;
            //        case 17: //
            //        {
            //            MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
            //            meishiVC.hidesBottomBarWhenPushed=YES;
            //            meishiVC.term_id = 21;
            //            meishiVC.navigationItem.title = model.modelName;
            //            [self.navigationController pushViewController:meishiVC animated:YES];
            //        }
            //            break;
            //        case 33: //
            //        {
            //            MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
            //            meishiVC.hidesBottomBarWhenPushed=YES;
            //            meishiVC.term_id = 23;
            //            meishiVC.navigationItem.title = model.modelName;
            //            [self.navigationController pushViewController:meishiVC animated:YES];
            //        }
            //            break;
        default:
        {
            if (model.nav_style == 1)
            {
                PTWebViewController *webVC=[[PTWebViewController alloc] init];
                webVC.hidesBottomBarWhenPushed=YES;
                webVC.navigationItem.title=model.modelName;
                webVC.urlString=model.url;
                //            NSLog(@"%@",model.url);
                
                [self.navigationController pushViewController:webVC animated:YES];
                
            }
            else if (model.nav_style == 2)
            {
                MeishiViewController *meishiVC=[[MeishiViewController alloc] init];
                meishiVC.hidesBottomBarWhenPushed=YES;
                meishiVC.term_id = model.term_id;
                meishiVC.navigationItem.title = model.modelName;
                [self.navigationController pushViewController:meishiVC animated:YES];
            }
            else
            {
                PTWebViewController *webVC=[[PTWebViewController alloc] init];
                webVC.hidesBottomBarWhenPushed=YES;
                webVC.navigationItem.title=model.modelName;
                webVC.urlString=model.url;
                //            NSLog(@"%@",model.url);
                
                [self.navigationController pushViewController:webVC animated:YES];
            }
            
        }
            break;
    }
}


#pragma mark - EScrollerViewDelegate
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    if(_adInfoList.list.count>index-1)
    {
        AdvertInfo *info=[_adInfoList.list objectAtIndex:index-1];
        if([info.ad_clickurl isNotNilOrEmptyString])
        {
            PTWebViewController *webVC=[[PTWebViewController alloc] init];
            webVC.urlString=info.ad_clickurl;
            webVC.navigationItem.title=info.ad_name;
            webVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - MetroButtonDelegate
-(void)metroButtonDidClick:(UIButton *)button
{
    
}

#pragma mark - IndexModelCellDelegate
-(void)indexModelCellWillDelete:(IndexModelCell *)cell
{
    NSIndexPath *indexPath=[_collectionView indexPathForCell:cell];
    if(indexPath)
    {
        if(_listModel.count>indexPath.item)
        {
            IndexModel *model=[_listModel objectAtIndex:indexPath.item];
            NSMutableArray *listDelete=[_modelList readDeleteCacheList];
            NSNumber *modelId=[[NSNumber alloc] initWithInteger:model.modelid];
            if(![listDelete containsObject:modelId])
            {
                [listDelete addObject:modelId];
                [_modelList saveDeleteList:listDelete];
            }
            
            [_listModel removeObjectAtIndex:indexPath.item];
            
            [_modelList saveDefaultList:_listModel];
        }
        
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    self.isEdittingCell=NO;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isEdittingCell)
    {
        if(_listModel.count>self.edittingItem)
        {
            IndexModel *model=[_listModel objectAtIndex:self.edittingItem];
            model.isEditting=NO;
        }
        
        NSIndexPath *edittingIndexPath=[NSIndexPath indexPathForItem:self.edittingItem inSection:0];
        IndexModelCell *cell=(IndexModelCell *)[collectionView cellForItemAtIndexPath:edittingIndexPath];
        if(cell)
        {
            [cell setMinusButtonVisible:NO];
        }
        self.isEdittingCell=NO;
        return;
    }
    
    if(_listModel.count>indexPath.item)
    {
        IndexModel *model=[_listModel objectAtIndex:indexPath.item];
        [self openModel:model];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    return _listModel.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndexModelCell *cell=nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gIndexModelCellIdentifier" forIndexPath:indexPath];
    
    if(_listModel.count>indexPath.item)
    {
        cell.delegate=self;
        
        IndexModel *model=[_listModel objectAtIndex:indexPath.item];
        if(model.sign==0)
        {
            [cell setAddImageViewRect];
            cell.imageView.image=[UIImage imageNamed:model.iconUrl];
        }
        else
        {
            [cell restoreImageViewRect];
            [cell.imageView setImageWithUrl:model.iconUrl callback:nil];
        }
        cell.lblTitle.text=model.modelName;
        
        if(model.isEditting)
            [cell setMinusButtonVisible:YES];
        else
            [cell setMinusButtonVisible:NO];
    }
    
    [cell setRightLineVisible:YES];
    
    return cell;
}

#pragma mark - LXReorderableCollectionViewDataSource methods
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    self.edittingItem=toIndexPath.item;
    if(_listModel.count>fromIndexPath.item && _listModel.count>toIndexPath.item)
    {
        IndexModel *model=[_listModel objectAtIndex:fromIndexPath.item];
        [_listModel removeObjectAtIndex:fromIndexPath.item];
        [_listModel insertObject:model atIndex:toIndexPath.item];
        
        [_modelList saveDefaultList:_listModel];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
#if LX_LIMITED_MOVEMENT == 1
    //判断是否可移动
    if(_listModel.count>indexPath.item)
    {
        IndexModel *model=[_listModel objectAtIndex:indexPath.item];
        if(model.sign==0)return NO;
    }
    return YES;
#else
    return YES;
#endif
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
#if LX_LIMITED_MOVEMENT == 1
    //判断是否可移动
    if(_listModel.count>fromIndexPath.item && _listModel.count>toIndexPath.item)
    {
        IndexModel *fromModel=[_listModel objectAtIndex:fromIndexPath.item];
        IndexModel *toModel=[_listModel objectAtIndex:toIndexPath.item];
        if(fromModel.sign==0 || toModel.sign==0)return NO;
    }
    return YES;
#else
    return YES;
#endif
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float metroWidth=collectionView.width/IndexModelColumn;
    return CGSizeMake(metroWidth, metroWidth);
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndexModelCell *cell=nil;
    if(self.isEdittingCell)
    {
        if(_listModel.count>_edittingItem)
        {
            IndexModel *model=[_listModel objectAtIndex:_edittingItem];
            model.isEditting=NO;
        }
        cell=(IndexModelCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_edittingItem inSection:0]];
        if(cell)
        {
            [cell setMinusButtonVisible:NO];
        }
    }
    
    if(!self.isEdittingCell)self.isEdittingCell=YES;
    self.edittingItem=indexPath.item;
    if(_listModel.count>indexPath.item)
    {
        IndexModel *model=[_listModel objectAtIndex:indexPath.item];
        model.isEditting=YES;
    }
    cell=(IndexModelCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell)
    {
        [cell setMinusButtonVisible:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)ShareApp:(ViewController *)bar
{
//    NSLog(@"url :%@",disCountDetailURL(_articleInfo.articleid));
    
    
//    NSArray* imageArray = @[_articleInfo.imageUrl];
    //构造分享内容 _articleInfo.title
    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"快来加入指尖上的莆田吧"
                                     images:[UIImage imageNamed:@"shareApp"]
                                        url:[NSURL URLWithString:@"http://viewer.maka.im/k/ORXCZ50R"]
                                      title:@"扫码下载获300M省内流量"
                                       type:SSDKContentTypeAuto];
    
    
    
//    NSLog(@"%@ %@",_articleInfo.title,[NSURL URLWithString:disCountDetailURL(_articleInfo.articleid)]);
    __weak ViewController *theController = self;
    
    
    [ShareSDK showShareActionSheet:bar
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state,
                                     SSDKPlatformType platformType,
                                     NSDictionary *userData,
                                     SSDKContentEntity *contentEntity,
                                     NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
//                           [theController showLoadingView:YES];
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           if (platformType == SSDKPlatformTypeSMS && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、短信应用没有设置帐号；2、设备不支持短信应用；3、短信应用在iOS 7以上才能发送带附件的短信。"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else if(platformType == SSDKPlatformTypeMail && [error code] == 201)
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:@"失败原因可能是：1、邮件应用没有设置帐号；2、设备不支持邮件应用；"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           else
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           //                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                           //                                                                               message:nil
                           //                                                                              delegate:nil
                           //                                                                     cancelButtonTitle:@"确定"
                           //                                                                     otherButtonTitles:nil];
                           //                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
                   
                   if (state != SSDKResponseStateBegin)
                   {
//                       [theController showLoadingView:NO];
                   }
                   
               }];
    
    
    
}

@end
