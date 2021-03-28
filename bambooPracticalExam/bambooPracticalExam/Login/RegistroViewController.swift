//
//  RegistroViewController.swift
//  bambooPracticalExam
//
//  Created by Cuacko on 27/03/21.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var errorEmailLB: UILabel!
    @IBOutlet weak var errorPasswordLB: UILabel!
    
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        handleTap(nil)
        
        guard isValid() else { return }
        
        showSpinner{
            Auth.auth().createUser(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { authResult, error in
                print(authResult)
                print(error)
                self.hideSpinner{
                    guard let user = authResult?.user, error == nil else {
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                        return
                    }
                    
                    self.showAlert(title: "Éxito", message: "Cuenta creada con exito")
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "[0-9]{8,16}"
        
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }
    
    
    func isValid() -> Bool {
        var isValid = true
        errorEmailLB.isHidden = true
        errorPasswordLB.isHidden = true
        
        if !isValidEmail( emailTF.text ?? "" ) {
            errorEmailLB.isHidden = false
            isValid = false
        }
        
        if !isValidPassword(password: passwordTF.text ?? "") {
            errorPasswordLB.isHidden = false
            isValid = false
        }
        
        return isValid
    }
    
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:
                                        {
                                            (alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)
                                            
                                        } ))
//        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

