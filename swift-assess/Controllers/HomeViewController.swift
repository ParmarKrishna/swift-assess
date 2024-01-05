//
//  HomeViewController.swift
//  swift-assess
//
//  Created by Admin on 04/01/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchField: UITextField!
    var username:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding observers
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: - Keyboard Functionality
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if searchField.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomConstraint, keyboardWillShow: true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.bottomConstraint, keyboardWillShow: false)
    }
    func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // Keyboard's animation curve
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
        }else {
            viewBottomConstraint.constant = 20
        }
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        username = searchField.text!
        if username == ""{
            let alert = UIAlertController(title: "⚠️ Username is empty", message: "Please provide username to begin search", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler:nil))
            DispatchQueue.main.async{
                self.present(alert, animated: true)
            }
            return 
        } else{
            self.performSegue(withIdentifier: "toUserHome", sender: self)
        }
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //         Get the new view controller using segue.destination.
        if segue.identifier == "toUserHome"{
            let destinationVC = segue.destination as! UserTableViewController
            destinationVC.title = "Searching for \(username)"
            destinationVC.username=username}
    }
    
}
