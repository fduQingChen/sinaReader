//
//  UIAsrController.h
//  MSC20
//
//  Created by msp on 12-10-23.
//
//

#import <UIKit/UIKit.h>

#import "UIDemoBaseController.h"
#import "iflyMSC/SpeechUser.h"
#import "iflyMSC/UpLoadController.h"
#import "iflyMSC/IFlyRecognizeControl.h"


#define ASRWORD @"阿里山龙胆,浦发银行,邯郸钢铁,齐鲁石化,东北高速,武钢股份,东风汽车,中国国贸,首创股份,上海机场"
#define INTRODUCTION @"\t开始识别前请先点击“上传”按钮上传语法。\n\t开启识别对话框后，您可以说：\n\t\t阿里山龙胆,浦发银行,邯郸钢铁,齐鲁石化,东北高速,武钢股份,东风汽车,中国国贸,首创股份,上海机场"
#define TITLE @"识别演示"
@interface UIAsrController :UIDemoBaseController<UpLoadControllerDelegate,IFlyRecognizeControlDelegate>
{
    IFlyRecognizeControl        *_iflyRecognizeControl;
    UIButton                    *_upLoadButton;
    UIButton                    *_asrButton;
    UIButton                    *_setUpButton;
    
    NSString                    *_grammer;
}

@property (copy)                NSString *grammer;
@property (retain)              IFlyRecognizeControl *iflyRecognizeControl;

@end
