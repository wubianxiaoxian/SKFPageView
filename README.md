SKFPageView
--

简介
--
* 一个轻量级创建分页的工具
* 可以自定义Titlebar背景颜色、字体颜色、
* 翻页Titlebar 文字渐变色，字体放大
*

Version
----

* 1.0.1 

Requirements
----

* Xcode 8 or higher
* iOS 8.0 or higher

集成
-
* 手工集成:
* 导入文件夹 SKFPageView 到你的工程


使用方法
-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1,创建需要的样式
        let style = SKFPageStyle()
        style.isScrollEnabel=true
        style.isShowBottomLine=true
        style.isScaleEnable=true
        
        //2.获取所有的标题
        let  titles = ["精选","电影","小龙虾","皮皮虾","京酱肉丝","还有啥"]
        
        //3,获取所有的内容控制器
        var childVcs = Array<UIViewController>()
        for _ in 0..<titles.count {
            let vc=UIViewController()
            vc.view.backgroundColor=UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
            childVcs.append(vc)
        }
        //4,创建SKFPageView
        automaticallyAdjustsScrollViewInsets=false

        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64)
        let pageView=SKFPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs,parentVc:self)
        pageView.backgroundColor = .blue
        view.addSubview(pageView)
        
    }

使用演示
-
![SKFPageView.gif](http://upload-images.jianshu.io/upload_images/964698-b7a7d557b4586cff.gif?imageMogr2/auto-orient/strip)

* 使用过程中，有任何问题，欢迎大家题issues，或者去我的blog留言。


* 微博 敲代码的树懒

*  [我的简书](http://www.jianshu.com/users/61b9640c876a/latest_articles)