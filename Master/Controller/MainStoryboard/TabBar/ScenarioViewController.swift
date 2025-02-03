//
//  ScenarioViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

class ScenarioViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lastScenarioLabel: LanguageLabel!
    
    var scenario: Scenarios?
    var lastScenario = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicatorAnimate()
        updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Constant.Notify.readActivityUpdated, object: nil)
    }
    
    @objc func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.checkLastScenario()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLastScenario()
        if let scenario = Scenarios.decode(directory: Scenarios.archiveURL) {
            self.scenario = scenario
            self.collectionView.reloadData()
            self.stopIndicatorAnimate()
        } else {
            SocketService.instance.getScenarios { (scenario) in
                guard let scenario = scenario else { self.stopIndicatorAnimate() ; self.presentTryLater() ; return }
                self.scenario = scenario
                DispatchQueue.main.async {
                    Scenarios.encode(userInfo: scenario, directory: Scenarios.archiveURL)
                    self.collectionView.reloadData()
                    self.stopIndicatorAnimate()
                }
            }
        }
        
    }
    
    func checkLastScenario() {
        guard let last = ReadController.instance.lastScenario else { return }
        let defaultEnText = "Last Scenario: " + last.name
        let defaultFaText = "آخرین سناریو: " + last.name
        let reasonText = DataManager.shared.applicationLanguage == .fa ? defaultFaText:defaultEnText
        self.lastScenarioLabel.text = reasonText
        self.lastScenario = last.name
    }
    
    // Method
    func updateUI() {
        configureStoryboardTouchViewController(bgView: bgView)
        addChangedLanguagedToViewController()
    }
    
    static func showModal() -> ScenarioViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScenarioViewControllerID") as! ScenarioViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }
    
}

extension ScenarioViewController: UICollectionViewDataSource, UICollectionViewDelegate, ScenarioCollectionViewCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scenario?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.scenarioCell.rawValue, for: indexPath) as! ScenarioCollectionViewCell
        cell.delegate = self
        let scenarioName = scenario?.data[indexPath.row].name ?? ""
        let check = ReadController.instance.checkServerReaded(moduleName: scenario?.data[indexPath.row].name ?? "")
        cell.tickImageView.image = check ? #imageLiteral(resourceName: "doubleTick") : #imageLiteral(resourceName: "tick")
        cell.configureCell(scenarioName: scenarioName)
        return cell
    }
    
    // *** BUTTON EVENT ***
    func scenarioButtonTapped(cell: ScenarioCollectionViewCell, sender: RoundedButton) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        guard let name = scenario?.data[indexPath.row].name else { return }
        playSound()
        cell.tickImageView.image = #imageLiteral(resourceName: "tick")
        SocketService.instance.createActivity(activityName: .Scenario, firstParam: name) { (activity) in
            if activity?.result ?? false {
                self.presentIOSOkWarning()
            } else {
                self.presentIOSProblemWarning()
            }
        }
    }
    
    
}

