//
//  SKFPageStyle.swift
//  StudySwiftTableview
//
//  Created by 孙凯峰 on 2017/5/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

import UIKit

class SKFPageStyle {
    //是否可以滚动 默认不可以
    var isScrollEnabel:Bool=false
    var titleHeight :CGFloat = 44
    var normalColor :UIColor = .white
    var selectColor :UIColor = .blue
    var fontSize :CGFloat=15
    
    
    var titleMargin : CGFloat = 30

    
    //是否显示滚动条
    var isShowBottomLine:Bool=false
    var bottomLineColor:UIColor = .blue
    var bottomLineHeight:CGFloat = 2
    
    //是否需要缩放功能
    var isScaleEnable:Bool=false
    var maxScale:CGFloat=1.2
    
}
