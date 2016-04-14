//
//  SquareViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/1.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "SquareViewController.h"
#import "MyWebButton.h"
#import "PTWebViewController.h"
#import "SquareCell.h"
#import "AddSquareViewController.h"

#import "SquareInfoList.h"

#import "LXReorderableCollectionViewFlowLayout.h"

#define SquareColumn 3

@interface SquareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,SquareCellDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *listModel;

/** 是否正在编辑cell */
@property (nonatomic,assign) BOOL isEdittingCell;
@property (nonatomic,assign) NSInteger edittingItem;

@property (nonatomic,strong) SquareInfoList *infoList;

@property (nonatomic,assign) BOOL isLoadedView;
/** 是否加载成功 */
@property (nonatomic,assign) BOOL isLoadSucceed;

@property (nonatomic,strong) NSDate *lastLoadDate;

@end

@implementation SquareViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.navigationItem.title=@"广场";
        self.tabBarItem.title=@"广场";
        self.tabBarItem.image=[UIImage imageNamed:@"tabbar_icon_square"];
    }
    return self;
}

-(void)refresh
{
    if(self.isLoadedView)
    {
        if(_listModel.count>0)
        {
            if(_lastLoadDate)
            {
                NSDate *now=[[NSDate alloc] init];
                if([now timeIntervalSinceDate:_lastLoadDate]>=3600*24)
                {
                    [_infoList loadAllDataForChecking];
                }
            }
        }
        else
        {
            [MBProgressHUDManager hideMBProgressInView:self.view];
            [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
            [_infoList loadDefaultData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
//    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeight)];
//    [self.view addSubview:_scrollView];
    
    _listModel=[[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameSquareInfoList object:nil];
    
    _infoList=[[SquareInfoList alloc] init];
    _infoList.notificationName=kNotificationNameSquareInfoList;
    [_infoList readCacheList:_listModel];
    
    if(_listModel.count>0)
    {
        Square *s=[[Square alloc] init];
        s.link_id=0;
        s.link_image=@"index_add";
        [_listModel addObject:s];
        
        [_infoList loadAllDataForChecking];
    }
    else
    {
        [MBProgressHUDManager showIndicatorWithTitle:@"正在加载" inView:self.view];
        
        [_infoList loadDefaultData];
    }
    
    LXReorderableCollectionViewFlowLayout *flowLayout=[[LXReorderableCollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=1;
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, self.marginTop, self.view.width, self.viewHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=[UIColor clearColor];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView registerClass:[SquareCell class] forCellWithReuseIdentifier:@"gSquareCellIdentifier"];
    [self.view addSubview:_collectionView];
    
    self.isLoadedView=YES;
}

-(void)calcIconCountWithTotalWidth:(float)totalWidth width:(float)width baseMarginLeft:(float)marginLeft count:(int *)pcount marginLeft:(float *)pmargin
{
    int maxCount=totalWidth/width;
    for(int i=maxCount;i>0;i--)
    {
        float tmpmargin=(totalWidth-i*width)/(i+1);
        if(tmpmargin>=marginLeft)
        {
            if(pcount)*pcount=i;
            if(pmargin)*pmargin=tmpmargin;
            break;
        }
    }
}
-(void)loadUI
{
//    if(_infoList.list.count>0)
//    {
//        [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        float top=0;
//        float iconWidth=55;
//        float iconMarginLeft=20,iconMarginTop=10;
//        int col=4;
//        [self calcIconCountWithTotalWidth:_scrollView.width width:iconWidth baseMarginLeft:20 count:&col marginLeft:&iconMarginLeft];
//        
//        float lblWidth=iconWidth+iconMarginLeft,lblHeight=18,lblMarginTop=3;
//        
//        UIFont *font1=[UIFont systemFontOfSize:15.0];
//        UIFont *font2=[UIFont systemFontOfSize:12.0];
//        
//        NSString *tmpstr=nil;
//        
//        MyWebButton *webBtn=nil;
//        UILabel *lbl=nil;
//        for(int i=0;i<_infoList.list.count;i++)
//        {
//            SquareInfo *info=[_infoList.list objectAtIndex:i];
//            
//            UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, top, _scrollView.width, 30)];
//            lblTitle.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
//            lblTitle.font=font1;
//            if([info.attrName isNotNilOrEmptyString])
//            {
//                tmpstr=[[NSString alloc] initWithFormat:@" %@",info.attrName];
//                lblTitle.text=tmpstr;
//            }
//            [_scrollView addSubview:lblTitle];
//            
//            top=lblTitle.y+lblTitle.height;
//            for(int j=0;j<info.list.count;j++)
//            {
//                Square *s=[info.list objectAtIndex:j];
//                
//                webBtn=[[MyWebButton alloc] initWithFrame:CGRectMake(iconMarginLeft+(iconMarginLeft+iconWidth)*(j%col), top+iconMarginTop+(iconMarginTop+iconWidth+lblMarginTop+lblHeight)*(j/col), iconWidth, iconWidth)];
////                webBtn.layer.borderColor=[UIColor blackColor].CGColor;
////                webBtn.layer.borderWidth=1;
////                webBtn.layer.cornerRadius=3;
//                webBtn.tag=(i+1)*1000+(j+1)*1;
//                if([s.link_image isNotNilOrEmptyString])
//                    [webBtn setImageWithUrl:s.link_image callback:nil];
//                [webBtn addTarget:self action:@selector(iconTouchUp:) forControlEvents:UIControlEventTouchUpInside];
//                [_scrollView addSubview:webBtn];
//                
//                lbl=[[UILabel alloc] initWithFrame:CGRectMake(webBtn.x-iconMarginLeft/2, webBtn.y+webBtn.height+lblMarginTop, lblWidth, lblHeight)];
//                lbl.textAlignment=NSTextAlignmentCenter;
//                lbl.font=font2;
//                lbl.text=s.link_name;
//                [_scrollView addSubview:lbl];
//            }
//            
//            if(lbl)
//            {
//                top=lbl.y+lbl.height;
//                lbl=nil;
//            }
//            
//            top+=iconMarginTop;
//        }
//        
//        if(top<=_scrollView.height)
//            top=_scrollView.height+1;
//        _scrollView.contentSize=CGSizeMake(_scrollView.width, top);
//    }
}

-(void)iconTouchUp:(MyWebButton *)button
{
//    int index1=button.tag/1000-1;
//    int index2=button.tag%1000-1;
//    if(index1>=0 && index2>=0)
//    {
//        if(_infoList.list.count>index1)
//        {
//            SquareInfo *info=[_infoList.list objectAtIndex:index1];
//            if(info.list.count>index2)
//            {
//                Square *s=[info.list objectAtIndex:index2];
//                if([s.link_url isNotNilOrEmptyString])
//                {
//                    PTWebViewController *webVC=[[PTWebViewController alloc] init];
//                    webVC.urlString=s.link_url;
//                    webVC.navigationItem.title=s.link_name;
//                    webVC.hidesBottomBarWhenPushed=YES;
//                    [self.navigationController pushViewController:webVC animated:YES];
//                }
//            }
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameSquareInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameSquareInfoList])
    {
        if(notification.object==_infoList)
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
                        //[self loadUI];
                        
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        
                        if(_infoList.listDefault.count>0)
                        {
                            self.isLoadSucceed=YES;
                            
                            if(_listModel.count>0)
                                [_listModel removeAllObjects];
                            
                            [_listModel addObjectsFromArray:_infoList.listDefault];
                            
                            [_infoList saveDefaultList:_listModel];
                            
                            Square *s=[[Square alloc] init];
                            s.link_id=0;
                            s.link_image=@"index_add";
                            [_listModel addObject:s];
                            
                            [_collectionView reloadData];
                            
                            NSDate *now=[[NSDate alloc] init];
                            self.lastLoadDate=now;
                        }
                    }
                        break;
                    case 3:
                    {
                        if(_listModel.count>0 && _infoList.listAllForChecking.count>0)
                        {
                            BOOL isChanged=NO;
                            NSMutableArray *listRemoved=[[NSMutableArray alloc] init];
                            NSMutableArray *listAdd=[[NSMutableArray alloc] init];
                            
                            for(int i=0;i<_listModel.count;i++)
                            {
                                Square *model=[_listModel objectAtIndex:i];
                                if(model.link_id>0)
                                {
                                    int index=-1;
                                    if([_infoList allListForChechingContains:model index:&index])
                                    {
                                        Square *m=[_infoList.listAllForChecking objectAtIndex:index];
                                        if([m.link_image isNotNilOrEmptyString] && ![m.link_image isEqualToString:model.link_image])
                                        {
                                            model.link_image=m.link_image;
                                            if(!isChanged)
                                                isChanged=YES;
                                        }
                                        if([m.link_url isNotNilOrEmptyString] && ![m.link_url isEqualToString:model.link_url])
                                        {
                                            model.link_url=m.link_url;
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
                            
                            NSMutableArray *listDelete=[_infoList readDeleteCacheList];
                            
                            for(int i=0;i<_infoList.listAllForChecking.count;i++)
                            {
                                Square *model=[_infoList.listAllForChecking objectAtIndex:i];
                                if(model.link_id>0 && model.isDefault)
                                {
                                    int index=-1;
                                    NSNumber *modelId=[[NSNumber alloc] initWithInteger:model.link_id];
                                    if(![listDelete containsObject:modelId] && ![_infoList list:_listModel isContains:model atIndex:&index])
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
                                
                                [_infoList saveDefaultList:_listModel];
                            }
                        }
                    }
                        break;
                }
            }
            else
            {
                switch(nType)
                {
                    case 1:
                    {
                        self.isLoadSucceed=NO;
                        
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        
                        if(hasNetworkFlags)
                            [MBProgressHUDManager showWrongWithTitle:@"获取数据失败了" inView:self.view];
                        else
                            [MBProgressHUDManager showWrongWithTitle:@"未连接网络" inView:self.view];
                    }
                        break;
                }
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SquareCellDelegate
-(void)squareCellWillDelete:(SquareCell *)cell
{
    NSIndexPath *indexPath=[_collectionView indexPathForCell:cell];
    if(indexPath)
    {
        if(_listModel.count>indexPath.item)
        {
            Square *model=[_listModel objectAtIndex:indexPath.item];
            NSMutableArray *listDelete=[_infoList readDeleteCacheList];
            NSNumber *modelId=[[NSNumber alloc] initWithInteger:model.link_id];
            if(![listDelete containsObject:modelId])
            {
                [listDelete addObject:modelId];
                [_infoList saveDeleteList:listDelete];
            }
            
            [_listModel removeObjectAtIndex:indexPath.item];
            
            [_infoList saveDefaultList:_listModel];
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
            Square *model=[_listModel objectAtIndex:self.edittingItem];
            model.isEditting=NO;
        }
        
        NSIndexPath *edittingIndexPath=[NSIndexPath indexPathForItem:self.edittingItem inSection:0];
        SquareCell *cell=(SquareCell *)[collectionView cellForItemAtIndexPath:edittingIndexPath];
        if(cell)
        {
            [cell setMinusButtonVisible:NO];
        }
        self.isEdittingCell=NO;
        return;
    }
    
    if(_listModel.count>indexPath.item)
    {
        Square *model=[_listModel objectAtIndex:indexPath.item];
        if(model.link_id==0)
        {
            AddSquareViewController *addSquareVC=[[AddSquareViewController alloc] init];
            addSquareVC.hidesBottomBarWhenPushed=YES;
            addSquareVC.infoList=_infoList;
            addSquareVC.listOriginal=_listModel;
            addSquareVC.willDismissBlock=^(NSArray *listAdd, NSMutableArray *listRemovedIndex)
            {
                BOOL isChanged=NO;
                if(listRemovedIndex && listRemovedIndex.count>0)
                {
                    isChanged=YES;
                    
                    NSMutableArray *listDelete=[_infoList readDeleteCacheList];
                    
                    [Common sortList:listRemovedIndex isASC:NO];
                    for(int i=0;i<listRemovedIndex.count;i++)
                    {
                        int index=[listRemovedIndex[i] intValue];
                        if(_listModel.count>index)
                        {
                            Square *model=[_listModel objectAtIndex:index];
                            NSNumber *modelId=[[NSNumber alloc] initWithInteger:model.link_id];
                            if(![listDelete containsObject:modelId])
                            {
                                [listDelete addObject:modelId];
                            }
                            
                            [_listModel removeObjectAtIndex:index];
                        }
                    }
                    
                    [_infoList saveDeleteList:listDelete];
                }
                
                if(listAdd && listAdd.count>0)
                {
                    if(!isChanged)isChanged=YES;
                    
                    for(Square *m in listAdd)
                    {
                        [_listModel insertObject:m atIndex:_listModel.count-1];
                    }
                }
                
                if(isChanged)
                {
                    [_infoList saveDefaultList:_listModel];
                    [_collectionView reloadData];
                }
            };
            [self.navigationController pushViewController:addSquareVC animated:YES];
        }
        else if(model.link_id>0)
        {
            if([model.link_url isNotNilOrEmptyString])
            {
                PTWebViewController *webVC=[[PTWebViewController alloc] init];
                webVC.urlString=model.link_url;
                webVC.navigationItem.title=model.link_name;
                webVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    return _listModel.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SquareCell *cell=nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gSquareCellIdentifier" forIndexPath:indexPath];
    
    if(_listModel.count>indexPath.item)
    {
        cell.delegate=self;
        
        Square *model=[_listModel objectAtIndex:indexPath.item];
        if(model.link_id==0)
        {
            [cell setAddImageViewRect];
            cell.imageView.image=[UIImage imageNamed:model.link_image];
        }
        else
        {
            [cell restoreImageViewRect];
            [cell.imageView setImageWithUrl:model.link_image callback:nil];
        }
        cell.lblTitle.text=model.link_name;
        
        if(model.isEditting)
            [cell setMinusButtonVisible:YES];
        else
            [cell setMinusButtonVisible:NO];
        
    }
    
    if(indexPath.item%SquareColumn<SquareColumn-1)
    {
        [cell setRightLineVisible:YES];
    }
    else
    {
        [cell setRightLineVisible:NO];
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
        Square *model=[_listModel objectAtIndex:fromIndexPath.item];
        [_listModel removeObjectAtIndex:fromIndexPath.item];
        [_listModel insertObject:model atIndex:toIndexPath.item];
        
        [_infoList saveDefaultList:_listModel];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否可移动
    if(_listModel.count>indexPath.item)
    {
        Square *model=[_listModel objectAtIndex:indexPath.item];
        if(model.link_id==0)return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    //判断是否可移动
    if(_listModel.count>fromIndexPath.item && _listModel.count>toIndexPath.item)
    {
        Square *fromModel=[_listModel objectAtIndex:fromIndexPath.item];
        Square *toModel=[_listModel objectAtIndex:toIndexPath.item];
        if(fromModel.link_id==0 || toModel.link_id==0)return NO;
    }
    return YES;
}

#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float metroWidth=collectionView.width/SquareColumn;
    return CGSizeMake(metroWidth, metroWidth);
}
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
    SquareCell *cell=nil;
    if(self.isEdittingCell)
    {
        if(_listModel.count>_edittingItem)
        {
            Square *model=[_listModel objectAtIndex:_edittingItem];
            model.isEditting=NO;
        }
        cell=(SquareCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_edittingItem inSection:0]];
        if(cell)
        {
            [cell setMinusButtonVisible:NO];
        }
    }
    
    if(!self.isEdittingCell)self.isEdittingCell=YES;
    self.edittingItem=indexPath.item;
    if(_listModel.count>indexPath.item)
    {
        Square *model=[_listModel objectAtIndex:indexPath.item];
        model.isEditting=YES;
    }
    cell=(SquareCell *)[collectionView cellForItemAtIndexPath:indexPath];
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

@end
