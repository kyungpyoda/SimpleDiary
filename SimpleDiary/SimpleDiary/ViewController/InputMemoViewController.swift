//
//  InputMemoViewController.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit

class InputMemoViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setUpGesture()
        setUpKeyboardNotification()
    }
    private func setUpGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let info = notification.userInfo,
              let size = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        UIView.animate(withDuration: duration, delay: 0, options: .init(rawValue: curve), animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -size.cgRectValue.height)
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.contentView.transform = .identity
    }

    @objc func tappedBackground() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchedAddMemo(_ sender: Any) {
        print("메모추가해야함")
    }
}
