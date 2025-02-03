//
//  MainViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var localOrWifiBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var chirehLogo: UIBarButtonItem!
    
    var selectedMusic = ""
    
    var colors = [UIColor]()
    var faSideItems: [(color: UIColor, title: String, image: UIImage)] {
        return [(color: colors[0], title: "سرما و گرمایش", image: UIImage.init(named: "smart-home")!),(color: colors[1], title: "درب", image: UIImage.init(named: "open-exit-door")!),(color: colors[2], title: "امنیت", image: UIImage.init(named: "locked-padlock")!),(color: colors[3], title: "ریموت کنترل", image: UIImage.init(named: "remote-control")!),(color: colors[4], title: "پریز", image: UIImage.init(named: "power-cord")!),(color: colors[5], title: "پرده", image: UIImage.init(named: "livingroom-black-curtains")!),(color: colors[6], title: "آبیاری", image: UIImage.init(named: "irrigation")!),(color: colors[7], title: "دوربین", image: UIImage.init(named: "camera")!)]
    }
    var enSideItems: [(color: UIColor, title: String, image: UIImage)] {
        return [(color: colors[0], title: "Heat And Cooling", image: UIImage.init(named: "smart-home")!),(color: colors[1], title: "Door", image: UIImage.init(named: "open-exit-door")!),(color: colors[2], title: "Security", image: UIImage.init(named: "locked-padlock")!),(color: colors[3], title: "Remote Control", image: UIImage.init(named: "remote-control")!),(color: colors[4], title: "Socket", image: UIImage.init(named: "power-cord")!),(color: colors[5], title: "Curtain", image: UIImage.init(named: "livingroom-black-curtains")!),(color: colors[6], title: "Irrigation", image: UIImage.init(named: "irrigation")!),(color: colors[7], title: "Camera", image: UIImage.init(named: "camera")!)]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        localOrWifi()
       // chirehLogo.image = #imageLiteral(resourceName: "Logo")
        //create a new button
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "Logo"), for: UIControl.State.normal)
        //add function for button
       // button.addTarget(self, action: "fbButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        //set frame
        button.frame = CGRect(0, 0, 53, 31)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        if #available(iOS 11.0, *) {
            connectAction { (status) in
            }
        } else {
            underIos12()
        }
    }
    

    
    // Action
    @IBAction func homeButtonTapped(_ sender: RoundedButton) {
        playSound()
        performSegue(withIdentifier: "toHomeSegue", sender: nil)
    }
    
    @IBAction func lightingButtonTapped(_ sender: RoundedButton) {
        playSound()
        present(LightingViewController.showModal(), animated: true, completion: nil)
    }
    
    @IBAction func scenarioButtonTapped(_ sender: RoundedButton) {
        playSound()
//        present(ScenarioViewController.showModal(), animated: true, completion: nil)
        performSegue(withIdentifier: "toScenarioSegue", sender: sender)
    }
    
    // ** MUSIC ACTION BUTTON **
    @IBAction func playButtonTapped(_ sender: Any) {
        guard selectedMusic != "" else { return }
        playSound()
        SocketService.instance.playMusic(musicName: selectedMusic) { (played) in
            if played {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        playSound()
        SocketService.instance.musicActions(action: .StopMusic) { (done) in
            if done {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        playSound()
        SocketService.instance.musicActions(action: .NextMusic) { (done) in
            if done {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    @IBAction func previewButtonTapped(_ sender: Any) {
        playSound()
        SocketService.instance.musicActions(action: .PrevMusic) { (done) in
            if done {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    @IBAction func volumeUpButtonTapped(_ sender: Any) {
        playSound()
        SocketService.instance.musicActions(action: .MusicVolUp) { (done) in
            if done {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    @IBAction func volumeDownButtonTapped(_ sender: Any) {
        playSound()
        SocketService.instance.musicActions(action: .MusicVolDown) { (done) in
            if done {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    @IBAction func uploadMusicFileTapped(_ sender: Any) {
        //
    }
    // *** *** ACTION UPLOAD MUSIC DAR EXTENSION PAYIN HAST **** ****
    
    
    
    // Adobe Color Action
    @IBAction func purpleBarButton(_ sender: Any) {
        playSound()
        let colorsPalletOne = [#colorLiteral(red: 0.2156862745, green: 0.3529411765, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.2941176471, green: 0.3921568627, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.431372549, green: 0.3529411765, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.7647058824, green: 0.3529411765, blue: 0.4470588235, alpha: 1),#colorLiteral(red: 0.7647058824, green: 0.431372549, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.9607843137, green: 0.4509803922, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.9803921569, green: 0.6352941176, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.9803921569, green: 0.7058823529, blue: 0.5882352941, alpha: 1)]
        var myColor = [PalletColor]()
        for color in colorsPalletOne {
            let c = PalletColor.init(uiColor: color)
            myColor.append(c)
        }
        PalletColor.encode(colors: myColor, directory: PalletColor.archiveURL) // save^
        self.colors = colorsPalletOne
        self.tableView.reloadData()
    }
    
    @IBAction func redBarButton(_ sender: Any) {
        playSound()
        let colorsPalletThree = [#colorLiteral(red: 0.2, green: 0.003921568627, blue: 0.2117647059, alpha: 1),#colorLiteral(red: 0.368627451, green: 0.09019607843, blue: 0.2588235294, alpha: 1),#colorLiteral(red: 0.4980392157, green: 0.1215686275, blue: 0.3529411765, alpha: 1),#colorLiteral(red: 0.5882352941, green: 0.1803921569, blue: 0.2509803922, alpha: 1),#colorLiteral(red: 0.7411764706, green: 0.2274509804, blue: 0.3176470588, alpha: 1),#colorLiteral(red: 0.7882352941, green: 0.2745098039, blue: 0.2392156863, alpha: 1),#colorLiteral(red: 1, green: 0.368627451, blue: 0.2078431373, alpha: 1),#colorLiteral(red: 1, green: 0.368627451, blue: 0.431372549, alpha: 1)]
        var myColor = [PalletColor]()
        for color in colorsPalletThree {
            let c = PalletColor.init(uiColor: color)
            myColor.append(c)
            
        }
        PalletColor.encode(colors: myColor, directory: PalletColor.archiveURL) // save^
        self.colors = colorsPalletThree
        self.tableView.reloadData()
        

    }
    
    @IBAction func greenBarButton(_ sender: Any) {
        playSound()
        let colorsPalletTwo = [#colorLiteral(red: 0, green: 0.168627451, blue: 0.2196078431, alpha: 1),#colorLiteral(red: 0, green: 0.2588235294, blue: 0.3411764706, alpha: 1),#colorLiteral(red: 0.1215686275, green: 0.5411764706, blue: 0.4392156863, alpha: 1),#colorLiteral(red: 0.1568627451, green: 0.6980392157, blue: 0.5019607843, alpha: 1),#colorLiteral(red: 0.7450980392, green: 0.8588235294, blue: 0.2235294118, alpha: 1),#colorLiteral(red: 0.7450980392, green: 0.8588235294, blue: 0.5215686275, alpha: 1),#colorLiteral(red: 1, green: 0.8823529412, blue: 0.1019607843, alpha: 1),#colorLiteral(red: 0.9921568627, green: 0.4549019608, blue: 0, alpha: 1)]
        var myColor = [PalletColor]()
        for color in colorsPalletTwo {
            let c = PalletColor.init(uiColor: color)
            myColor.append(c)
        }
        PalletColor.encode(colors: myColor, directory: PalletColor.archiveURL) // save^
        self.colors = colorsPalletTwo
        self.tableView.reloadData()
    }
    
    
    
    // Method
    func updateUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(localOrWifi), name: Constant.Notify.localOrWifiNotify, object: nil)
        backBarButtonAttribute(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), name: "")
        addChangedLanguagedToViewController()
        if DataManager.shared.applicationLanguage == .fa {
            title = "خـانـه"
        } else {
            title = "Home"
        }
        updateTabBarLanguage()
        if let palletColors = PalletColor.decode(directory: PalletColor.archiveURL) {
            for color in palletColors {
                let i = UIColor.init(red: color.r, green: color.g, blue: color.b, alpha: color.alpha)
                self.colors.append(i)
            }
        } else {
            colors = [#colorLiteral(red: 0.2156862745, green: 0.3529411765, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.2941176471, green: 0.3921568627, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.431372549, green: 0.3529411765, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.7647058824, green: 0.3529411765, blue: 0.4470588235, alpha: 1),#colorLiteral(red: 0.7647058824, green: 0.431372549, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.9607843137, green: 0.4509803922, blue: 0.5098039216, alpha: 1),#colorLiteral(red: 0.9803921569, green: 0.6352941176, blue: 0.4901960784, alpha: 1),#colorLiteral(red: 0.9803921569, green: 0.7058823529, blue: 0.5882352941, alpha: 1)]
        }

    }
    
    @objc func localOrWifi() {
        print("check local or wifi")
        print(DataManager.shared.local)
        DispatchQueue.main.async {
            if DataManager.shared.local {
                self.localOrWifiBarButtonItem.image = UIImage.init(named: "local")
                if SocketService.instance.checkStatus() {
                    self.localOrWifiBarButtonItem.image?.withRenderingMode(.alwaysTemplate)
                    self.localOrWifiBarButtonItem.tintColor = .green
                } else {
                    self.localOrWifiBarButtonItem.image?.withRenderingMode(.alwaysTemplate)
                    self.localOrWifiBarButtonItem.tintColor = .black
                }
            } else {
                self.localOrWifiBarButtonItem.image = UIImage.init(named: "wifi_in")
                if SocketService.instance.checkStatus() {
                    self.localOrWifiBarButtonItem.image?.withRenderingMode(.alwaysTemplate)
                    self.localOrWifiBarButtonItem.tintColor = .green
                } else {
                    self.localOrWifiBarButtonItem.image?.withRenderingMode(.alwaysTemplate)
                    self.localOrWifiBarButtonItem.tintColor = .black
                }
            }
        }
    }

    func updateTabBarLanguage() {
        if let vcs = tabBarController?.viewControllers {
            let language = DataManager.shared.applicationLanguage
            for (i,vc) in vcs.enumerated() {
                switch i {
                case 0:
                    if language == .fa {
                        vc.tabBarItem.title = "خـانـه"
                    } else {
                        vc.tabBarItem.title = "Home"
                    }
                case 1:
                    if language == .fa {
                        vc.tabBarItem.title = "نتظیمات"
                    } else {
                        vc.tabBarItem.title = "Setting"
                    }
                case 2:
                    if language == .fa {
                        vc.tabBarItem.title = "اسپیلیت"
                    } else {
                        vc.tabBarItem.title = "Split"
                    }
                case 3:
                    if language == .fa {
                        vc.tabBarItem.title = "نورپردازی"
                    } else {
                        vc.tabBarItem.title = "RGB"
                    }
                default:
                    break
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.toMusicFileSegue.rawValue {
            let destination = segue.destination as! MusicFileViewController
            destination.delegate = self
        }
    }
    
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faSideItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.sideTableCell.rawValue, for: indexPath) as! SideMenuTableViewCell
        if DataManager.shared.applicationLanguage == .fa {
            let item = faSideItems[indexPath.row]
            cell.configureCell(color: item.color, title: item.title, image: item.image)
        } else {
            let item = enSideItems[indexPath.row]
            cell.configureCell(color: item.color, title: item.title, image: item.image)
        }
        cell.iconImageView.tintImageColor(color: .white)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: (color: UIColor, title: String, image: UIImage)
        if DataManager.shared.applicationLanguage == .fa {
            item = faSideItems[indexPath.row]
        } else {
            item = enSideItems[indexPath.row]
        }
        playSound()
        switch indexPath.row {
        case 0:
            present(CoolAndHeatViewController.showModal(), animated: true, completion: nil)
        case 1:
            present(DoorViewController.showModal(), animated: true, completion: nil)
        case 2: // Security -> just write your code here*
            present(SecurityViewController.showModal(), animated: true, completion: nil)
        case 3: // Remote Controll
            performSegue(withIdentifier: Constant.Segue.toRemoteSegue.rawValue, sender: nil)
        case 4:
            present(SocketViewController.showModal(), animated: true, completion: nil)
        case 5:
            present(CurtainViewController.showModal(), animated: true, completion: nil)
        case 6:
            present(IrrigationViewController.showModal(), animated: true, completion: nil)
        case 7: // Camera -> Later
            break
        default:
            break
        }
    }
    
    
}

// Music Player
extension MainViewController: MusicFileViewControllerDelegate {
    
    // ** Action - Music selected from MusicFileVC **
    func selectMusicFile(item: String) {
        self.selectedMusic = item
    }
    
    
    
}

// Teodik Codding

extension MainViewController {
    @available(iOS 11.0, *)
    //sina
    func connectAction(completion: @escaping (_ connected: Bool) -> Void) {
        guard let login = DataManager.shared.userInformation else { return }
        guard getWiFiName() != login.data.ssid else {
            DataManager.shared.local = true ; NotificationCenter.default.post(name: Constant.Notify.localOrWifiNotify, object: nil) ; completion(true) ; return }
        let hotspotConfig = NEHotspotConfiguration(ssid: login.data.ssid, passphrase: login.data.password, isWEP: false)
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[unowned self] (error) in
            if let error = error {
               // self.showError(error: error.localizedDescription)
                completion(false)
            } else {
                if self.getWiFiName() == login.data.ssid {
                  //  self.showSuccess()
                    completion(true)
                } else {
                  //  self.showError(error: "")
                    completion(false)
                }
                
            }
        }
    }
    
    @available(iOS 11.0, *)
    func disconnectAction() {
        guard let login = DataManager.shared.userInformation else { return }
        NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: login.data.ssid)
    }
    
    private func showError(error: String) {
        let alert = UIAlertController(title: "مشکلی در برقراری ارتباط بوجود آمده است", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func showSuccess() {
        let alert = UIAlertController(title: "ارتباط موفق", message: "شما به روتر وصل شدید", preferredStyle: .alert)
        let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func underIos12() {
        guard let login = DataManager.shared.userInformation else { return }
        let alert = UIAlertController(title: "توجه", message: "لطفا از تنظیمات به وایرلس رمز عبور\(login.data.password) \(login.data.ssid) وصل شوید", preferredStyle: .alert)
        let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func getWiFiName() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
}
