//
//  ViewController.m
//  BlurViewDemo
//
//  Created by 铁拳科技 on 16/9/29.
//  Copyright © 2016年 铁哥哥. All rights reserved.
//

#import "ViewController.h"
#import "TggBlurredView.h"
#import "AddressPickerView.h"
#import "UIViewExt.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //选择器
    AddressPickerView *pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.top = 0;
    }];
    __weak __typeof(self)weakSelf = self;
    pickerView.selectedNamesBlock = ^(NSString *province,NSString *city,NSString *region){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@ %@ %@",province,city,region);
//        strongSelf.provinceAndSoOn.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,region];
    };
    
    pickerView.selectedCodesBlock = ^(NSString *province,NSString *city,NSString *region){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@ %@ %@",province,city,region);
//        strongSelf->_provinceCode = province;
//        strongSelf->_cityCode = city;
//        strongSelf->_regionCode = region;
    };

    
}



- (IBAction)aciton:(id)sender {
    
    [TggBlurredView viewFromNib];
    
}



- (IBAction)action:(id)sender {
    
    //选择器
    AddressPickerView *pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.top = 0;
    }];
    __weak __typeof(self)weakSelf = self;
    pickerView.selectedNamesBlock = ^(NSString *province,NSString *city,NSString *region){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@ %@ %@",province,city,region);
        //        strongSelf.provinceAndSoOn.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,region];
    };
    
    pickerView.selectedCodesBlock = ^(NSString *province,NSString *city,NSString *region){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSLog(@"%@ %@ %@",province,city,region);
        //        strongSelf->_provinceCode = province;
        //        strongSelf->_cityCode = city;
        //        strongSelf->_regionCode = region;
    };
}





@end
