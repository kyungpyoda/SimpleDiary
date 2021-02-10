//
//  InputMemoViewController.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit

class InputMemoViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    @objc func tappedBackground() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func touchedAddMemo(_ sender: Any) {
        print("메모추가해야함")
    }
}
