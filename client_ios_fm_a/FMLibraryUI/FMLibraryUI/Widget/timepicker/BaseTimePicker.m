//
//  BaseTimePicker.m
//  client_ios_fm_a
//
//  Created by 杨帆 on 16/4/21.
//  Copyright © 2016年 flynn. All rights reserved.
//

#import "BaseTimePicker.h"
#import "FMTheme.h"
#import "FMSize.h"
#import "FMUtils.h"
#import "FMFont.h"
#import "BaseBundle.h"

@interface BaseTimePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (readwrite, nonatomic, strong) UIView * controlView;
@property (readwrite, nonatomic, strong) UIButton * cancelBtn;
@property (readwrite, nonatomic, strong) UIButton * okBtn;

@property (readwrite, nonatomic, strong) UIPickerView * timePicker;

@property (readwrite, nonatomic, strong) NSMutableArray * leftArray;
@property (readwrite, nonatomic, strong) NSMutableArray * middleArray;
@property (readwrite, nonatomic, strong) NSMutableArray * rightArray;
@property (readwrite, nonatomic, assign) NSInteger compontentsCount;

@property (readwrite, nonatomic, strong) NSNumber * date;   //初始日期
@property (readwrite, nonatomic, strong) NSNumber * centerDate; //参考日期

@property (readwrite, nonatomic, strong) NSNumber * minDate;    //日期最小边界值，值为 nil 时不限
@property (readwrite, nonatomic, strong) NSNumber * maxDate;    //日期最大边界值，值为 nil 时不限

@property (readwrite, nonatomic, assign) NSInteger maxLeftCount;

@property (readwrite, nonatomic, assign) BaseTimePickerType type;

@property (readwrite, nonatomic, assign) CGFloat controlHeight;
@property (readwrite, nonatomic, assign) CGFloat btnWidth;

@property (readwrite, nonatomic, weak) id<OnItemClickListener> listener;
@property (readwrite, nonatomic, assign) BOOL isInited;
@end

@implementation BaseTimePicker

- (instancetype) init {
    self = [super init];
    if(self) {
        [self initViews];
    }
    return self;
}
- (instancetype) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initViews];
        [self updateViews];
    }
    return self;
}
- (void) setFrame:(CGRect) frame {
    [super setFrame:frame];
    [self updateViews];
}

- (void) initViews {
    if(!_isInited) {
        _isInited = YES;
        
        _controlHeight = 40;
        _btnWidth = 70;
        _maxLeftCount = 50;
        
        _controlView = [[UIView alloc] init];
        _cancelBtn = [[UIButton alloc] init];
        _okBtn = [[UIButton alloc] init];
        
        _timePicker = [[UIPickerView alloc] init];
        
        _controlView.layer.borderColor = [[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_BOUND] CGColor];
        _controlView.layer.borderWidth = [FMSize getInstance].defaultBorderWidth;
        
        _cancelBtn.tag = BASE_TIME_PICKER_ACTION_CANCEL;
        _okBtn.tag = BASE_TIME_PICKER_ACTION_OK;
        
        [_cancelBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_cancel" inTable:nil] forState:UIControlStateNormal];
        [_okBtn setTitle:[[BaseBundle getInstance] getStringByKey:@"btn_title_ok" inTable:nil] forState:UIControlStateNormal];
        
        [_cancelBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        [_okBtn setTitleColor:[[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_MAIN_BLUE] forState:UIControlStateNormal];
        
        [_cancelBtn.titleLabel setFont:[FMFont fontWithSize:14]];
        [_okBtn.titleLabel setFont:[FMFont fontWithSize:14]];
        
        [_cancelBtn addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_okBtn addTarget:self action:@selector(onOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
        _timePicker.showsSelectionIndicator=YES;
        
        [_controlView addSubview:_cancelBtn];
        [_controlView addSubview:_okBtn];
        
        [self addSubview:_controlView];
        [self addSubview:_timePicker];
    }
}

- (void) updateViews {
    CGRect frame = self.frame;
    CGFloat width = CGRectGetWidth(frame);
    CGFloat height = CGRectGetHeight(frame);
    if(width == 0 || height == 0) {
        return;
    }
    [_controlView setFrame:CGRectMake(0, 0, width, _controlHeight)];
    [_cancelBtn setFrame:CGRectMake(0, 0, _btnWidth, _controlHeight)];
    [_okBtn setFrame:CGRectMake(width-_btnWidth, 0, _btnWidth, _controlHeight)];
    
    [_timePicker setFrame:CGRectMake(0, _controlHeight, width, height - _controlHeight)];
}

- (void) updatePicker {
    [_timePicker reloadAllComponents];
}

- (void) initData {
    NSDictionary * dic;
    NSInteger year;
    NSInteger month;
    switch (_type) {
        case BASE_TIME_PICKER_DAY:
            dic = [FMUtils timeLongToDictionary:_centerDate];
            year = [[dic valueForKeyPath:@"year"] integerValue];
            month = [[dic valueForKeyPath:@"month"] integerValue];
            
            _leftArray = [self getYearArray];
            _middleArray = [self getMonthArray:year];
            _rightArray = [self getDayArrayByYear:year month:month];
            _compontentsCount = 3;
            break;
        case BASE_TIME_PICKER_MONTH:
            _compontentsCount = 2;
            _leftArray = [self getYearArray];
            _middleArray = [self getMonthArray:year];
            break;
        case BASE_TIME_PICKER_MINUTE:
            _compontentsCount = 3;
            _leftArray = [self getDateArray];
            _middleArray = [self getHourArray];
            _rightArray = [self getMinuteArray];
            break;
            
//        case BASE_TIME_PICKER_DAY_WITHOUT_YEAR:
//            _compontentsCount = 2;
//            dic = [FMUtils timeLongToDictionary:_centerDate];
//            year = [[dic valueForKeyPath:@"year"] integerValue];
//            month = [[dic valueForKeyPath:@"month"] integerValue];
//            
//            _leftArray = [self getMonthArray];
//            _middleArray = [self getDayArray:[FMUtils getLastDayOfMonthWithYear:year month:month]];
//            break;
            
        default:
            break;
    }
    [self updatePicker];
}

- (void) showCenterDate {
    NSString * left;
    NSString * middle;
    NSString * right;
    NSInteger index = 0;
    NSDictionary * dic = [FMUtils timeLongToDictionary:_centerDate];
    switch (_type) {
        case BASE_TIME_PICKER_DAY:
            left = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"yyyy"];
            middle = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"MM"];
            right = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"dd"];
            index = [_leftArray indexOfObject:left];
            [_timePicker selectRow:index inComponent:0 animated:NO];
            
            index = [_middleArray indexOfObject:middle];
            [_timePicker selectRow:index inComponent:1 animated:NO];
            
            index = [_rightArray indexOfObject:right];
            [_timePicker selectRow:index inComponent:2 animated:NO];
            break;
        case BASE_TIME_PICKER_MONTH:
            
//            left = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"yyyy"];
//            middle = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"MM"];
            
            //获取年份和月份
            left = [dic[@"year"] stringValue];
            middle = [dic[@"month"] stringValue];
            if (middle.length == 1) middle = [NSString stringWithFormat:@"0%@",middle];
            
            index = [_leftArray indexOfObject:left];
            [_timePicker selectRow:index inComponent:0 animated:NO];
            
            index = [_middleArray indexOfObject:middle];
            [_timePicker selectRow:index inComponent:1 animated:NO];
            break;
        case BASE_TIME_PICKER_MINUTE:
            left = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"yyyy-MM-dd"];
            index = [_leftArray indexOfObject:left];
            [_timePicker selectRow:index inComponent:0 animated:NO];
            
            index = [[dic valueForKeyPath:@"hour"] integerValue];
            [_timePicker selectRow:index inComponent:1 animated:NO];
            
            index = [[dic valueForKey:@"minute"] integerValue];
            [_timePicker selectRow:index inComponent:2 animated:NO];
            break;
            
//        case BASE_TIME_PICKER_DAY_WITHOUT_YEAR:
//            left = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"MM"];
//            middle = [FMUtils getDateTimeDescriptionBy:_centerDate format:@"dd"];
//            index = [_leftArray indexOfObject:left];
//            [_timePicker selectRow:index inComponent:0 animated:NO];
//            
//            index = [_middleArray indexOfObject:middle];
//            [_timePicker selectRow:index inComponent:1 animated:NO];
//            break;
            
        default:
            break;
    }
}

- (void) updateMonthArray {
    if(_type == BASE_TIME_PICKER_DAY || BASE_TIME_PICKER_MONTH) {
        NSInteger year = [_leftArray[[_timePicker selectedRowInComponent:0]] integerValue];
        NSInteger month = [_middleArray[[_timePicker selectedRowInComponent:1]] integerValue];
        
        _middleArray = [self getMonthArray:year];
        [_timePicker reloadComponent:1];
        
        NSNumber * maxNumber = [_middleArray lastObject];    //最后的日期
        NSNumber * minNumber = _middleArray[0];    //最后的日期
        
        if(month > maxNumber.integerValue) {  //如果当前所选不正确的话重新选
            [_timePicker selectRow:[_middleArray count]-1 inComponent:1 animated:YES];
        } else if(month < minNumber.integerValue) {
            [_timePicker selectRow:0 inComponent:1 animated:YES];
        } else {
            NSInteger curIndex = month - minNumber.integerValue;
            [_timePicker selectRow:curIndex inComponent:1 animated:YES];
        }
    }
}

//检查并更新日期
- (void) updateDayArray {
    if(_type == BASE_TIME_PICKER_DAY) {
        NSInteger year = [_leftArray[[_timePicker selectedRowInComponent:0]] integerValue];
        NSInteger month = [_middleArray[[_timePicker selectedRowInComponent:1]] integerValue];

        NSInteger day = [_rightArray[[_timePicker selectedRowInComponent:2]] integerValue];
        
        _rightArray = [self getDayArrayByYear:year month:month];
        [_timePicker reloadComponent:2];
        
        NSNumber * maxNumber = [_rightArray lastObject];    //最后的日期
        NSNumber * minNumber = _rightArray[0];
        if(day > maxNumber.integerValue) {  //如果当前所选不正确的话重新选
            [_timePicker selectRow:[_rightArray count]-1 inComponent:2 animated:NO];
        } else if(day < minNumber.integerValue) {
            [_timePicker selectRow:0 inComponent:2 animated:YES];
        } else {
            NSInteger curIndex = day - minNumber.integerValue;
             [_timePicker selectRow:curIndex inComponent:2 animated:YES];
        }
    }
}

//获取日期的数组
- (NSMutableArray *) getDateArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger count = _maxLeftCount; //总共展示 50 条数据
    NSInteger previousCount = (count - 1) / 2;  //往前加载条数
    NSInteger index = 0;
    NSInteger msOfOneDay = 1000 * 60 * 60 * 24;
    for(index = 0;index < count;index++) {
        NSNumber * targetDay;
        targetDay = [NSNumber numberWithLongLong:_centerDate.longLongValue - (previousCount - index) * msOfOneDay];
        
        NSString * date = [FMUtils getDateTimeDescriptionBy:targetDay format:@"yyyy-MM-dd"];
        [array addObject:date];
    }
    return array;
}

//获取年的数组
- (NSMutableArray *) getYearArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger count = 0;
    NSInteger previousCount = 0;
    
    NSDictionary * dic;
    NSInteger year;
    
    if(_minDate && _maxDate) {  //同时设置了上限下限,显示所有可能值
        NSInteger centerYear;
        NSInteger minYear;
        NSInteger maxYear;
        
        dic = [FMUtils timeLongToDictionary:_centerDate];
        centerYear = [[dic valueForKeyPath:@"year"] integerValue];
        dic = [FMUtils timeLongToDictionary:_minDate];
        minYear = [[dic valueForKeyPath:@"year"] integerValue];
        dic = [FMUtils timeLongToDictionary:_maxDate];
        maxYear = [[dic valueForKeyPath:@"year"] integerValue];
        
        count = maxYear - minYear + 1;
        previousCount = centerYear - minYear;
        
        
    } else if(_minDate) {   //设置了下限
        NSInteger minYear;
        NSInteger centerYear;
        
        dic = [FMUtils timeLongToDictionary:_centerDate];
        centerYear = [[dic valueForKeyPath:@"year"] integerValue];
        dic = [FMUtils timeLongToDictionary:_minDate];
        minYear = [[dic valueForKeyPath:@"year"] integerValue];
        
        centerYear = _maxLeftCount;
        previousCount = (count - 1) / 2;
        if(centerYear - previousCount < minYear) {
            previousCount = centerYear - minYear;
        }
        
        
    } else if(_maxDate) {   //设置了上限
        NSInteger maxYear;
        NSInteger centerYear;
        NSInteger lastCount;    //
        
        dic = [FMUtils timeLongToDictionary:_centerDate];
        centerYear = [[dic valueForKeyPath:@"year"] integerValue];
        dic = [FMUtils timeLongToDictionary:_maxDate];
        maxYear = [[dic valueForKeyPath:@"year"] integerValue];
        
        centerYear = _maxLeftCount;
        lastCount = (count - 1) / 2;
        if(centerYear + lastCount > maxYear) {
            lastCount = maxYear - centerYear;
            
        }
        previousCount = count - 1 - lastCount;
        
    } else {    //没有做任何限制
        count = _maxLeftCount; //总共展示 50 条数据
        previousCount = (count - 1) / 2;  //往前加载条数
    }
    
    NSInteger index = 0;
    dic = [FMUtils timeLongToDictionary:_centerDate];
    year = [[dic valueForKeyPath:@"year"] integerValue];
    for(index = 0;index < count;index++) {
        NSInteger target = year - (previousCount - index);
        NSString * tmp = [[NSString alloc] initWithFormat:@"%ld", target];
        [array addObject:tmp];
    }
    return array;
}

//获取当前选择的年
- (NSInteger) getCurrentSelectYear {
    NSInteger year = 0;
    NSInteger left;
    NSNumber * tmpNumber;
    NSString * tmpStr;
    NSArray * tmpArray;
    switch(_type) {
        case BASE_TIME_PICKER_DAY:
            left = [_timePicker selectedRowInComponent:0];
            tmpNumber = [FMUtils stringToNumber:_leftArray[left]];
            year = [tmpNumber integerValue];
            break;
        case BASE_TIME_PICKER_MONTH:
            left = [_timePicker selectedRowInComponent:0];
            tmpNumber = [FMUtils stringToNumber:_leftArray[left]];
            year = [tmpNumber integerValue];
            break;
        case BASE_TIME_PICKER_MINUTE:
            left = [_timePicker selectedRowInComponent:0];
            tmpStr = _leftArray[left];
            tmpArray = [tmpStr componentsSeparatedByString:@"-"];
            
            tmpStr = tmpArray[0];
            tmpNumber = [FMUtils stringToNumber:tmpStr];
            year = [tmpNumber integerValue];
            break;
        default:
            break;
    }
    return year;
}

//获取月份的数组
- (NSMutableArray *) getMonthArray:(NSInteger) curYear {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    NSInteger count = 0;
    NSDictionary * dic;
    
    if(_minDate && _maxDate) {
        dic = [FMUtils timeLongToDictionary:_maxDate];
        NSInteger maxYear = [[dic valueForKeyPath:@"year"] integerValue];
        NSInteger maxMonth = [[dic valueForKeyPath:@"month"] integerValue];
        
        dic = [FMUtils timeLongToDictionary:_minDate];
        NSInteger minYear =[[dic valueForKeyPath:@"year"] integerValue];
        NSInteger minMonth = [[dic valueForKeyPath:@"month"] integerValue];
        
        if(curYear == minYear && curYear == maxYear) {    //同一年之内
            index = minMonth;
            count = maxMonth - minMonth + 1;
        } else if(curYear == minYear) {    //第一年
            index = minMonth;
            count = 12 - minMonth + 1;
        } else if(curYear == maxYear) {    //最后一年
            index = 1;
            count = maxMonth;
        } else {
            index = 1;
            count = 12;
        }
    } else if(_minDate) {
        dic = [FMUtils timeLongToDictionary:_minDate];
        NSInteger minYear =[[dic valueForKeyPath:@"year"] integerValue];
        NSInteger minMonth = [[dic valueForKeyPath:@"month"] integerValue];
        
        if(curYear == minYear) {
            index = minMonth;
            count = 12 - minMonth + 1;
        } else {
            index = 1;
            count = 12;
        }
    } else if(_maxDate) {
        dic = [FMUtils timeLongToDictionary:_maxDate];
        NSInteger maxYear =[[dic valueForKeyPath:@"year"] integerValue];
        NSInteger maxMonth = [[dic valueForKeyPath:@"month"] integerValue];
        
        if(curYear == maxYear) {
            index = 1;
            count = maxMonth;
        } else {
            index = 1;
            count = 12;
        }
    } else {
        index = 1;
        count = 12;
    }
    
    NSInteger max = index + count - 1;
    for(;index <= max; index++) {
        NSString * sep = @"";
        if(index < 10) {
            sep = @"0";
        }
        NSString * day = [[NSString alloc] initWithFormat:@"%@%ld", sep, index];
        [array addObject:day];
    }
    return array;
}

////获取日的数组
//- (NSMutableArray *) getDayArray:(NSInteger) count {
//    NSMutableArray * array = [[NSMutableArray alloc] init];
//    NSInteger index = 1;
//    
//    for(;index <= count; index++) {
//        NSString * sep = @"";
//        if(index < 10) {
//            sep = @"0";
//        }
//        NSString * day = [[NSString alloc] initWithFormat:@"%@%ld", sep, index];
//        [array addObject:day];
//    }
//    return array;
//}

//获取日的数组
- (NSMutableArray *) getDayArrayByYear:(NSInteger) year month:(NSInteger) month{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    NSInteger count = 0;
    if(_minDate && _maxDate) {
        NSDictionary * dic = [FMUtils timeLongToDictionary:_maxDate];
        NSInteger maxYear = [[dic valueForKeyPath:@"year"] integerValue];
        NSInteger maxMonth = [[dic valueForKeyPath:@"month"] integerValue];
        NSInteger maxDay = [[dic valueForKeyPath:@"day"] integerValue];
        
        dic = [FMUtils timeLongToDictionary:_minDate];
        NSInteger minYear =[[dic valueForKeyPath:@"year"] integerValue];
        NSInteger minMonth = [[dic valueForKeyPath:@"month"] integerValue];
        NSInteger minDay = [[dic valueForKeyPath:@"day"] integerValue];
        
        if((year == minYear && month == minMonth) && (year == maxYear && month == maxMonth)) {    //同一月之内
            index = minDay;
            count = maxDay - minDay + 1;
        } else if(year == minYear && month == minMonth) {    //首月
            index = minDay;
            count = [FMUtils getLastDayOfMonthWithYear:year month:month] - minDay + 1;
        } else if(year == maxYear && month == maxMonth) {    //末月
            index = 1;
            count = maxDay;
        } else {
            index = 1;
            count = [FMUtils getLastDayOfMonthWithYear:year month:month];;
        }
    } else if(_minDate) {
        NSDictionary * dic = [FMUtils timeLongToDictionary:_minDate];
        NSInteger minYear =[[dic valueForKeyPath:@"year"] integerValue];
        NSInteger minMonth = [[dic valueForKeyPath:@"month"] integerValue];
        NSInteger minDay = [[dic valueForKeyPath:@"day"] integerValue];
        
        if(year == minYear && month == minMonth) {
            index = minDay;
            count = [FMUtils getLastDayOfMonthWithYear:year month:month] - minDay + 1;
        } else {
            index = 1;
            count = [FMUtils getLastDayOfMonthWithYear:year month:month];
        }
    } else if(_maxDate) {
        NSDictionary * dic = [FMUtils timeLongToDictionary:_maxDate];
        NSInteger maxYear =[[dic valueForKeyPath:@"year"] integerValue];
        NSInteger maxMonth = [[dic valueForKeyPath:@"month"] integerValue];
        NSInteger maxDay = [[dic valueForKeyPath:@"day"] integerValue];
        
        if(year == maxYear && month == maxMonth) {
            index = 1;
            count = maxDay;
        } else {
            index = 1;
            count = [FMUtils getLastDayOfMonthWithYear:year month:month];
        }
    } else {
        index = 1;
        count = [FMUtils getLastDayOfMonthWithYear:year month:month];
    }
    
    NSInteger max = index + count - 1;
    for(;index <= max; index++) {
        NSString * sep = @"";
        if(index < 10) {
            sep = @"0";
        }
        NSString * day = [[NSString alloc] initWithFormat:@"%@%ld", sep, index];
        [array addObject:day];
    }
    return array;
}

//获取小时的数组
- (NSMutableArray *) getHourArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger count = 24;
    NSInteger index = 0;
    for(index = 0;index < count; index++) {
        NSString * sep = @"";
        if(index < 10) {
            sep = @"0";
        }
        NSString * hour = [[NSString alloc] initWithFormat:@"%@%ld", sep, index];
        [array addObject:hour];
    }
    return array;
}

//获取分钟的数组
- (NSMutableArray *) getMinuteArray {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    NSInteger count = 60;
    NSInteger index = 0;
    for(index = 0;index < count; index++) {
        NSString * sep = @"";
        if(index < 10) {
            sep = @"0";
        }
        NSString * minute = [[NSString alloc] initWithFormat:@"%@%ld", sep, index];
        [array addObject:minute];
    }
    return array;
}


- (void) setPickerType:(BaseTimePickerType) type {
    _type = type;
    if(_date) {
        [self initData];
    }
}

//设置参考日期
- (void) setCenterDate:(NSNumber *) date {
    _date = [date copy];
    _centerDate = [_date copy];
    if(_minDate) {
        if(_centerDate.longLongValue < _minDate.longLongValue) {
            _centerDate = [_minDate copy];
        }
    }
    if(_maxDate) {
        if(_centerDate.longLongValue > _maxDate.longLongValue) {
            _centerDate = [_maxDate copy];
        }
    }
    [self initData];
    [self showCenterDate];
}

//设置最小边界值
- (void) setMinDate:(NSNumber *) minDate {
    _minDate = minDate;
    if(_maxDate && _minDate.longLongValue > _maxDate.longLongValue) {
        _maxDate = [_minDate copy];
    }
    if(_centerDate && _minDate.longLongValue > _centerDate.longLongValue) {
        _centerDate = [_minDate copy];
    }
    if(_centerDate) {
        [self initData];
        [self showCenterDate];
    }
}

//设置最大边界值
- (void) setMaxDate:(NSNumber *)maxDate {
    _maxDate = maxDate;
    if(_minDate && _minDate.longLongValue > _maxDate.longLongValue) {
        _minDate = [_maxDate copy];
    }
    if(_centerDate && _centerDate.longLongValue > _maxDate.longLongValue) {
        _centerDate = [_maxDate copy];
    }
    if(_centerDate) {
        [self initData];
        [self showCenterDate];
    }
   
}

- (void) onCancelButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_cancelBtn];
    }
}

- (void) onOKButtonClicked:(id) sender {
    if(_listener) {
        [_listener onItemClick:self subView:_okBtn];
    }
}


//获取选中的时间
- (NSNumber *) getSelectTime {
    NSNumber * time;
    NSInteger left = [_timePicker selectedRowInComponent:0];
    NSInteger middle;
    NSInteger right;
    NSNumber * tmpNumber;
    NSString * tmpStr;
    NSArray * tmpArray;
    NSDate * date;
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
    switch(_type) {
        case BASE_TIME_PICKER_DAY:
            left = [_timePicker selectedRowInComponent:0];
            tmpNumber = [FMUtils stringToNumber:_leftArray[left]];
            year = [tmpNumber integerValue];
            
            middle = [_timePicker selectedRowInComponent:1];
            tmpNumber = [FMUtils stringToNumber:_middleArray[middle]];
            month = [tmpNumber integerValue];
            
            right = [_timePicker selectedRowInComponent:2];
            tmpNumber = [FMUtils stringToNumber:_rightArray[right]];
            day = tmpNumber.integerValue;
            date = [FMUtils getDateByYear:year month:month day:day hour:0 minute:0 second:0];
            time = [FMUtils dateToTimeLong:date];
            break;
        case BASE_TIME_PICKER_MONTH:
            left = [_timePicker selectedRowInComponent:0];
            tmpNumber = [FMUtils stringToNumber:_leftArray[left]];
            year = [tmpNumber integerValue];
            
            middle = [_timePicker selectedRowInComponent:1];
            tmpNumber = [FMUtils stringToNumber:_middleArray[middle]];
            month = [tmpNumber integerValue];
            
            date = [FMUtils getDateByYear:year month:month day:1 hour:0 minute:0 second:0];
            time = [FMUtils dateToTimeLong:date];
            break;
        case BASE_TIME_PICKER_MINUTE:
            left = [_timePicker selectedRowInComponent:0];
            tmpStr = _leftArray[left];
            tmpArray = [tmpStr componentsSeparatedByString:@"-"];
            
            tmpStr = tmpArray[0];
            tmpNumber = [FMUtils stringToNumber:tmpStr];
            year = [tmpNumber integerValue];
            
            tmpStr = tmpArray[1];
            tmpNumber = [FMUtils stringToNumber:tmpStr];
            month = [tmpNumber integerValue];
            
            tmpStr = tmpArray[2];
            tmpNumber = [FMUtils stringToNumber:tmpStr];
            day = [tmpNumber integerValue];
            
            hour = [_timePicker selectedRowInComponent:1];
            minute = [_timePicker selectedRowInComponent:2];
            
            date = [FMUtils getDateByYear:year month:month day:day hour:hour minute:minute second:0];
            time = [FMUtils dateToTimeLong:date];
            break;
            
    }
    return time;
}

- (void) setOnItemClickListener:(id<OnItemClickListener>) listener {
    _listener = listener;
}

#pragma mark - datasource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _compontentsCount;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    switch(component) {
        case 0:
            count = [_leftArray count];
            break;
        case 1:
            count = [_middleArray count];
            break;
        case 2:
            count = [_rightArray count];
            break;
    }
    return count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 0;
    switch(component) {
        case 0:
            width = 140;
            break;
        case 1:
            width = 50;
            break;
        case 2:
            width = 50;
            break;
    }
    return width;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch(component) {
        case 0:
            if(_type == BASE_TIME_PICKER_DAY) {
                [self updateMonthArray];
                [self updateDayArray];
            } else if(_type == BASE_TIME_PICKER_MONTH) {
                [self updateMonthArray];
            }
            if(row == 0 || row == [_leftArray count] - 1) {
                _centerDate = [self getSelectTime];
                [self initData];
                [self showCenterDate];
            }
            break;
        case 1:
            if(_type == BASE_TIME_PICKER_DAY) {
                [self updateDayArray];
            }
            break;
        case 2:
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * desc = @"";
    switch(component) {
        case 0:
            desc = _leftArray[row];
            break;
        case 1:
            desc = _middleArray[row];
            break;
        case 2:
            desc = _rightArray[row];
            break;
    }
    return desc;
}

- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * label = (UILabel *)view;
    if(!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [FMFont fontWithSize:14];
        label.textColor = [[FMTheme getInstance] getColorByResource:FM_RESOURCE_TYPE_COLOR_GRAY_L3];
    }
    label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

@end
