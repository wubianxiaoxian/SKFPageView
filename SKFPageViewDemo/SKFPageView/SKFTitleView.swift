//
//  SKFTitleView.swift
//  StudySwiftTableview
//
//  Created by 孙凯峰 on 2017/5/16.
//  Copyright © 2017年 孙凯峰. All rights reserved.
//

import UIKit
protocol SKFTitleViewDelegate:class {
    func titleView(_ titleView:SKFTitleView,currentIndex:Int)
}
class SKFTitleView: UIView {
    
    weak var delegate:SKFTitleViewDelegate?
    
    // MARK:- 定义属性
    fileprivate var style:SKFPageStyle
    fileprivate var titles:[String]
    fileprivate var currentIndex:Int=0
    //
    
    
    typealias ColorRGB = (red : CGFloat,green : CGFloat,blue : CGFloat)
    fileprivate lazy var normalRGB:ColorRGB=self.style.normalColor.getRGB()
    
    fileprivate lazy var selectRGB:ColorRGB=self.style.selectColor.getRGB()
    
    fileprivate lazy var deltaRGB:ColorRGB={
        let deltaR=self.selectRGB.red-self.normalRGB.red
        let deltaG=self.selectRGB.green-self.normalRGB.green
        let deltaB=self.selectRGB.blue-self.normalRGB.blue
        
        return(deltaR,deltaG,deltaB)
        
        
    }()
    
    fileprivate lazy var titleLabels:[UILabel]=[UILabel]()
    fileprivate lazy var scrollview:UIScrollView={
        let scrollView=UIScrollView()
        scrollView.frame=self.bounds
        scrollView.showsHorizontalScrollIndicator=false
        scrollView.scrollsToTop=false//
        return scrollView
    }()
    fileprivate lazy var bottomLine:UIView={
        let bottomLine=UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height=self.style.bottomLineHeight
        bottomLine.frame.origin.y=self.bounds.height-self.style.bottomLineHeight
        return bottomLine
    }()
    
    // MARK:-构造函数
    init(frame: CGRect,style:SKFPageStyle,titles:[String]) {
        self.style=style
        self.titles=titles
        super.init(frame:frame)
        setunUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
// MARK:-设置ui界面
extension SKFTitleView{
    fileprivate func setunUI(){
        // 1 添加一个UIScrollView
        addSubview(scrollview)
        //2 设置所有的标题
        setupTitleLabels()
        
        //3 设置label的frame
        
        setupLabelsFrame()
        
        // 4 设置bottomLine
        setupBottomLine()
        
        
        
        
    }
    private func  setupBottomLine(){
        // 1 判断是否需要显示BottomLine
        guard style.isShowBottomLine else {
            return
        }
        //2 将bottomLine 添加到scrollView中
        scrollview.addSubview(bottomLine)
        
        //3 设置bottomLine的frame中的属性
        bottomLine.frame.origin.x=titleLabels.first!.frame.origin.x
        bottomLine.frame.size.width=titleLabels.first!.frame.width
        
        
    }
    
    
    private func setupLabelsFrame(){
        // 1 定义出变量&常量
        let labelH=style.titleHeight
        let labelY:CGFloat = 0
        var labelW:CGFloat=0
        var laeblX:CGFloat = 0
        
        //2 设置titleLabel的frame
        let count = titleLabels.count
        
        for (i,titleLabel) in titleLabels.enumerated(){
            if style.isScrollEnabel {
                //可以滚动
                labelW=(titles[i] as NSString).boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude,height:0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName :titleLabel.font], context: nil).width
                laeblX = i==0 ? style.titleMargin*0.5:(titleLabels[i-1].frame.maxX+style.titleMargin)
            }else{
                //不可以滚动
                labelW=bounds.width/CGFloat(count)
                laeblX=labelW*CGFloat(i)
                
            }
            titleLabel.frame=CGRect(x: laeblX, y: labelY, width: labelW, height: labelH)
            
            
        }
        // 设置scale属性
        if style.isScaleEnable  {
            //?. 在等号的左边，那么系统会自动判断可选类型是否有值
            //?. 在等号的右边，那么系统会自动判断可选类型是否有值
            
            titleLabels.first?.transform=CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        //3 设置contengsize
        if style.isScrollEnabel {
            scrollview.contentSize.width=titleLabels.last!.frame.maxX+style.titleMargin*0.5
        }
    }
    
    private func setupTitleLabels(){
        //元祖：（）
        for (i,title) in titles.enumerated(){
            //1 创建UILabel
            let label=UILabel()
            //2 设置label的属性
            label.tag=i
            label.text=title
            label.textColor = i==0 ?style.selectColor:style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            // 3 讲label添加到scrollView中
            scrollview.addSubview(label)
            
            //4，讲label添加到数组中
            titleLabels.append(label)
            
            //5 监听label的点击
            //事件监听依然是发送消息
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled=true
            
            //
            
        }
    }
}
// MARK:- 监听label的点击
extension SKFTitleView{
    //tapGes:外部参数
    // @objc : 如果在函数前家@objc 那么会保留oc的特性
    //oc 在调用方法时，本质是发送消息
    // 讲方法包装成@sel ---》根据@sel去类种的方法映射表--》IMP指针
    // 目的 ：灵活 --》不安全
    @objc fileprivate func titleLabelClick(_ tapGes:UITapGestureRecognizer){
        //1 校验UIlabel
        guard let targetLabel = tapGes.view as?UILabel  else {
            return
        }
        
        guard targetLabel.tag != currentIndex else {
            return
        }
        //2 取出目标的label&原来的label
        print(targetLabel.tag)
        let soucrceLabel = titleLabels[currentIndex]
        
        //3  改变label的颜色
        soucrceLabel.textColor=style.normalColor
        targetLabel.textColor=style.selectColor
        
        //4,记录最新的index
        currentIndex=targetLabel.tag
        
        //5,让点击的label居中显示
        
        adjustLabelPosition(targetLabel)
        
        //6，通知代理
        
        delegate?.titleView(self, currentIndex: currentIndex)
        
        //7，调整缩放
        if style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: {
                soucrceLabel.transform=CGAffineTransform.identity
                targetLabel.transform=CGAffineTransform(scaleX:self.style.maxScale,y:self.style.maxScale)
            })
        }
        // 8，发生点击，调整bottomline
        if  style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x=targetLabel.frame.origin.x
                self.bottomLine.frame.size.width=targetLabel.frame.width
            })
            
        }
        
        
        
    }
    fileprivate func adjustLabelPosition(_ targetLabel:UILabel){
        
        //0 只有可以滚动的时候调整
        
        guard style.isScrollEnabel else {
            return
        }
        
        //1 计算一下offsetx
        var offsetX = targetLabel.center.x-bounds.width*0.5
        
        // 临界值的判断
        
        if offsetX<0 {
            offsetX = 0
        }
        if offsetX>scrollview.contentSize.width-scrollview.bounds.width {
            offsetX = scrollview.contentSize.width-scrollview.bounds.width
        }
        
        //设置 scrollView的 contentOFFSET
        scrollview.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
        
    }
}
extension SKFTitleView:SKFContentViewDelegate{
    func contentView(_ contentView: SKFContentView, index: Int) {
        print(index)
        //1 记录最新的currentIndex
        currentIndex=index
        adjustLabelPosition(titleLabels[currentIndex])
    }
    func contengView(_ contentView: SKFContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        //1 获取sourcelabel&targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        
        let targetLabel = titleLabels[targetIndex]
        
        //2 颜色的渐变
        sourceLabel.textColor=UIColor(r: selectRGB.red-progress*deltaRGB.red, g: selectRGB.green-progress*deltaRGB.green, b: selectRGB.blue-progress*deltaRGB.blue, alpha: 1.0)
        targetLabel.textColor=UIColor(r: normalRGB.red+progress*deltaRGB.red, g: normalRGB.green+progress*deltaRGB.green, b: normalRGB.blue+progress*deltaRGB.blue, alpha: 1.0)
        //3 bottomLine的调整
        if style.isShowBottomLine {
            let deltaX=targetLabel.frame.origin.x-sourceLabel.frame.origin.x
            let deltaW=targetLabel.frame.width-sourceLabel.frame.width
            bottomLine.frame.origin.x=sourceLabel.frame.origin.x+progress*deltaX
            bottomLine.frame.size.width=sourceLabel.frame.width+progress*deltaW
        }
        //4 scale的调整
        if style.isScaleEnable {
            let deltaScale = style.maxScale-1.0
            sourceLabel.transform=CGAffineTransform(scaleX: style.maxScale-progress*deltaScale, y: style.maxScale-progress*deltaScale)
            targetLabel.transform=CGAffineTransform(scaleX: 1.0+progress*deltaScale, y: 1.0+progress*deltaScale)
            
        }
        
        
    }
}
