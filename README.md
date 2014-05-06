# LVGradientActionSheet

[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)]()
[![Version](http://cocoapod-badges.herokuapp.com/v/LVGradientActionSheet/badge.png)](http://cocoadocs.org/docsets/LVGradientActionSheet)
[![Platform](http://cocoapod-badges.herokuapp.com/p/LVGradientActionSheet/badge.png)](http://cocoadocs.org/docsets/LVGradientActionSheet) [![Build Status](https://travis-ci.org/bilby91/LVGradientActionSheet.svg)](https://travis-ci.org/bilby91/LVGradientActionSheet)

`LVGradientActionSheet` it's a custom Action Sheet with a colourful gradient that mimics UIActionSheet API.

![Blue](https://github.com/bilby91/LVGradientActionSheet/blob/master/blue-sample.gif?raw=true)
![Red](https://github.com/bilby91/LVGradientActionSheet/blob/master/red-sample.gif?raw=true)

## Usage

`LVGradientActionSheet` is really easy to use, the only big difference is the initialiser you need to call. 

```objective-c
- (id)initWithOptions:(NSArray *)options
          cancelTitle:(NSString *)cancelTitle
     topGradientColor:(UIColor *)topColor
  bottomGradientColor:(UIColor *)bottomColor
             delegate:(id<LVGradientActionSheetDelegate>)delegate;
```

All the available delegate methods are this ones, take a look:

```objective-c
@protocol LVGradientActionSheetDelegate <NSObject>

@required

- (void)actionSheet:(LVGradientActionSheet *)actionSheet clickedButtonWithOption:(NSString *)option;

@optional

- (void)willPresentActionSheet:(LVGradientActionSheet *)actionSheet;  // before animation and showing view
- (void)didPresentActionSheet:(LVGradientActionSheet *)actionSheet;  // after animation

- (void)actionSheet:(LVGradientActionSheet *)actionSheet willDismissWithOption:(NSString *)option; // before animation and hiding view
- (void)actionSheet:(LVGradientActionSheet *)actionSheet didDismissWithWithOption:(NSString *)option;  // after animation

@end
```



## Example 

To run the example project; clone the repo, and run pod install from the Example directory first.

## Installation

LVGradientActionSheet is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "LVGradientActionSheet"

## Author

Martin F, me@bilby91.com

## License

LVGradientActionSheet is available under the MIT license. See the LICENSE file for more info.
