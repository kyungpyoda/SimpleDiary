//
//  InputMemoViewController.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit

protocol InputMemoDelegate {
    func addMemo(content: String)
}

class InputMemoViewController: UIViewController {
    
    // MARK: Properties
    
    var delegate: InputMemoDelegate?
    
    // MARK: Views
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    // MARK: Initialize
    
    init?(coder: NSCoder, delegate: InputMemoDelegate) {
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        setUpKeyboardNotification()
        setUpTextField()
    }
    
    private func setUpKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpTextField() {
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    // MARK: Methods
    
    private func addMemo() {
        guard let input = textField.text else { return }
        delegate?.addMemo(content: input)
        textField.text = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchedAddMemo(_ sender: Any) {
        addMemo()
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
    
}

// MARK: Implement TextFieldDelegate

extension InputMemoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        button.isEnabled = false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        button.isEnabled = !(textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == self.textField else { return false }
        addMemo()
        return true
    }
    
}
