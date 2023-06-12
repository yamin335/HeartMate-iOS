//
//  AppAlert.swift
//  Safidence
//
//  Created by Hamza Saeed on 28/10/2021.
//

import UIKit
extension UIViewController{
    func showAlert(message: String, titled title: String) {
        dispatchPrecondition(condition: .onQueue(.main))
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    func generateAlert(withMsg msg: String?, otherBtnTitle: String?, completion: @escaping (_ refresh: Bool) -> Void) {
        dispatchPrecondition(condition: .onQueue(.main))
        let reloadAlert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)

        reloadAlert.addAction(UIAlertAction(title: otherBtnTitle, style: .default, handler: { (action: UIAlertAction!) in
            completion(true)
        }))

        present(reloadAlert, animated: true, completion: nil)
    }

    func showAlertWithYesNo(withMsg msg: String?, yesBtnTitle: String?, noBtnTitle: String?, completion: @escaping (_ refresh: Bool) -> Void) {
        dispatchPrecondition(condition: .onQueue(.main))
        let reloadAlert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)

        reloadAlert.addAction(UIAlertAction(title: yesBtnTitle, style: .default, handler: { (action: UIAlertAction!) in
            completion(true)
        }))

        reloadAlert.addAction(UIAlertAction(title: noBtnTitle, style: .default, handler: { (action: UIAlertAction!) in
            completion(false)
        }))
        present(reloadAlert, animated: true, completion: nil)
    }

    func showToast(message : String) {
            let toastLabel = UILabel(frame: CGRect(x: 25, y: self.view.frame.size.height - 100, width: self.view.frame.size.width-50, height:50))
            toastLabel.backgroundColor = UIColor.black
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont(name: "Inter-Regular", size: 16.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 5
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
}
