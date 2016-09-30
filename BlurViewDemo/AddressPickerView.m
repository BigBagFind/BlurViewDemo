//
//  AddressPickerView.m
//  白海带
//
//  Created by 吴玉铁 on 15/12/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "AddressPickerView.h"
#import "UIViewExt.h"
#import "AreaModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define TggRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TggRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kBackgroundViewColor      TggRGBColor(242, 242, 242)
#define TggDeeplyBgViewColor        TggRGBColor(241, 242, 244)
#define kNavBarColor              TggRGBColor(36, 171, 27)


@interface AddressPickerView () <UIPickerViewDataSource, UIPickerViewDelegate> {

    NSString *_provinceName;
    NSString *_cityName;
    NSString *_regionName;
    
    NSInteger _provinceIndex;
    NSInteger _cityIndex;
    NSInteger _regionIndex;
}

// 省份数据
@property (nonatomic, strong) NSMutableArray *provinces;

// 城市数据
@property (nonatomic, strong) NSMutableArray *cities;

// 区县数据
@property (nonatomic, strong) NSMutableArray *regions;



@end


@implementation AddressPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self parseData];
        [self createViews];
    }
    return self;
}

- (void)parseData {
    
    _provinceIndex = 0;
    _cityIndex = 0;
    _regionIndex = 0;
    _provinces = [NSMutableArray array];
    _cities = [NSMutableArray array];
    _regions = [NSMutableArray array];
    
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"ProCityRegion" ofType:@"plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:filename];  //读取数据
    for (NSUInteger i = 0; i < rootDic.allKeys.count; i ++) {
        NSDictionary *dic = [rootDic objectForKey:[NSString stringWithFormat:@"%zd",i]];
        AreaModel *model = [AreaModel new];
        model.name = [dic objectForKey:@"name"];
        model.subArea = [dic objectForKey:model.name];
        [self.provinces addObject:model];
    }
    
    AreaModel *provinceModel = [self.provinces firstObject];
    if (provinceModel.subArea.count > 0) {
        for (NSDictionary *dic in provinceModel.subArea) {
            AreaModel *model = [AreaModel new];
            model.name = [dic objectForKey:@"name"];
            model.subArea = [dic objectForKey:model.name];
            [self.cities addObject:model];
        }
    }
    
    AreaModel *cityModel = [self.cities firstObject];
    if (cityModel.subArea.count > 0) {
        for (NSDictionary *dic in cityModel.subArea) {
            AreaModel *model = [AreaModel new];
            model.name = [dic objectForKey:@"name"];
            [self.regions addObject:model];
        }
    }
}

- (void)createViews {

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    // 选择器
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, (kScreenHeight - 150 - 64) / 2,kScreenWidth, 150)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [self addSubview:_pickerView];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.layer.cornerRadius = 10;
    // 标题
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, _pickerView.top - 35, kScreenWidth - 110, 30)];
    [self addSubview:title];
    title.textColor = kBackgroundViewColor;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"选择省、市、区(县)";
    title.layer.borderWidth = 1;
    title.layer.borderColor = kBackgroundViewColor.CGColor;
    // 确定按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(kScreenWidth - 90, _pickerView.top - 35, 80, 30);
    confirmBtn.backgroundColor = kNavBarColor;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kBackgroundViewColor forState:UIControlStateHighlighted];
    confirmBtn.layer.cornerRadius = 5;
    [confirmBtn addTarget:self action:@selector(confimAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    // 添加手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(confimAction:)];
    [self addGestureRecognizer:tapGes];
}

- (void)confimAction:(UIButton *)button {
    
    AreaModel *provinceModel = self.provinces[_provinceIndex];
    AreaModel *cityModel = self.cities[_cityIndex];
    AreaModel *regionModel = self.regions[_regionIndex];
    
    _provinceName = provinceModel.name;
    _cityName = cityModel.name;
    _regionName = regionModel.name;

    if (self.selectedNamesBlock) {
        self.selectedNamesBlock(_provinceName,_cityName,_regionName);
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.top = kScreenHeight;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark-选择器代理和数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    }else if(component == 1){
        return self.cities.count;
    }else if(component == 2){
        return self.regions.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        AreaModel *model = self.provinces[row];
        return model.name;
    }else if (component == 1){
        AreaModel *model = self.cities[row];
        return model.name;
    }else if (component == 2){
        AreaModel *model = self.regions[row];
        return model.name;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        AreaModel *provinceModel = self.provinces[row];
        NSMutableArray *temp = [NSMutableArray array];
        if (provinceModel.subArea.count > 0) {
            for (NSDictionary *dic in provinceModel.subArea) {
                AreaModel *model = [AreaModel new];
                model.name = [dic objectForKey:@"name"];
                model.subArea = [dic objectForKey:model.name];
                [temp addObject:model];
            }
            self.cities = temp;
            _provinceIndex = row;
            AreaModel *cityModel = [self.cities firstObject];
            NSMutableArray *temp = [NSMutableArray array];
            if (cityModel.subArea.count > 0) {
                for (NSDictionary *dic in cityModel.subArea) {
                    AreaModel *model = [AreaModel new];
                    model.name = [dic objectForKey:@"name"];
                    model.subArea = [dic objectForKey:model.name];
                    [temp addObject:model];
                }
                self.regions = temp;
                _cityIndex = 0;
                _regionIndex = 0;
            }
            [_pickerView reloadComponent:1];
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:1 animated:YES];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
        }
    } else if (component == 1) {
        AreaModel *cityModel = self.cities[row];
        NSMutableArray *temp = [NSMutableArray array];
        if (cityModel.subArea.count > 0) {
            for (NSDictionary *dic in cityModel.subArea) {
                AreaModel *model = [AreaModel new];
                model.name = [dic objectForKey:@"name"];
                [temp addObject:model];
            }
            self.regions = temp;
            _cityIndex = row;
            [_pickerView reloadComponent:2];
            [_pickerView selectRow:0 inComponent:2 animated:YES];
        }
    } else if (component == 2) {
        _regionIndex = row;
        
    }

}




@end
