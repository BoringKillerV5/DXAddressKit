//
//  MapAddressViewController.m
//  Housekeeping
//
//  Created by 张旭 on 2017/10/12.
//  Copyright © 2017年 张旭. All rights reserved.
//

#import "MapAddressViewController.h"
#import "AddressTitleTableViewCell.h"
#import "UIView+Common.h"
#import "UIScrollView+EmptyDataSet.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5
#define defaultTag 10010
@interface MapAddressViewController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSString *searchStr;
    NSDictionary *library;
}

//@property (weak, nonatomic) IBOutlet MAMapView *mapView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (weak, nonatomic) IBOutlet UITextField *TextField;
@property (weak, nonatomic) IBOutlet UITableView *MainTableView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapLocatingCompletionBlock completionBlock;
@property (weak, nonatomic) IBOutlet UIButton *definiteBtn;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (nonatomic, assign) NSInteger btnTag;
@end

@implementation MapAddressViewController
-(void)viewWillAppear:(BOOL)animated{
    // 开启定位
    
    [self.mapView setCompassImage:[UIImage imageNamed:@"compass"]];
    [self.mapView addAnnotations:self.annotations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"服务地址";
    [self initView];
    [self initCompleteBlock];
    [self configLocationManager];
    [self locAction];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapContainerView.bounds;
}
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;

}



- (void)reGeocodeAction
{
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction
{
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}
- (void)initCompleteBlock
{
    __weak MapAddressViewController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //修改label显示内容
        if (regeocode)
        {
//            [weakSelf.displayLabel setText:[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
        }
        else
        {
            NSLog(@"%@",[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
            
            
            AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
            
            request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            request.keywords            = @"商务住宅";
            
            /* 按照距离排序. */
            request.sortrule            = 0;
            request.requireExtension    = YES;
            
            [weakSelf.search AMapPOIAroundSearch:request];
            [weakSelf changeCenterTo:location.coordinate];
        }
    };
}








- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchArray.count != 0) {
        _definiteBtn.selected = YES;
        [_definiteBtn setEnabled:YES];
    }else{
        _definiteBtn.selected = NO;
        [_definiteBtn setEnabled:NO];
    }
    return _searchArray.count;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTitleTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    
    
    AMapPOI *tip = _searchArray[indexPath.row];
    
    customCell.nameLabbel.text = tip.name;
    customCell.addressLabbel.text = tip.address;
    customCell.selectBtn.tag = defaultTag+indexPath.row;
    if (customCell.selectBtn.tag == self.btnTag) {
        customCell.isSelect = YES;
        [customCell.selectBtn setImage:[UIImage imageNamed:@"default_address"] forState:UIControlStateNormal];
        library = [[NSDictionary alloc]init];
        library = @{@"AMapPoi":tip};
    }else{
        customCell.isSelect = NO;
        [customCell.selectBtn setImage:[UIImage imageNamed:@"null_default_address"] forState:UIControlStateNormal];
    }
    __weak AddressTitleTableViewCell *weakCell = customCell;
    __weak MapAddressViewController *weakSelf = self;
    [customCell setQhxSelectBlock:^(BOOL choice,NSInteger btnTag){
        if (choice) {
            [weakCell.selectBtn setImage:[UIImage imageNamed:@"default_address"] forState:UIControlStateNormal];
            weakSelf.btnTag = btnTag;
            NSLog(@"$$$$$$%ld",(long)btnTag);
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
            [weakSelf changeCenterTo:coordinate];
            [weakSelf.MainTableView reloadData];
        }
        else{
            //选中一个之后，再次点击，是未选中状态，图片仍然设置为选中的图片，记录下tag，刷新tableView，这个else 也可以注释不用，tag只记录选中的就可以
            [weakCell.selectBtn setImage:[UIImage imageNamed:@"default_address"] forState:UIControlStateNormal];
            weakSelf.btnTag = btnTag;
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
            [weakSelf changeCenterTo:coordinate];
            [weakSelf.MainTableView reloadData];
            NSLog(@"#####%ld",(long)btnTag);
        }
    }];
    
    customCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return customCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择了%ld行",(long)indexPath.row);
}
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    UIView *view = [[UIView alloc]init];
    view.bounds =CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width-130)/2, -200, 130, 130/13*16)];
    image.image = [UIImage imageNamed:@"吉祥物"];
    [view addSubview:image];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, image.bottom+30, UIScreen.mainScreen.bounds.size.width, 20)];
    title.text = @"暂未找到地址";
    title.textColor = [UIColor grayColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    UILabel * title2 = [[UILabel alloc] initWithFrame:CGRectMake(0, title.bottom+20, UIScreen.mainScreen.bounds.size.width, 20)];
    title2.text = @"您可以试试其他的地址";
    title2.textColor = [UIColor grayColor];
    title2.font = [UIFont systemFontOfSize:16];
    title2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title2];
    return view;
}
- (void)initView{
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [AMapServices sharedServices].enableHTTPS = YES;
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 190)];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass= YES;
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.compassOrigin = CGPointMake(UIScreen.mainScreen.bounds.size.width-100, 20);
    [_mapView setZoomLevel:18 animated:YES];
    
    [self.mapContainerView addSubview:self.mapView];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    [self initAnnotations];
    _searchArray = [NSMutableArray array];
    [_MainTableView registerNib:[UINib nibWithNibName:@"AddressTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [_MainTableView setSeparatorStyle:NO];
    [_TextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.btnTag = defaultTag;
    _definiteBtn.layer.cornerRadius = 5;
    _definiteBtn.layer.masksToBounds = YES;
    _definiteBtn.selected = NO;
    [_definiteBtn setBackgroundImage:[UIImage imageNamed:@"alpha_btn"] forState:UIControlStateNormal];
    [_definiteBtn setBackgroundImage:[UIImage imageNamed:@"purple_btn"] forState:UIControlStateSelected];
}
- (void)changeCenterTo:(CLLocationCoordinate2D)newLoc
{
    [self.mapView setCenterCoordinate:newLoc animated:YES];
}
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self changeCenterTo:coordinate];
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length == 0)
    {
        [self locAction];
        return;
    }
    UITextRange *rang = theTextField.markedTextRange; // 获取非=选中状态文字范围
    
    if (rang == nil) { // 没有非选中状态文字.就是确定的文字输入
        
        //
        if (![searchStr isEqualToString:theTextField.text]) {
            AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
            tips.keywords = theTextField.text;
            tips.city     = @"北京";
            tips.cityLimit = YES; //是否限制城市
            
            [self.search AMapInputTipsSearch:tips];
            searchStr =theTextField.text;
            //            [theTextField resignFirstResponder];
            
        }
        
    }
    
}
- (void)initAnnotations {
    self.annotations = [NSMutableArray array];
    
    MAPointAnnotation *a = [[MAPointAnnotation alloc] init];
    a.lockedToScreen = YES;
    a.title = @"屏幕中心坐标";
    a.lockedScreenPoint = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, 190/2);
    [self.annotations addObject:a];
        
    
    
    
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    
    
    if (wasUserAction == YES) {
        self.btnTag = defaultTag;
        CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
        NSLog(@"lat:%f,   long:%f",coordinate.latitude,coordinate.longitude);
        CLLocationCoordinate2D ret = mapView.centerCoordinate;
        
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        
        request.location            = [AMapGeoPoint locationWithLatitude:ret.latitude longitude:ret.longitude];
        request.keywords            = @"商务住宅";
        /* 按照距离排序. */
        request.sortrule            = 0;
        request.requireExtension    = YES;
        
        [self.search AMapPOIAroundSearch:request];
        
        
        
    }
    
}
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        [self.searchArray removeAllObjects];
        [self.MainTableView reloadData];
        
        return;
    }
    
    [self.searchArray setArray:response.pois];
    
    [self.MainTableView reloadData];
    //解析response获取POI信息，具体解析见 Demo
}
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        [self.searchArray removeAllObjects];
        [self.MainTableView reloadData];
        
        return;
    }
    self.btnTag = defaultTag;
    AMapTip *tip = response.tips[0];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(tip.location.latitude, tip.location.longitude);
    [self changeCenterTo:coordinate];
    
    NSLog(@"%@",response.tips);
    [self.searchArray setArray:response.tips];
    
    [self.MainTableView reloadData];
}
#pragma mark - MAMapviewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        if ([annotation.title isEqualToString:@"屏幕中心坐标"]) {
            static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
            MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
            if (annotationView == nil)
            {
                annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
                
                annotationView.canShowCallout            = NO;
                annotationView.animatesDrop              = YES;
                annotationView.draggable                 = NO;
                
            }
            
//            annotationView.pinColor = MAPinAnnotationColorRed;
            annotationView.image = [UIImage imageNamed:@"redPin_lift"];
            
            return annotationView;
        }
    }
    
    return nil;
}
- (IBAction)definiteAction:(id)sender {
    if (self.definiteSelectBlock) {
        self.definiteSelectBlock(library);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
