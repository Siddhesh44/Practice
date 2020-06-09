//
//  CarouselVC.swift
//  Practice
//
//  Created by Siddhesh jadhav on 26/05/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class CarouselVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arr = [#imageLiteral(resourceName: "AnimeX_596887"),#imageLiteral(resourceName: "AnimeX_861816"),#imageLiteral(resourceName: "AnimeX_815592"),#imageLiteral(resourceName: "AnimeX_862065")]
    
    var timer: Timer?
    var currentScrollIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(self.autoRotateBanners)), userInfo: nil, repeats: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if arr.count > 0{
//            currentScrollIndex = 0
//            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(self.autoRotateBanners)), userInfo: nil, repeats: true)
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        timer?.invalidate()
//    }
    
    @objc func autoRotateBanners() {
        if currentScrollIndex < arr.count - 1{
            currentScrollIndex = currentScrollIndex + 1
            let indexPath = IndexPath(item: currentScrollIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        }else{
            currentScrollIndex = 0
            let indexPath = IndexPath(item: currentScrollIndex, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension CarouselVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCell
        cell.foreGroundImage.image = arr[indexPath.row]
        cell.backGroundImage.image = cell.foreGroundImage.image
        return cell
    }
}
