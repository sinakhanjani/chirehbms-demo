//
//  SecurityViewController.swift
//  Master
//
//  Created by Teodik Abrami on 3/7/19.
//  Copyright © 2019 iPersianDeveloper. All rights reserved.
//

import UIKit

class SecurityViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var seenImageView: UIImageView!
//    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var offButton: RoundedButton!
    @IBOutlet weak var onButton: RoundedButton!
    
    var module: GetModules?
    var rooms: RoomDatas?
    let redColor = [#colorLiteral(red: 1, green: 0, blue: 0.008841688611, alpha: 1),#colorLiteral(red: 0.3290408193, green: 0.003032437769, blue: 0.005941839723, alpha: 1)]
    let greenColor = [#colorLiteral(red: 0.0008148038319, green: 1, blue: 0.04264592906, alpha: 1),#colorLiteral(red: 0.01422935223, green: 0.200489683, blue: 0.0003957320064, alpha: 1)]
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateSeen()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Constant.Notify.readActivityUpdated, object: nil)
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
           self.updateSeen()
        }
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
        configureStoryboardTouchViewController(bgView: bgView)
        if let module = RoomDatas.decode(directory: RoomDatas.archiveURL) {
            self.rooms = module
        } else {
            DispatchQueue.main.async {
                SocketService.instance.getRooms { (rooms) in
                    guard let rooms = rooms else { self.presentTryLater() ; return }
                    self.rooms = rooms
                    RoomDatas.encode(userInfo: rooms, directory: RoomDatas.archiveURL)
                }
                
            }
        }
    }
    
    
    func updateSeen() {
        let check1 = ReadController.instance.checkServerReaded(moduleName: "Security")
        seenImageView.image = check1 ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        let last = ReadController.instance.checkTrueActivities(module: "Security")
        if last {
            //segmentController.selectedSegmentIndex = 0
            color("Active")
        } else {
            //segmentController.selectedSegmentIndex = 1
            color("Deactive")
        }
    }
    
    static func showModal() -> SecurityViewController {
        let storyboard = UIStoryboard.init(name: "Side", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecurityViewControllerID") as! SecurityViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

    
    @IBAction func onButtonPressed(_ sender: Any) {
        seenImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = "Active"
        color(onOrOff)
        SocketService.instance.createActivity(activityName: .Scenario, firstParam: "Security", secondParam: onOrOff) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                    self.color(onOrOff)
                } else {
                    self.color("Deactive")
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    @IBAction func offButtonPressed(_ sender: Any) {
        seenImageView.image = #imageLiteral(resourceName: "tick")
        playSound()
        let onOrOff = "Deactive"
        color(onOrOff)
        SocketService.instance.createActivity(activityName: .Scenario, firstParam: "Security", secondParam: onOrOff) { (activity) in
            DispatchQueue.main.async {
                if activity?.result ?? false {
                    self.presentIOSOkWarning()
                    self.color("Deactive")
                } else {
                    self.color(onOrOff)
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    func color(_ status: String) {
        if status == "Active" {
            onButton.backgroundColor = greenColor[0]
            offButton.backgroundColor = redColor[1]
        } else {
            onButton.backgroundColor = greenColor[1]
            offButton.backgroundColor = redColor[0]
        }
    }
}
