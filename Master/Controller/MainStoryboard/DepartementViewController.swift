//
//  DepartementViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import DropDown

class DepartementViewController: UIViewController {
    
    @IBOutlet weak var departmentButton: RoundedButton!

    private let departmentDropButton = DropDown()
    
    fileprivate var departmentData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let building = Login.decode(directory: Login.archiveURL)?.building else { return }
        self.departmentData.append(building)
        print(building)
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.global(qos: .background).async {          
            SocketService.instance.checkActivity()
        }
        if Authentication.auth.isLoggedIn {
            if DataManager.shared.isLoggedInWithPassowrd {
                authenticateWithTouchID()
            }
        } else {
            present(LoaderViewController.showModal(), animated: true, completion: nil)
        }
    }
    
    // Action
    @IBAction func manageBuildingButtonTapped(_ sender: Any) {
        // code*
        playSound()
        performSegue(withIdentifier: "toMainSegue", sender: sender) // go to mainVC
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        // code*
        playSound()
        Authentication.auth.logOutAuth()
        present(LoaderViewController.showModal(), animated: true, completion: nil)
    }
    
    @IBAction func departmentButtonTapped(_ sender: RoundedButton) {
        playSound()
        departmentDropButton.show()
    }
    
    // Method
    func updateUI() {
        addChangedLanguagedToViewController()
        departmentDropButton.anchorView = departmentButton
        departmentDropButton.bottomOffset = CGPoint(x: 0, y: departmentButton.bounds.height)
        departmentDropButton.textFont = UIFont.persianFont(size: 16)
        departmentDropButton.dataSource = departmentData
        departmentButton.setTitle(departmentData.first, for: .normal)
        self.departmentDropButton.selectionAction = { (index, item) in
            let item = self.departmentData[index]
            self.departmentButton.setTitle(item, for: .normal)
            // drop down button action
            // code*
        }
    }
    
    

}
