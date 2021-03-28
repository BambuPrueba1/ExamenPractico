//
//  ViewController.swift
//  bambooPracticalExam
//
//  Created by Cuacko on 25/03/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var iniciarSesionButton: UIButton!
    @IBOutlet weak var registroButton: UIButton!
    @IBOutlet weak var errorEmailLB: UILabel!
    @IBOutlet weak var errorPasswordLB: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.view.endEditing(true)
        
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
        
        if isValid {
            showSpinner{
                Auth.auth().signIn(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { [weak self] authResult, error in
                    self!.hideSpinner{
                        guard let user = authResult?.user, error == nil else {
                            self!.showAlert(title: "Error", message: error!.localizedDescription)
                            return
                        }
                        
                        UserDefaults.standard.setValue(1, forKey: "login")
                        
                        let vc = self?.storyboard?.instantiateViewController(identifier: "listaVC")
                        guard let viewcontroller = vc else { return }
                        
                        self?.navigationController?.pushViewController(viewcontroller, animated: true)
                    }
                }
            }
        }
    }
    
    
//    @IBAction func forgotPassAction(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(identifier: "segundoVC")
//
//        guard let viewcontroller = vc else { return }
//
//        navigationController?.pushViewController(viewcontroller, animated: true)
//    }
    
    
    //Autenticación de email, funcion isValidEmail.
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }  //Final de Función de Validación.
    
    
    // Autenticacion de password, funcion isValidPassword
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "[0-9]{8,16}"
        
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPredicate.evaluate(with: password)
    }  //Final de Función de Autenticación de Password
    
    @IBAction func registroButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "registroVC")
        guard let viewcontroller = vc else { return }
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil ))
        self.present(alert, animated: true)
    }
}
