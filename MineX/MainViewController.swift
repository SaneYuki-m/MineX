//
//  MainViewController.swift
//  MineX
//
//  Created by Saneyuki Makino on 2018/04/14.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController,GADBannerViewDelegate {
    
    let usrD = UserDefaults.standard
    var bannerView: GADBannerView!
    
    //アウトレット系宣言
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var bombLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var xUp: UIButton!
    @IBOutlet weak var xDown: UIButton!
    @IBOutlet weak var yUp: UIButton!
    @IBOutlet weak var yDown: UIButton!
    @IBOutlet weak var bombUp: UIButton!
    @IBOutlet weak var bombDown: UIButton!
    
    var xLabelNum:Int = 4
    var yLabelNum:Int = 4
    var bombLabelNum: Int = 3
    var scoreLabelNum: Int = 0
    var buttons:[UIButton] = []
    
    override func viewDidLoad() {
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-6653853739750121/4545264494"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self

        
        super.viewDidLoad()
        if usrD.object(forKey: "collectionX") != nil{
            xLabelNum = usrD.integer(forKey: "collectionX")
        }
        if usrD.object(forKey: "collectionY") != nil{
            yLabelNum = usrD.integer(forKey: "collectionY")
        }
        if usrD.object(forKey: "bombNumber") != nil{
            bombLabelNum = usrD.integer(forKey: "bombNumber")
        }
        if usrD.object(forKey: "score") != nil{
            scoreLabelNum = usrD.integer(forKey: "score")
        }
        
        usrD.set(xLabelNum, forKey: "collectionX")
        usrD.set(yLabelNum, forKey: "collectionY")
        usrD.set(bombLabelNum, forKey: "bombNumber")
        usrD.set(scoreLabelNum, forKey: "score")
        
        xLabel.text = String(xLabelNum)+"行：必要スコア"+String((xLabelNum-2)*5)
        yLabel.text = String(yLabelNum)+"列：必要スコア"+String((yLabelNum-2)*5)
        bombLabel.text = String(bombLabelNum)+"個：必要スコア"+String((bombLabelNum+1)*5)
        scoreLabel.text = "SCORE : " + String(scoreLabelNum)
        userRankLabel.text = "MS力：" + String(xLabelNum*yLabelNum*bombLabelNum)
        usrD.set(xLabelNum*yLabelNum*bombLabelNum, forKey: "rank")
        
        buttons.append(xUp)
        buttons.append(xDown)
        buttons.append(yUp)
        buttons.append(yDown)
        buttons.append(bombUp)
        buttons.append(bombDown)
        
        for i in 0..<buttons.count{
            buttons[i].tag = i
            buttons[i].addTarget(self, action: #selector(action), for: .touchUpInside)
        }
        // Do any additional setup after loading the view.
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
    
    @objc func action(sender: UIButton){
        switch sender.tag {
        case 0:
            if scoreLabelNum - (xLabelNum-2)*5 < 0{
                let alert = UIAlertController(
                    title: "Alert!",
                    message: "スコアがたりない！",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }else{
                scoreLabelNum = scoreLabelNum - (xLabelNum-2)*5
                scoreLabel.text = "SCORE:" + String(scoreLabelNum)
                usrD.set(scoreLabelNum, forKey: "score")
                xLabelNum = xLabelNum + 1
                usrD.set(xLabelNum, forKey: "collectionX")
                xLabel.text = String(xLabelNum)+"行：必要スコア"+String((xLabelNum-2)*5)
                userRankLabel.text = "MS力：" + String(xLabelNum*yLabelNum*bombLabelNum)
                usrD.set(xLabelNum*yLabelNum*bombLabelNum, forKey: "rank")

            }
        case 1:
            if xLabelNum > 4{
                xLabelNum = xLabelNum - 1
                usrD.set(xLabelNum, forKey: "collectionX")
                xLabel.text = String(xLabelNum)+"行：必要スコア"+String((xLabelNum-2)*5)
            }else{
                let alert = UIAlertController(
                    title: "Alert!",
                    message: "これ以上小さく出来ない！",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        case 2:
            if scoreLabelNum - (yLabelNum-2)*5 < 0{
                let alert = UIAlertController(
                    title: "Alert!",
                    message: "スコアがたりない！",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }else{
                scoreLabelNum = scoreLabelNum - (yLabelNum-2)*5
                scoreLabel.text = "SCORE:" + String(scoreLabelNum)
                usrD.set(scoreLabelNum, forKey: "score")
                yLabelNum = yLabelNum + 1
                usrD.set(yLabelNum, forKey: "collectionY")
                yLabel.text = String(yLabelNum)+"列：必要スコア"+String((yLabelNum-2)*5)
                userRankLabel.text = "MS力：" + String(xLabelNum*yLabelNum*bombLabelNum)
                usrD.set(xLabelNum*yLabelNum*bombLabelNum, forKey: "rank")

            }
        case 3:
            if yLabelNum > 4{
                yLabelNum = yLabelNum - 1
                usrD.set(yLabelNum, forKey: "collectionY")
                yLabel.text = String(yLabelNum)+"列：必要スコア"+String((yLabelNum-2)*5)
            }else{
                let alert = UIAlertController(
                    title: "Alert!",
                    message: "これ以上小さく出来ない！",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        case 4:
            if scoreLabelNum - (bombLabelNum-2)*5 < 0{
                let alert = UIAlertController(
                    title: "Alert!",
                    message: "スコアがたりない！",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }else{
                scoreLabelNum = scoreLabelNum - (bombLabelNum-2)*5
                scoreLabel.text = "SCORE:" + String(scoreLabelNum)
                usrD.set(scoreLabelNum, forKey: "score")
                bombLabelNum = bombLabelNum + 1
                usrD.set(bombLabelNum, forKey: "bombNumber")
                bombLabel.text = String(bombLabelNum)+"個：必要スコア"+String((bombLabelNum+1)*5)
                userRankLabel.text = "MS力：" + String(xLabelNum*yLabelNum*bombLabelNum)
                usrD.set(xLabelNum*yLabelNum*bombLabelNum, forKey: "rank")

            }
        case 5:
            if bombLabelNum > 3{
                bombLabelNum = bombLabelNum - 1
                usrD.set(bombLabelNum, forKey: "bombNumber")
                bombLabel.text = String(bombLabelNum)+"個：必要スコア"+String((bombLabelNum+1)*5)
            }else{
                let alert = UIAlertController(
                    title: "Alert!",
                    message: "爆弾はこれ以上減らせない！",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        default:break
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
