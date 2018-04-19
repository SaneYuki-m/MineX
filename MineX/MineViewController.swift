//
//  ViewController.swift
//  MineX
//
//  Created by Saneyuki Makino on 2018/04/14.
//  Copyright © 2018年 Lame. All rights reserved.
//
import UIKit
import Firebase
import GoogleMobileAds


class MineViewController: UIViewController, UIScrollViewDelegate,GADBannerViewDelegate{
    
    var bannerView: GADBannerView!
    let usrD = UserDefaults.standard
    @IBOutlet weak var bombNumberLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    //変数宣言
    var bombNumber:Int?
    var numberPower:Int?
    var collectionX:Int?
    var collectionY:Int?
    var tagNumber:Int = 0
    var randomNumber:[Int] = []
    var randomBomb:[Int] = []
    var imageArr : [UIImage] = []
    var dispImageNo:[Int] = []
    var offsetPosition:CGPoint = CGPoint(x:0,y:0)
    let scrollView: UIScrollView = UIScrollView()
    var imageView: UIImageView!
    var point:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-6653853739750121/4545264494"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        //ステージの情報を取得
        self.view.backgroundColor = UIColor.lightGray
        bombNumber = usrD.integer(forKey: "bombNumber")
        numberPower = usrD.integer(forKey: "numberPower")
        collectionX = usrD.integer(forKey: "collectionX")
        collectionY = usrD.integer(forKey: "collectionY")
        userRankLabel.text = "MS力：" + String(usrD.integer(forKey: "rank"))
        
        Imageset()
        dispImageNoSet()
        makeBombNumber()
        makeScrollView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func dispImageNoSet(){
        var count:Int = 0
        for _ in 0 ..< collectionY! {
            for _ in 0 ..< collectionX! {
                count = count+1
            }
        }
        for _ in 0 ..< count{
            dispImageNo.append(0)
        }
    }
    
    func Imageset(){
        //image setting
        let buttonImage:UIImage = UIImage(named:"Metal")!
        let whiteImage:UIImage = UIImage(named:"White")!
        let OneImage:UIImage = UIImage(named:"One")!
        let TwoImage:UIImage = UIImage(named:"Two")!
        let ThreeImage:UIImage = UIImage(named:"Three")!
        let FourImage:UIImage = UIImage(named:"Four")!
        let FiveImage:UIImage = UIImage(named:"Five")!
        let SixImage:UIImage = UIImage(named:"Six")!
        let SevenImage:UIImage = UIImage(named:"Seven")!
        let EightImage:UIImage = UIImage(named:"Eight")!
        let bombImage:UIImage = UIImage(named:"Bomb")!
        imageArr.append(buttonImage)
        imageArr.append(OneImage)
        imageArr.append(TwoImage)
        imageArr.append(ThreeImage)
        imageArr.append(FourImage)
        imageArr.append(FiveImage)
        imageArr.append(SixImage)
        imageArr.append(SevenImage)
        imageArr.append(EightImage)
        imageArr.append(whiteImage)
        imageArr.append(bombImage)
    }
    
    func makeScrollView(){
        tagNumber = 0
        //scrollView設定
        scrollView.backgroundColor = UIColor.gray
        scrollView.frame.size = CGSize(width: 375, height: 375)
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: 100*collectionX!, height: 100*collectionY!)
        scrollView.bounces = true
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        scrollView.contentOffset = offsetPosition
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 1.0
        
        // ScrollViewの中身を作る
        for i in 0 ..< collectionY! {
            for j in 0 ..< collectionX! {
                imageView = UIImageView(image: imageArr[dispImageNo[tagNumber]])
                imageView.frame = CGRect(x:CGFloat(100*j),y:CGFloat(100*i),width:scrollView.contentSize.width/CGFloat(collectionX!),height:scrollView.contentSize.height/CGFloat(collectionY!))
                
                //add tag
                tagNumber = tagNumber+1
                imageView.tag = tagNumber
                imageView.isUserInteractionEnabled = true
            
                let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping))
                imageView.addGestureRecognizer(singleTap)
                
                //add image
                scrollView.addSubview(imageView)
            }
        }
        
        self.view.addSubview(scrollView)
    }
    
    @objc func singleTapping(_ sender: UITapGestureRecognizer) {
        var clearCount: Int = 0
        var buttonTag : Int = 0
        var bombCount : Int = 0
        var LFlag : Bool = false
        var RFlag : Bool = false
        
        
        if let numButton = sender.view as? UIImageView {
            buttonTag = numButton.tag
            for i in 1...collectionY!{
                if buttonTag == i*collectionX!{
                    RFlag = true
                }else if buttonTag == (i-1)*collectionX!+1{
                    LFlag = true
                }
            }
            for i in 0 ..< collectionX!*collectionY!{
                if dispImageNo[i] == 0{
                    clearCount = clearCount + 1
                }
            }
            
            for i in 0 ..< bombNumber!{
                if RFlag{
                    if buttonTag-1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX! == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX! == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX!-1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX!-1 == randomBomb[i] {bombCount = bombCount+1}
                }else if LFlag{
                    if buttonTag+1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX! == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX! == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX!+1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX!+1 == randomBomb[i] {bombCount = bombCount+1}
                }else{
                    if buttonTag-1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX! == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX! == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX!-1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX!-1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag-collectionX!+1 == randomBomb[i] {bombCount = bombCount+1}
                    if buttonTag+collectionX!+1 == randomBomb[i] {bombCount = bombCount+1}
                }
            }
            
            if bombCount != 0{
                dispImageNo[buttonTag-1] = bombCount
                offsetPosition = CGPoint(x:scrollView.contentOffset.x,y:scrollView.contentOffset.y)
                point = point + bombCount
                makeScrollView()
                
            }else{
                dispImageNo[buttonTag-1] = 9
                offsetPosition = CGPoint(x:scrollView.contentOffset.x,y:scrollView.contentOffset.y)
                makeScrollView()
            }
            
            for i in 0 ..< bombNumber!{
                if buttonTag == randomBomb[i]{
                    dispImageNo[buttonTag-1] = 10
                    makeScrollView()
                    let storyboard: UIStoryboard = self.storyboard!
                    let gameover = storyboard.instantiateViewController(withIdentifier: "gameover")
                    self.present(gameover, animated: true, completion: nil)
                }
            }
            
            print(clearCount)
            if clearCount-1 == bombNumber{
                usrD.set(point, forKey: "point")
                let storyboard: UIStoryboard = self.storyboard!
                let gameover = storyboard.instantiateViewController(withIdentifier: "gameclear")
                self.present(gameover, animated: true, completion: nil)
            }
            
        }
    }
    
    func makeBombNumber(){
        for i in 1...collectionX!*collectionY! {
            randomNumber.append(i)
        }
        for _ in 1...bombNumber! {
            let a = Int(arc4random_uniform(UInt32(randomNumber.count)))
            randomBomb.append(randomNumber.remove(at: a))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
}

