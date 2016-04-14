//
//  OffPriceDetailViewController.m
//  PuTian
//
//  Created by guofeng on 15/9/9.
//  Copyright (c) 2015年 guofeng. All rights reserved.
//

#import "OffPriceDetailViewController.h"
#import "EScrollerView.h"
#import "MyWebImage.h"
#import "CouponsDownloadViewController.h"
#import "LoginViewController.h"
#import "CommentView.h"
#import "CommentCell.h"
#import "OffPriceCommentListViewController.h"

#import "OffPriceDetail.h"
#import "AdvertInfoList.h"
#import "UnionOffPriceInfoList.h"
#import "ShopInfo.h"
#import "UserInfo.h"
#import "CommentInfoList.h"
#import "CommentInfo.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>


#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"


#import <Foundation/Foundation.h>



/**
 *  优惠详情URL
 *
 */
#define disCountDetailURL(detailId)  [NSString stringWithFormat:@"http://putian.meidp.com/index.php?g=portal&m=index&a=productinfo&id=%ld",detailId]


@interface OffPriceDetailViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,EScrollerViewDelegate,CommentViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

//@property (nonatomic,strong) EScrollerView *viewAD;

@property (nonatomic,strong) UILabel *lblValidity;

@property (nonatomic,strong) UILabel *lblPrice1Title;
@property (nonatomic,strong) UILabel *lblPrice1;
@property (nonatomic,strong) UILabel *lblPrice2Title;
@property (nonatomic,strong) UILabel *lblPrice2;
@property (nonatomic,strong) UILabel *lblJoinCount;
@property (nonatomic,strong) UILabel *lblJoinCountSuf;
@property (nonatomic,strong) UITextField *txtCount;
@property (nonatomic,strong) UIButton *btnDownload;

@property (nonatomic,strong) UILabel *lblTitle;

/** 展示图容器 */
@property (nonatomic,strong) UIView *imgContainer;

/**  图片名称 */
@property (nonatomic, strong) NSString *imgStr;

/** 商品介绍容器 */
@property (nonatomic,strong) UIView *introContainer;
@property (nonatomic,strong) UILabel *lblIntroduce;

/** 用户评价容器 */
@property (nonatomic,strong) UIView *commentContainer;
@property (nonatomic,strong) UITableView *tbComment;

/** 本店其他优惠信息容器 */
@property (nonatomic,strong) UIView *otherContainer;
@property (nonatomic,strong) MyWebImage *ivOther;
@property (nonatomic,strong) UILabel *lblOther;

/** 店铺信息容器 */
@property (nonatomic,strong) UIView *shopInfoContainer;
@property (nonatomic,strong) UILabel *lblShopName;
@property (nonatomic,strong) UILabel *lblShopAddress;
@property (nonatomic,strong) UILabel *lblShopPhone;
@property (nonatomic,strong) UILabel *lblBusinessTime;

/** 底部工具栏 */
@property (nonatomic,strong) UIView *bottomBar;
@property (nonatomic,strong) CommentView *commentView;
@property (nonatomic,strong) UIButton *btnCollect;

@property (nonatomic,strong) CouponsDownloadViewController *downloadVC;

@property (nonatomic,strong) OffPriceDetail *detail;
@property (nonatomic,strong) CommentInfoList *commentInfoList;
@property (nonatomic,strong) AdvertInfoList *adInfoList;
@property (nonatomic,strong) UnionOffPriceInfoList *unionList;
@property (nonatomic,strong) ShopInfo *shopInfo;

@property (nonatomic,strong) NSMutableArray *arrComment;
/** 提交的评论数 */
@property (nonatomic,assign) NSInteger submitCommentCount;
/** 正在提交的评论 */
@property (nonatomic,strong) CommentInfo *submitComment;

@property (atomic,assign) BOOL isDismiss;

@property (nonatomic,strong) NSObject *lockObject;

@property (nonatomic,strong) OffPriceInfo *dataObject;


/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;


@end

@implementation OffPriceDetailViewController

-(instancetype)initWithObject:(id)obj
{
    if(self = [super init])
    {
        
        if(!self.dataObject)
            self.dataObject = [[OffPriceInfo alloc] init];
        
        self.dataObject = obj;
            
        return self;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavigationLeftButton:1];
    
    self.navigationItem.title=@"优惠详情";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    /**
     Add by zl
    */
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
    
    float adWidth=320*[Common ratioWidthScreenWidthTo320];
    float adHeight=134.152634*[Common ratioWidthScreenWidthTo320];
    _lockObject=[[NSObject alloc] init];
    
    _arrComment=[[NSMutableArray alloc] initWithCapacity:3];
    
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.marginTop-adHeight, self.view.width, self.viewHeightWhenTabBarHided+adHeight)];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    

   
    
    _lblValidity=[[UILabel alloc] initWithFrame:CGRectMake(0,adHeight+5, _scrollView.width, 20)];
    _lblValidity.font=[UIFont systemFontOfSize:14.0];
    _lblValidity.textColor=[UIColor grayColor];
    _lblValidity.text=@"优惠券有效期:";
    [_scrollView addSubview:_lblValidity];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, _lblValidity.y+_lblValidity.height+5, _scrollView.width, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview:line];
    
    _lblPrice1Title=[[UILabel alloc] initWithFrame:CGRectMake(5, line.y+line.height+10, 27, 20)];
    _lblPrice1Title.font=[UIFont systemFontOfSize:13.0];
    _lblPrice1Title.text=@"现价";
    [_scrollView addSubview:_lblPrice1Title];
    
    UIColor *color=[[UIColor alloc] initWithRed:253.0/255 green:104.0/255 blue:154.0/255 alpha:1.0];
    _lblPrice1=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice1Title.x+_lblPrice1Title.width, _lblPrice1Title.y-2, 0, 22)];
    _lblPrice1.font=[UIFont boldSystemFontOfSize:18.0];
    _lblPrice1.textColor=color;
    _lblPrice1.text=@"";
    [_scrollView addSubview:_lblPrice1];
    
    _lblPrice2Title=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice1.x+_lblPrice1.width+10, _lblPrice1Title.y, 27, 20)];
    _lblPrice2Title.font=[UIFont systemFontOfSize:13.0];
    _lblPrice2Title.text=@"原价";
    [_scrollView addSubview:_lblPrice2Title];
    
    _lblPrice2=[[UILabel alloc] initWithFrame:CGRectMake(_lblPrice2Title.x+_lblPrice2Title.width, _lblPrice2Title.y, 0, 20)];
    _lblPrice2.font=[UIFont systemFontOfSize:13.0];
    _lblPrice2.text=@"";
    [_scrollView addSubview:_lblPrice2];
    
    _lblJoinCountSuf=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    _lblJoinCountSuf.font=[UIFont systemFontOfSize:13.0];
    _lblJoinCountSuf.text=@"人参与";
    [_lblJoinCountSuf sizeToFit];
    _lblJoinCountSuf.x=_scrollView.width-_lblJoinCountSuf.width-5;
    _lblJoinCountSuf.y=_lblPrice1Title.y;
    _lblJoinCountSuf.height=20;
    [_scrollView addSubview:_lblJoinCountSuf];
    
    _lblJoinCount=[[UILabel alloc] initWithFrame:CGRectMake(_lblJoinCountSuf.x-55, _lblPrice1Title.y, 55, 20)];
    _lblJoinCount.font=[UIFont systemFontOfSize:13.0];
    _lblJoinCount.textAlignment=NSTextAlignmentRight;
    _lblJoinCount.textColor=kNavigationBarBackgroundColor;
    [_scrollView addSubview:_lblJoinCount];
    
    UIButton *btn=nil;
    
    if(self.sender==1)
    {
        btn=[[UIButton alloc] initWithFrame:CGRectMake(5, _lblJoinCount.y+_lblJoinCount.height+10, 50, 30)];
        btn.layer.borderColor=[UIColor blackColor].CGColor;
        btn.layer.borderWidth=1;
        btn.layer.cornerRadius=3;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"-" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(reduceCount) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        _txtCount=[[UITextField alloc] initWithFrame:CGRectMake(btn.x+btn.width+1, btn.y, 50, 30)];
        _txtCount.layer.borderWidth=1;
        _txtCount.layer.borderColor=[UIColor grayColor].CGColor;
        _txtCount.textAlignment=NSTextAlignmentCenter;
        _txtCount.font=[UIFont systemFontOfSize:15.0];
        _txtCount.text=@"0";
        _txtCount.keyboardType=UIKeyboardTypeNumberPad;
        _txtCount.delegate=self;
        [_scrollView addSubview:_txtCount];
        
        btn=[[UIButton alloc] initWithFrame:CGRectMake(_txtCount.x+_txtCount.width+1, btn.y, btn.width, btn.height)];
        btn.layer.borderColor=[UIColor blackColor].CGColor;
        btn.layer.borderWidth=1;
        btn.layer.cornerRadius=3;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"+" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addCount) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        _btnDownload=[[UIButton alloc] initWithFrame:CGRectMake(btn.x+btn.width+30, btn.y, 70, 30)];
        _btnDownload.layer.cornerRadius=3;
        _btnDownload.titleLabel.font=[UIFont systemFontOfSize:13.0];
        _btnDownload.userInteractionEnabled=NO;
        _btnDownload.backgroundColor=kNavigationBarBackgroundColor;
        [_btnDownload setTitle:@"我要下载" forState:UIControlStateNormal];
        [_btnDownload setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_btnDownload addTarget:self action:@selector(downloadCoupons) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_btnDownload];
    }
    
    if(self.sender==1)
        line=[[UIView alloc] initWithFrame:CGRectMake(0, _btnDownload.y+_btnDownload.height+10, _scrollView.width, 0.5)];
    else
        line=[[UIView alloc] initWithFrame:CGRectMake(0, _lblJoinCount.y+_lblJoinCount.height+10, _scrollView.width, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [_scrollView addSubview:line];
    
    _lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, line.y+line.height+10, _scrollView.width-10, 0)];
    _lblTitle.numberOfLines=0;
    _lblTitle.font=[UIFont systemFontOfSize:14.0];
    _lblTitle.text=@"";
    [_scrollView addSubview:_lblTitle];
    
    
    
    _imgContainer=[[UIView alloc] initWithFrame:CGRectMake(1, _lblTitle.y+_lblTitle.height+5, _scrollView.width-2, 30)];
    _imgContainer.clipsToBounds=YES;
    [_scrollView addSubview:_imgContainer];
    
    
    
    _introContainer=[[UIView alloc] initWithFrame:CGRectMake(0, _imgContainer.y+_imgContainer.height+10, _scrollView.width, 50)];
    _introContainer.clipsToBounds=YES;
    [_scrollView addSubview:_introContainer];
    
    UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _introContainer.width, 30)];
    lbl.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];;
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.text=@" 商品介绍";
    [_introContainer addSubview:lbl];
    
    _lblIntroduce=[[UILabel alloc] initWithFrame:CGRectMake(5, lbl.y+lbl.height+5, _scrollView.width-10, 0)];
    _lblIntroduce.numberOfLines=0;
    _lblIntroduce.font=[UIFont systemFontOfSize:12.0];
    _lblIntroduce.text=@"";
    _lblIntroduce.textColor=[UIColor grayColor];
    [_introContainer addSubview:_lblIntroduce];
    _introContainer.frame=CGRectMake(_introContainer.x, _introContainer.y, _introContainer.width, _lblIntroduce.y+_lblIntroduce.height);
    
    
    _commentContainer=[[UIView alloc] initWithFrame:CGRectMake(0, _introContainer.y+_introContainer.height+20, _scrollView.width, 65)];
    _commentContainer.clipsToBounds=YES;
    [_scrollView addSubview:_commentContainer];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _commentContainer.width, 30)];
    lbl.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.text=@" 用户评论";
    [_commentContainer addSubview:lbl];
    
    _tbComment=[[UITableView alloc] initWithFrame:CGRectMake(5, lbl.y+lbl.height+5, _commentContainer.width-10, 30)];
    _tbComment.delegate=self;
    _tbComment.dataSource=self;
    _tbComment.backgroundColor=[UIColor clearColor];
    _tbComment.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tbComment.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _tbComment.layer.borderWidth=0.5;
    [_commentContainer addSubview:_tbComment];
    
    
    _otherContainer=[[UIView alloc] initWithFrame:CGRectMake(0, _commentContainer.y+_commentContainer.height+20, _scrollView.width, 135)];
    _otherContainer.clipsToBounds=YES;
    [_scrollView addSubview:_otherContainer];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _otherContainer.width, 30)];
    lbl.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.text=@" 本店其他优惠信息";
    [_otherContainer addSubview:lbl];
    
    UIView *border=[[UIView alloc] initWithFrame:CGRectMake(5, lbl.y+lbl.height+5, _otherContainer.width-10, 100)];
    border.layer.cornerRadius=5;
    border.layer.borderWidth=1;
    border.layer.borderColor=[UIColor grayColor].CGColor;
    [_otherContainer addSubview:border];
    
    _ivOther=[[MyWebImage alloc] initWithFrame:CGRectMake(5, 5, 120, 90)];
    [border addSubview:_ivOther];
    
    _lblOther=[[UILabel alloc] initWithFrame:CGRectMake(_ivOther.x+_ivOther.width+10, _ivOther.y, border.width-_ivOther.x*2-_ivOther.width-10, _ivOther.height)];
    _lblOther.numberOfLines=0;
    _lblOther.font=[UIFont systemFontOfSize:12.0];
    _lblOther.text=@"";
    [border addSubview:_lblOther];
    
    
    
    _shopInfoContainer=[[UIView alloc] initWithFrame:CGRectMake(0, _otherContainer.y+_otherContainer.height+20, _scrollView.width, 195)];
    [_scrollView addSubview:_shopInfoContainer];
    
    lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, _shopInfoContainer.width, 30)];
    lbl.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
    lbl.font=[UIFont systemFontOfSize:14.0];
    lbl.text=@" 店铺信息";
    [_shopInfoContainer addSubview:lbl];
    
    float cellHeight=40;
    border=[[UIView alloc] initWithFrame:CGRectMake(5, lbl.y+lbl.height+5, _shopInfoContainer.width-10, cellHeight*4)];
    border.layer.cornerRadius=5;
    border.layer.borderWidth=1;
    border.layer.borderColor=[UIColor grayColor].CGColor;
    [_shopInfoContainer addSubview:border];
    
    _lblShopName=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, border.width-10, cellHeight)];
    _lblShopName.font=[UIFont systemFontOfSize:12.0];
    _lblShopName.text=@"店名：";
    [border addSubview:_lblShopName];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, cellHeight, border.width, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    [border addSubview:line];
    
    _lblShopAddress=[[UILabel alloc] initWithFrame:CGRectMake(_lblShopName.x, cellHeight, _lblShopName.width, cellHeight)];
    _lblShopAddress.font=[UIFont systemFontOfSize:12.0];
    _lblShopAddress.text=@"地址：";
    [border addSubview:_lblShopAddress];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, cellHeight*2, border.width, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    [border addSubview:line];
    
    _lblShopPhone=[[UILabel alloc] initWithFrame:CGRectMake(_lblShopName.x, cellHeight*2, _lblShopName.width, cellHeight)];
    _lblShopPhone.font=[UIFont systemFontOfSize:12.0];
    _lblShopPhone.text=@"电话：";
    [border addSubview:_lblShopPhone];
    
    line=[[UIView alloc] initWithFrame:CGRectMake(0, cellHeight*3, border.width, 0.5)];
    line.backgroundColor=[UIColor grayColor];
    [border addSubview:line];
    
    _lblBusinessTime=[[UILabel alloc] initWithFrame:CGRectMake(_lblShopName.x, cellHeight*3, _lblShopName.width, cellHeight)];
    _lblBusinessTime.font=[UIFont systemFontOfSize:12.0];
    _lblBusinessTime.text=@"营业时间：";
    [border addSubview:_lblBusinessTime];
    
    
    
    _bottomBar=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-40, self.view.width, 40)];
    [self.view addSubview:_bottomBar];
    
    UIImageView *barBG=[[UIImageView alloc] initWithFrame:_bottomBar.bounds];
    barBG.image=[UIImage imageNamed:@"youhui_tabbar_bg"];
    [_bottomBar addSubview:barBG];
    
    float tmpwidth=40;
    float tmpleft=40;
    float tmpmargin=(_bottomBar.width-3*tmpleft-4*tmpwidth)/2.0;
    btn=[[UIButton alloc] initWithFrame:CGRectMake(tmpleft, 0, tmpwidth, tmpwidth)];
    [btn setImage:[UIImage imageNamed:@"youhui_comment_nor"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commentTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:btn];
    
    _btnCollect=[[UIButton alloc] initWithFrame:CGRectMake(btn.x+tmpwidth+tmpmargin, 0, tmpwidth, tmpwidth)];
    [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_nor"] forState:UIControlStateNormal];
    [_btnCollect addTarget:self action:@selector(collectTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:_btnCollect];
    
    btn=[[UIButton alloc] initWithFrame:CGRectMake(_btnCollect.x+tmpwidth+tmpmargin, 0, tmpwidth, tmpwidth)];
    [btn setImage:[UIImage imageNamed:@"youhui_tel_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(callPhoneTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:btn];
    
    
    btn=[[UIButton alloc] initWithFrame:CGRectMake(btn.x+tmpwidth+tmpmargin, 0, tmpwidth, tmpwidth)];
    [btn setImage:[UIImage imageNamed:@"youhui_share_btn_x"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBar addSubview:btn];
    
    _scrollView.contentSize=CGSizeMake(_scrollView.width, _shopInfoContainer.y+_shopInfoContainer.height+20+_bottomBar.height);
    
    
    //    float tmpWidth=50;
    //    UIButton *btnComment=[[UIButton alloc] initWithFrame:CGRectMake(self.view.width-tmpWidth*2-20, self.view.height-tmpWidth-10, tmpWidth, tmpWidth)];
    //    btnComment.clipsToBounds=YES;
    //    btnComment.layer.cornerRadius=tmpWidth/2.0;
    //    btnComment.titleLabel.font=[UIFont systemFontOfSize:14.0];
    //    btnComment.backgroundColor=kNavigationBarBackgroundColorWithAlpha(0.8);
    //    [btnComment setTitle:@"评论" forState:UIControlStateNormal];
    //    [btnComment setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //    [self.view addSubview:btnComment];
    //
    //    UIButton *btnCollect=[[UIButton alloc] initWithFrame:CGRectMake(btnComment.x+tmpWidth+10, btnComment.y, tmpWidth, tmpWidth)];
    //    btnCollect.clipsToBounds=YES;
    //    btnCollect.layer.cornerRadius=tmpWidth/2.0;
    //    btnCollect.titleLabel.font=[UIFont systemFontOfSize:14.0];
    //    btnCollect.backgroundColor=kNavigationBarBackgroundColorWithAlpha(0.8);
    //    [btnCollect setTitle:@"收藏" forState:UIControlStateNormal];
    //    [btnCollect setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    //    [self.view addSubview:btnCollect];
    
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    tap.delegate=self;
    [self.view addGestureRecognizer:tap];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameUnionOffPriceInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameOffPriceDetail object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameCommentInfoList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameShopInfo object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationNameAdvertInfoList object:nil];
    
    _unionList=[[UnionOffPriceInfoList alloc] init];
    _unionList.notificationName=kNotificationNameUnionOffPriceInfoList;
    
    _detail=[[OffPriceDetail alloc] init];
    _detail.notificationName=kNotificationNameOffPriceDetail;
    _detail.productid=_productid;
    if([UserInfo sharedInstance].isLogin)
        _detail.userid=[UserInfo sharedInstance].userid;
    [_detail loadData];
    
    _commentInfoList=[[CommentInfoList alloc] init];
    _commentInfoList.notificationName=kNotificationNameCommentInfoList;
    _commentInfoList.post_id=_productid;
    _commentInfoList.commentType=2;
    [_commentInfoList loadDataWithSlideType:SlideTypeNormal];
    
    _shopInfo=[[ShopInfo alloc] init];
    _shopInfo.notificationName=kNotificationNameShopInfo;
    
    
    // 优惠详情头部ScrollerView
//    _viewAD=[[EScrollerView alloc] initWithFrame:CGRectMake(0, 0, adWidth, adHeight) isShowTitle:YES];
//    _viewAD.delegate=self;
//    [_scrollView addSubview:_viewAD];
    
    _adInfoList=[[AdvertInfoList alloc] init];
    _adInfoList.notificationName=kNotificationNameAdvertInfoList;
    _adInfoList.type=AdvertTypeCoupons;
    
    [_adInfoList loadData];
}

-(void)leftButtonTouchUp
{
    self.isDismiss=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commentTouchUp
{
    if(![UserInfo sharedInstance].isLogin)
    {
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    _detail.userid=[UserInfo sharedInstance].userid;
    
    _commentView=[[CommentView alloc] initWithFrame:self.view.bounds];
    _commentView.delegate=self;
    [self.view addSubview:_commentView];
}
-(void)collectTouchUp
{
    if(![UserInfo sharedInstance].isLogin)
    {
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    _detail.userid=[UserInfo sharedInstance].userid;
    
    [_detail collect:!_detail.isCollect];
}
-(void)callPhoneTouchUp
{
    if([_shopInfo.phone isNotNilOrEmptyString])
    {
        NSString *urlString=[[NSString alloc] initWithFormat:@"telprompt://%@",_shopInfo.phone];
        NSURL *url=[[NSURL alloc] initWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [MBProgressHUDManager showTextWithTitle:@"暂无店铺联系电话" inView:self.view];
    }
}


#pragma mark -

/**
 *  显示加载动画
 *
 *  @param flag YES 显示，NO 不显示
 */
- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}

/**
 *  分享按钮点击事件
 *
 *  @param sender 事件对象
 */
- (void)shareButtonClickHandler:(id)sender
{
    NSLog(@"url :%@",disCountDetailURL(self.dataObject.productid));
    
    
    NSArray* imageArray = @[self.dataObject.imageUrl];
    //构造分享内容
    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.dataObject.introduce images:imageArray url:[NSURL URLWithString:disCountDetailURL(self.dataObject.productid)] title:self.dataObject.title type:SSDKContentTypeAuto];
    __weak OffPriceDetailViewController *theController = self;

    
    [ShareSDK showShareActionSheet:sender
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           [theController showLoadingView:YES];
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
                       [theController showLoadingView:NO];
                   }
                   
               }];
    
    
    
    
    
    /*
    //弹出分享菜单
    [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state,NSDictionary *userData,SSDKContentEntity *contentEntity,NSError  *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView  *alertView=[[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                 [alertView show];
                 
                 
             }
                 break;
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
                 break;
             case SSDKResponseStateCancel:
             {
                 
             }
                 break;
             
             default:
                 break;
         }
     }];
     */
}

-(void)addCount
{
    NSInteger count=[_txtCount.text integerValue]+1;
    if(count>_detail.inventory)return;
    _txtCount.text=[@(count) stringValue];
}
-(void)reduceCount
{
    NSInteger count=[_txtCount.text integerValue]-1;
    if(count<0)count=0;
    _txtCount.text=[@(count) stringValue];
}
-(void)downloadCoupons
{
    if(![UserInfo sharedInstance].isLogin)
    {
        LoginViewController *loginVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    if(_detail.inventory<=0)
    {
        [MBProgressHUDManager showTextWithTitle:@"优惠券已经卖完啦" inView:self.view];
        return;
    }
    NSInteger count=[_txtCount.text integerValue];
    if(count<=0)
    {
        [MBProgressHUDManager showTextWithTitle:@"优惠券数量不能为0" inView:self.view];
        return;
    }
    if(count>_detail.inventory)
    {
        NSString *msg=[[NSString alloc] initWithFormat:@"剩余优惠券已不足%d",count];
        [MBProgressHUDManager showTextWithTitle:msg inView:self.view];
        return;
    }
    
    _downloadVC=[[CouponsDownloadViewController alloc] init];
    _downloadVC.productid=_detail.productid;
    _downloadVC.price=_detail.saleprice;
    _downloadVC.count=count;
    _downloadVC.inventory=_detail.inventory;
    if([_shopInfo.shopName isNotNilOrEmptyString])
        _downloadVC.shopName=_shopInfo.shopName;
    __weak OffPriceDetailViewController *weakSelf=self;
    _downloadVC.dismissEventBlock=^()
    {
        weakSelf.downloadVC=nil;
    };
    [self.navigationController pushViewController:_downloadVC animated:YES];
}

-(void)loadBigImage
{
    [_imgContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(_detail.photos && _detail.photos.count>0)
    {
        for(NSDictionary *tmpdic in _detail.photos)
        {
            NSString *tmpurl=[tmpdic objectForKey:@"url"];
            //NSString *tmpalt=[tmpdic objectForKey:@"alt"];
            if([tmpurl isNotNilOrEmptyString])
            {
                MyWebImage *webImg=[[MyWebImage alloc] initWithFrame:CGRectZero];
                __weak MyWebImage *weakImg=webImg;
                [webImg setImageWithUrl:tmpurl callback:^(BOOL succeed)
                 {
                     if(succeed && !self.isDismiss)
                     {
                         @synchronized(_lockObject)
                         {
                             float width=_imgContainer.width;
                             float height=width*weakImg.image.size.height/weakImg.image.size.width;
                             weakImg.width=width;
                             weakImg.height=height;
                             
                             float containerHeight=height;
                             for(int i=1;i<_imgContainer.subviews.count;i++)
                             {
                                 UIView *tmpview0=[_imgContainer.subviews objectAtIndex:i-1];
                                 UIView *tmpview1=[_imgContainer.subviews objectAtIndex:i];
                                 tmpview1.y=tmpview0.y+tmpview0.height+5;
                                 
                                 containerHeight=tmpview1.y+tmpview1.height+1;
                             }
                             
                             _imgContainer.height=containerHeight;
                             
                             _introContainer.y=_imgContainer.y+_imgContainer.height+10;
                             _commentContainer.y=_introContainer.y+_introContainer.height+20;
                             _otherContainer.y=_commentContainer.y+_commentContainer.height+20;
                             _shopInfoContainer.y=_otherContainer.y+_otherContainer.height+20;
                             _scrollView.contentSize=CGSizeMake(_scrollView.width, _shopInfoContainer.y+_shopInfoContainer.height+20+_bottomBar.height);
                             
                             if(_bottomBar.superview==_scrollView)
                             {
                                 _bottomBar.y=_scrollView.contentSize.height-_bottomBar.height;
                             }
                         }
                     }
                 }];
                [_imgContainer addSubview:webImg];
            }
        }
    }
    
    //    if([_detail.thumbimg isNotNilOrEmptyString])
    //    {
    //        MyWebImage *webImg=[[MyWebImage alloc] initWithFrame:_imgContainer.bounds];
    //        __weak MyWebImage *weakImg=webImg;
    //        [webImg setImageWithUrl:_detail.thumbimg callback:^(BOOL succeed)
    //         {
    //             if(succeed && !self.isDismiss)
    //             {
    //                 float width=_imgContainer.width;
    //                 float height=width*weakImg.image.size.height/weakImg.image.size.width;
    //                 weakImg.width=width;
    //                 weakImg.height=height;
    //
    //                 _imgContainer.width=width;
    //                 _imgContainer.height=height;
    //
    //                 _introContainer.y=_imgContainer.y+_imgContainer.height+5;
    //                 _otherContainer.y=_introContainer.y+_introContainer.height+10;
    //                 _shopInfoContainer.y=_otherContainer.y+_otherContainer.height+10;
    //                 _scrollView.contentSize=CGSizeMake(_scrollView.width, _shopInfoContainer.y+_shopInfoContainer.height+3);
    //             }
    //         }];
    //        [_imgContainer addSubview:webImg];
    //    }
}
-(void)loadIntroduce
{
    if([_detail.introduce isNotNilOrEmptyString])
    {
        _lblIntroduce.text=_detail.introduce;
        [_lblIntroduce sizeToFit];
        
        _introContainer.height=_lblIntroduce.y+_lblIntroduce.height;
    }
}
-(void)loadComment
{
    if(_arrComment.count>0)
    {
        @synchronized(_lockObject)
        {
            _commentContainer.height=65+_arrComment.count*60;
            _tbComment.height=30+_arrComment.count*60;
            _otherContainer.y=_commentContainer.y+_commentContainer.height+20;
            _shopInfoContainer.y=_otherContainer.y+_otherContainer.height+20;
            _scrollView.contentSize=CGSizeMake(_scrollView.width, _shopInfoContainer.y+_shopInfoContainer.height+20+_bottomBar.height);
        }
        
        [_tbComment reloadData];
    }
}
-(void)loadUnion
{
    if(_unionList.list.count>0)
    {
        OffPriceInfo *info=[_unionList.list objectAtIndex:0];
        if([info.imageUrl isNotNilOrEmptyString])
            [_ivOther setImageWithUrl:info.imageUrl callback:nil];
        _lblOther.text=info.title;
//        NSLog(@"JCK ---%@",info.imageUrl);
        self.imgStr = info.imageUrl;
    }
}
-(void)loadShopInfo
{
    NSString *tmpstr=nil;
    if([_shopInfo.shopName isNotNilOrEmptyString])
    {
        tmpstr=[[NSString alloc] initWithFormat:@"店名：%@",_shopInfo.shopName];
        _lblShopName.text=tmpstr;
        
        if(_downloadVC)
            _downloadVC.shopName=_shopInfo.shopName;
    }
    if([_shopInfo.address isNotNilOrEmptyString])
    {
        tmpstr=[[NSString alloc] initWithFormat:@"地址：%@",_shopInfo.address];
        _lblShopAddress.text=tmpstr;
    }
    if([_shopInfo.phone isNotNilOrEmptyString])
    {
        tmpstr=[[NSString alloc] initWithFormat:@"电话：%@",_shopInfo.phone];
        _lblShopPhone.text=tmpstr;
    }
    if([_shopInfo.businessTime isNotNilOrEmptyString])
    {
        tmpstr=[[NSString alloc] initWithFormat:@"营业时间：%@",_shopInfo.businessTime];
        _lblBusinessTime.text=tmpstr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_detail disposeRequest];
    [_commentInfoList disposeRequest];
    [_adInfoList disposeRequest];
    [_unionList disposeRequest];
    [_shopInfo disposeRequest];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameUnionOffPriceInfoList object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameOffPriceDetail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameCommentInfoList object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameShopInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationNameAdvertInfoList object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:kNotificationNameOffPriceDetail])
    {
        if(notification.object==_detail)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL hasNetworkFlags=[[userInfo objectForKey:kNotificationNetworkFlagsKey] boolValue];
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            BOOL hasData=[[userInfo objectForKey:kNotificationContentKey] boolValue];
            NSString *message=[userInfo objectForKey:kNotificationMessageKey];
            NSInteger nType=[[userInfo objectForKey:kNotificationTypeKey] integerValue];
            if(succeed)
            {
                switch(nType)
                {
                    case 1: //加载数据
                    {
                        if(hasData)
                        {
                            if(self.sender==1)
                                _btnDownload.userInteractionEnabled=YES;
                            
                            if(_detail.isCollect)
                            {
                                [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_pre"] forState:UIControlStateNormal];
                            }
                            
                            if(self.sender==1 && _detail.inventory>0)
                                _txtCount.text=@"1";
                            
                            NSString *tmpstr=nil;
                            
                            if([_detail.validity_start isNotNilOrEmptyString] && [_detail.validity_end isNotNilOrEmptyString])
                            {
                                tmpstr=[[NSString alloc] initWithFormat:@"优惠券有效期:%@--%@",_detail.validity_start,_detail.validity_end];
                                _lblValidity.text=tmpstr;
                            }
                            
                            NSInteger tmpprice=_detail.saleprice;
                            if(tmpprice==_detail.saleprice)
                                tmpstr=[[NSString alloc] initWithFormat:@"￥%d",tmpprice];
                            else
                                tmpstr=[[NSString alloc] initWithFormat:@"￥%.2f",_detail.saleprice];
                            _lblPrice1.text=tmpstr;
                            [_lblPrice1 sizeToFit];
                            
                            _lblPrice2Title.x=_lblPrice1.x+_lblPrice1.width+10;
                            
                            tmpprice=_detail.marketprice;
                            if(tmpprice==_detail.marketprice)
                                tmpstr=[[NSString alloc] initWithFormat:@"￥%d",tmpprice];
                            else
                                tmpstr=[[NSString alloc] initWithFormat:@"￥%.2f",_detail.marketprice];
                            _lblPrice2.text=tmpstr;
                            [_lblPrice2 sizeToFit];
                            _lblPrice2.x=_lblPrice2Title.x+_lblPrice2Title.width;
                            _lblPrice2.y=_lblPrice2Title.y;
                            _lblPrice2.height=_lblPrice2Title.height;
                            
                            _lblJoinCount.text=[@(_detail.buyerCount) stringValue];
                            
                            @synchronized(_lockObject)
                            {
                                _lblTitle.text=_detail.productName;
                                [_lblTitle sizeToFit];
                                
                                [self loadIntroduce];
                                
                                _imgContainer.y=_lblTitle.y+_lblTitle.height+5;
                                _introContainer.y=_imgContainer.y+_imgContainer.height+10;
                                _commentContainer.y=_introContainer.y+_introContainer.height+20;
                                _otherContainer.y=_commentContainer.y+_commentContainer.height+20;
                                _shopInfoContainer.y=_otherContainer.y+_otherContainer.height+20;
                                _scrollView.contentSize=CGSizeMake(_scrollView.width, _shopInfoContainer.y+_shopInfoContainer.height+20+_bottomBar.height);
                                
                                if(_bottomBar.superview==_scrollView)
                                {
                                    _bottomBar.y=_scrollView.contentSize.height-_bottomBar.height;
                                }
                            }
                            
                            [self loadBigImage];
                            
                            _unionList.shopid=_detail.shopid;
                            [_unionList loadDataWithNumber:1];
                            
                            _shopInfo.shopid=_detail.shopid;
                            [_shopInfo loadData];
                        }
                    }
                        break;
                    case 2: //提交评论
                    {
                        self.submitCommentCount++;
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        if(_commentView)
                        {
                            [_commentView removeFromSuperview];
                            self.commentView=nil;
                        }
                        if(_submitComment)
                        {
                            if(_arrComment.count>=3)[_arrComment removeLastObject];
                            [_arrComment insertObject:_submitComment atIndex:0];
                            [self loadComment];
                        }
                        [MBProgressHUDManager showSuccessWithTitle:@"发布成功" inView:self.view];
                    }
                        break;
                    case 3: //收藏
                    {
                        NSString *msg=@"";
                        if(_detail.isCollect)
                        {
                            msg=@"收藏成功";
                            [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_pre"] forState:UIControlStateNormal];
                        }
                        else
                        {
                            msg=@"取消成功";
                            [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_nor"] forState:UIControlStateNormal];
                        }
                        [MBProgressHUDManager showSuccessWithTitle:msg inView:self.view];
                    }
                        break;
                }
            }
            else
            {
                NSString *msg=@"";
                switch(nType)
                {
                    case 1:
                        if(hasNetworkFlags)msg=@"获取数据失败了";
                        else msg=@"未连接网络";
                        break;
                    case 2:
                        [MBProgressHUDManager hideMBProgressInView:self.view];
                        if(hasNetworkFlags)msg=@"提交失败";
                        else msg=@"未连接网络";
                        break;
                    case 3:
                        if([message isNotNilOrEmptyString] && [message rangeOfString:@"已收藏"].location!=NSNotFound)
                        {
                            [_btnCollect setImage:[UIImage imageNamed:@"youhui_collect_pre"] forState:UIControlStateNormal];
                            [MBProgressHUDManager showSuccessWithTitle:@"您已收藏" inView:self.view];
                            return;
                        }
                        else
                        {
                            if(hasNetworkFlags)
                            {
                                if(_detail.isCollect)
                                    msg=@"取消失败";
                                else
                                    msg=@"收藏失败";
                            }
                            else
                            {
                                msg=@"未连接网络";
                            }
                        }
                        break;
                }
                if([msg isNotNilOrEmptyString])
                    [MBProgressHUDManager showWrongWithTitle:msg inView:self.view];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameAdvertInfoList])
    {
        if(notification.object==_adInfoList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
//              [_viewAD fillAdvertData:_adInfoList];
                NSLog(@"JCK--%@",self.imgStr);
//                [_viewAD fillAdvertData:_adInfoList ImgStr:self.imgStr];

//                [_viewAD startAutoPlayWithInterval:3];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameUnionOffPriceInfoList])
    {
        if(notification.object==_unionList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                [self loadUnion];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameShopInfo])
    {
        if(notification.object==_shopInfo)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            BOOL hasData=[[userInfo objectForKey:kNotificationContentKey] boolValue];
            if(succeed && hasData)
            {
                [self loadShopInfo];
            }
        }
    }
    else if([notification.name isEqualToString:kNotificationNameCommentInfoList])
    {
        if(notification.object==_commentInfoList)
        {
            NSDictionary *userInfo=notification.userInfo;
            BOOL succeed=[[userInfo objectForKey:kNotificationSucceedKey] boolValue];
            if(succeed)
            {
                for(int i=0;i<_commentInfoList.list.count && i<3;i++)
                {
                    [_arrComment addObject:[_commentInfoList.list objectAtIndex:i]];
                }
                [self loadComment];
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(_txtCount.isFirstResponder)
    {
        [_txtCount resignFirstResponder];
        return YES;
    }
    return NO;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tmpstr=nil;
    if([textField.text isNotNilOrEmptyString])
        tmpstr=[textField.text stringByReplacingCharactersInRange:range withString:string];
    else
        tmpstr=string;
    if([tmpstr integerValue]>_detail.inventory)
        return NO;
    return YES;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    float tmp=scrollView.contentOffset.y+scrollView.height;
    //    if(tmp>=scrollView.contentSize.height)
    //    {
    //        if(_bottomBar.superview!=scrollView)
    //        {
    //            [_bottomBar removeFromSuperview];
    //
    //            _bottomBar.y=scrollView.contentSize.height-_bottomBar.height;
    //            [scrollView addSubview:_bottomBar];
    //        }
    //    }
    //    else
    //    {
    //        if(_bottomBar.superview==scrollView)
    //        {
    //            [_bottomBar removeFromSuperview];
    //
    //            _bottomBar.y=self.view.height-_bottomBar.height;
    //            [self.view addSubview:_bottomBar];
    //        }
    //    }
}

#pragma mark - CommentViewDelegate
-(void)commentViewDidClose:(CommentView *)commentView
{
    if(_commentView)
    {
        [_commentView removeFromSuperview];
        self.commentView=nil;
    }
}
-(void)commentViewDidSubmit:(CommentView *)commentView
{
    [MBProgressHUDManager showIndicatorWithTitle:@"正在提交" inView:self.view];
    
    if(_submitComment)self.submitComment=nil;
    
    _submitComment=[[CommentInfo alloc] init];
    _submitComment.grade=commentView.grade;
    _submitComment.gradeType=commentView.gradeType;
    _submitComment.comment=commentView.comment;
    _submitComment.date=[NSDate date];
    _submitComment.userNickName=[UserInfo sharedInstance].nickname;
    [_detail comment:_submitComment];
}

#pragma mark - EScrollerViewDelegate
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    float temp=keyboardRect.size.height-(self.view.height-_txtCount.y-_txtCount.height-_scrollView.y+_scrollView.contentOffset.y);
    if(temp>0)
    {
        [UIView animateWithDuration:animationDuration animations:^
         {
             self.view.frame=CGRectMake(self.view.x, -temp, self.view.width, self.view.height);
         }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if(self.view.y!=0)
    {
        [UIView animateWithDuration:animationDuration animations:^
         {
             self.view.frame=CGRectMake(self.view.x, 0, self.view.width, self.view.height);
         }];
    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==_arrComment.count)return CommentCellHeight/2;
    return CommentCellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==3)
    {
        if(_commentInfoList.recordCount+self.submitCommentCount>_arrComment.count)
        {
            OffPriceCommentListViewController *commentListVC=[[OffPriceCommentListViewController alloc] init];
            commentListVC.productid=_detail.productid;
            [self.navigationController pushViewController:commentListVC animated:YES];
        }
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrComment.count>3)return 4;
    return _arrComment.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell=nil;
    if(_arrComment.count>indexPath.row)
    {
        CommentCell *cell=[[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"gCommentInfoCellIdentifier" frame:CGRectMake(0, 0, tableView.width, CommentCellHeight)];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        CommentInfo *model=[_arrComment objectAtIndex:indexPath.row];
        cell.userNickName=model.userNickName;
        cell.grade=model.grade;
        cell.date=model.date;
        cell.comment=model.comment;
        
        tableViewCell=cell;
        tableViewCell.hidden = YES;
    }
    else if(indexPath.row==_arrComment.count)
    {
        tableViewCell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.width, CommentCellHeight/2)];
        tableViewCell.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1.0];
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, CommentCellHeight/2)];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:12.0];
        if(_commentInfoList.recordCount+self.submitCommentCount>_arrComment.count)
            lbl.text=@"查看全部评论";
        else if(_arrComment.count>0)
            lbl.text=@"暂无更多评论";
        else
            lbl.text=@"暂无评论";
        [tableViewCell.contentView addSubview:lbl];
    }
    
    return tableViewCell;
}

@end
