//
//  LeftSlideViewController.swift
//  ATom
//
//  Created by phan.the.chau on 2/24/20.
//  Copyright © 2020 phan.the.chau. All rights reserved.
//

import UIKit


class PageMainDashBoardViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .init(hex: "F0F0F0")
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .reverse,
                animated: true,
                completion: nil)
        }
        //removeSwipeGesture()
        addTopView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func getMiddelController()  {
         
    }
    
    func removeSwipeGesture(){
        for view in self.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    private func addTopView() {
        let dashBoardTopView = DashBoardTopView(frame: CGRect(x: 0,
                                                              y: 40,
                                                              width: view.frame.size.width,
                                                              height: 50))
        dashBoardTopView.delegate = self
        dashBoardTopView.backButton.isHidden = true
        view.addSubview(dashBoardTopView)
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        let vcDashBoard = newViewController(name: "DashBoardViewController") as! DashBoardViewController
        vcDashBoard.reportButton = { [weak self] in
            self?.startReport()
        }
        
        vcDashBoard.startERCButton = { [weak self] in
            self?.startERC()
        }
        
        let vcElectrodecs = newViewController(name: "ElectrodecsController") as! ElectrodecsController
        
        vcElectrodecs.backToDashBoardButton = { [weak self] in
            self?.nextPage()
        }
        
        let vcReport = newViewController(name: "ReportDashBoardViewController") as! ReportDashBoardViewController
        
        vcReport.backToDashBoardButton = { [weak self] in
            self?.previousPage()
        }
        
        return [vcDashBoard,
                vcElectrodecs,
                vcReport]
    }()
    
    private func newViewController(name: String) -> UIViewController {
        return UIStoryboard(name: "Dashboard", bundle: nil) .
            instantiateViewController(withIdentifier: name)
    }
    
    private func nextPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
               guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
               setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func previousPage() {
        guard let currentViewController = self.viewControllers?.first else { return }
               guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
               setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    private func startReport() {
        nextPage()
    }
    
    private func startERC() {
        previousPage()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PageMainDashBoardViewController: UIPageViewControllerDataSource {
 
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension PageMainDashBoardViewController: DashBoardTopViewProtocol {
    func onActionMenuButton() {
        let rightVC = UIStoryboard(name: "ReportSTB", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")  as! SettingViewController
        self.navigationController?.pushViewController(rightVC, animated: true)
    }
    
    func onActionBackButton() {
        
    }
}
