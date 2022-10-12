//
//  UIViewControllerExtensions.swift
//  MovieApp
//
//  Created by Murat ŞENOL on 23.06.2022.
//

import Foundation
import UIKit

extension UIViewController{
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            let child = SpinnerViewController()

            // add the spinner view self
            self.addChild(child)
            child.view.frame = self.view.frame
            self.view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    
    func dismissLoadingIndicator() {
        if let child = self.children.last as? SpinnerViewController{
            DispatchQueue.main.async
            {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
    }
    
    func dismiss(animated: Bool) {
        DispatchQueue.main.async {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    func configureNavigationBar(largeTitleColor: UIColor, backgroundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgroundColor

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title

        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgroundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }
}
