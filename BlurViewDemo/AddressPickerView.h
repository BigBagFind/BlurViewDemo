//
//  AddressPickerView.h
//  白海带
//
//  Created by 吴玉铁 on 15/12/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AddressPickerViewBlock)(id,id,id);

@interface AddressPickerView : UIView




@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,copy) AddressPickerViewBlock selectedCodesBlock;
@property (nonatomic,copy) AddressPickerViewBlock selectedNamesBlock;


@end
