//
//  ordersViewController.swift
//  Practice
//
//  Created by Siddhesh jadhav on 25/05/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit

class ordersViewController: UIViewController {
    
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    
    @IBOutlet weak var currentViewIndicator: UIView!
    
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let screenSize = UIScreen.main.bounds
    var currentView = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        currentView = 1
        switchViewsIn()
        currentView = 0
        switchViewsIn()
        
        orderTable.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(orderTable)
        
        
        historyTable.frame = CGRect(x: self.view.frame.width, y: 0, width: screenSize.width, height: scrollView.frame.height)
        scrollView.addSubview(historyTable)
        
        
        //to set initial view state
        self.currentViewIndicator.frame = CGRect(x: 0, y: 43, width: self.screenSize.width/2, height: 2)
        
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.scrollView.frame.height)
    }
    
    
    
    func switchViewsIn(){
        if currentView == 0{
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollView.contentOffset.x = 0
                self.currentViewIndicator.frame = CGRect(x: 0, y: 43, width: self.screenSize.width/2, height: 2)
            }) { (Bool) in
            }
            
            
            orderTable.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
        }else if currentView == 1{
            UIView.animate(withDuration: 0.4, animations: {
                self.scrollView.contentOffset.x = self.view.frame.width
                self.currentViewIndicator.frame = CGRect(x: self.screenSize.width/2, y: 43, width: self.screenSize.width/2, height: 2)
            }) { (Bool) in
            }
            
            historyTable.frame = CGRect(x: self.view.frame.width, y: 0, width: screenSize.width, height: scrollView.frame.height)
            
        }
    }
    
    
    
    @IBAction func toggleScrollView(_ sender: UIButton) {
        currentView = sender.tag
        switchViewsIn()
    }
    
}

extension ordersViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView1: UIScrollView) {
        if scrollView1 == scrollView{
            let scrolledDistance = (scrollView1.contentOffset.x)/2
            print("scrolledDistance", scrolledDistance)
            currentViewIndicator.transform = CGAffineTransform(translationX: scrolledDistance, y: 0)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView1: UIScrollView) {
        if scrollView1 == scrollView{
            if self.scrollView.contentOffset.x == 0{
                currentView = 0
                switchViewsIn()
            }else{
                currentView = 1
                switchViewsIn()
            }
        }
    }
    
}
