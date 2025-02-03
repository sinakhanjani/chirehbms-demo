//
//  MusicFileViewController.swift
//  CHIREH BMS
//
//  Created by Sinakhanjani on 10/30/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol MusicFileViewControllerDelegate {
    func selectMusicFile(item: String)
}

class MusicFileViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate:MusicFileViewControllerDelegate?
    var musics: Music?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // Method
    func updateUI() {
        configureStoryboardTouchViewController(bgView: bgView)
        addChangedLanguagedToViewController()
        SocketService.instance.getMusic { (musics) in
            DispatchQueue.main.async {
                self.musics = musics
                self.collectionView.reloadData()
            }
        }
    }
    
    static func showModal() -> MusicFileViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MusicFileViewControllerID") as! MusicFileViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }

}


extension MusicFileViewController: UICollectionViewDataSource, UICollectionViewDelegate, MusicFileCollectionViewCellDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musics?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Cell.musicFileCell.rawValue, for: indexPath) as! MusicFileCollectionViewCell
        cell.delegate = self
        guard let music = musics?.data[indexPath.row] else { return cell }
        cell.configureCell(musicName: music)
        return cell
    }
    
    // *** BUTTON EVENT ***
    func musicFileButtonTapped(cell: MusicFileCollectionViewCell, sender: RoundedButton) {
        if let indexPath = collectionView.indexPath(for: cell) {
            guard let item = musics?.data[indexPath.item] else { return }
            playSound()
            delegate?.selectMusicFile(item: item) // delegate to MainVC
            //code**
            guard let musicName = musics?.data[indexPath.row] else { return }
            SocketService.instance.playMusic(musicName: musicName) { (played) in
                if played {
                    self.presentIOSOkWarning()
                } else {
                    self.presentIOSProblemWarning()
                }
            }
        }
    }
    
    
}
