//
//  ViewController.swift
//  Donation
//
//  Created by Daniel Pan on 2018-09-22.
//  Copyright © 2018 geekmouse. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var lbEarn: UILabel!
    
    @IBOutlet weak var imgHat: UIImageView!
    
    
    var origConnectId:String = ""
    let colorService = ColorService()
    
    var earned: Int = 42
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        syncUI()
        colorService.delegate = self
//        animateCoin(amount: 10)
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        
        let path = Bundle.main.path(forResource: "coinSound.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            // couldn't load file :(
        }
    }

    func syncUI() -> Void {
        self.lbEarn.text = "Today Earned: $\(self.earned) "
    }
    
    func animateCoin(amount: Int) -> Void {
        let x = 300.0
        let size = 150.0
        let imageView = UIImageView(frame: CGRect(x:x,y:100.0,width:size, height:size))
        imageView.image = UIImage(named: "Coin")!
        self.view.addSubview(imageView)
        var viewThis = self.view
        
        UIView.animate(withDuration: 2.0, animations: {()->Void in
            imageView.center.y += 400
            
        },completion:{(finished)->Void in
            self.playSound()
            self.earned += amount
            self.syncUI()
            imageView.removeFromSuperview()
            
        })
        
        UIView.animate(withDuration: 1.0, animations: {()->Void in
            viewThis?.backgroundColor = UIColor.green
        },completion:{(finished)->Void in
            UIView.animate(withDuration:1.0, animations: {()->Void in
                viewThis?.backgroundColor = UIColor.white
                
            },completion:{(finished)->Void in
            })
        })
        
    }
}

extension ViewController : ColorServiceDelegate {
    
    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            var viewThis = self.view
            if connectedDevices.count == 0 {
                NSLog("lost connection")
                UIView.animate(withDuration: 0.7, animations: {()->Void in
                    viewThis?.backgroundColor = UIColor.white
                },completion:{(finished)->Void in
                    
                })
            }
            else if connectedDevices[0] != self.origConnectId{
                NSLog("connected:>>> 0")
                UIView.animate(withDuration: 0.7, animations: {()->Void in
                    viewThis?.backgroundColor = UIColor.gray
                },completion:{(finished)->Void in
                    
                })
            }
            else{
                NSLog("lost connection")
                UIView.animate(withDuration: 0.7, animations: {()->Void in
                    viewThis?.backgroundColor = UIColor.white
                },completion:{(finished)->Void in
                    
                })
            }
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }
    
    func colorChanged(manager: ColorService, colorString: String) {
        OperationQueue.main.addOperation {
            self.animateCoin(amount: 1)
//            switch colorString {
//            case "red":
//                self.change(color: .red)
//            case "yellow":
//                self.change(color: .yellow)
//            default:
//                NSLog("%@", "Unknown color value received: \(colorString)")
//            }
        }
    }
    
}
