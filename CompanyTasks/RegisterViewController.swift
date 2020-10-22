import UIKit
import CoreData
let textFieldForUsernameReg: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.textColor = .black
    tf.borderStyle = .roundedRect
    tf.placeholder = " username"
    tf.font = UIFont(name: "Helvetica-Light", size: 20)
    tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return tf
}()
let textFieldForPasswordReg: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.textColor = .black
    tf.borderStyle = .roundedRect
    tf.placeholder = " password"
    tf.font = UIFont(name: "Helvetica-Light", size: 20)
    tf.isSecureTextEntry = true
    tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return tf
}()
let stackForTextFieldReg: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [textFieldForUsernameReg, textFieldForPasswordReg])
    stack.axis  = .vertical
    stack.distribution  = .fillEqually
    stack.spacing   = 30.0
    return stack
}()
class RegisterViewController: UIViewController {
    let cancelButton: UIButton = {
        let bttn = UIButton(type: .close)
        bttn.addTarget(self, action: #selector(actionForCancelButton), for: .touchUpInside)
        return bttn
    }()
    let buttonForRegister: UIButton = {
        let bttn = UIButton()
        bttn.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.3)
        bttn.setTitle("Register", for: .normal)
        bttn.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 20)
        bttn.setTitleColor(.black, for: .normal)
        bttn.layer.cornerRadius = 10
        bttn.addTarget(self, action: #selector(actionForRegisterButton), for: .touchUpInside)
        return bttn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stackForTextFieldsReg()
        constraintForCancelButton()
        constraintForRegisterButton()
    }
    
    @objc func actionForCancelButton() {
        textFieldForPasswordReg.text?.removeAll()
        textFieldForUsernameReg.text?.removeAll()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func actionForRegisterButton() {
        checkTextField()
        textFieldForPasswordReg.text?.removeAll()
        textFieldForUsernameReg.text?.removeAll()
        
    }
    private func checkTextField(){
        let checkForExist = forCheckExistUser()
        if textFieldForUsernameReg.text!.isEmpty  || textFieldForPasswordReg.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Fill in login and password", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in }
            alert.addAction(alertAction)
            present(alert,animated: true,completion: nil)
        } else if textFieldForUsernameReg.text!.contains(" ") || textFieldForPasswordReg.text!.contains(" ") || textFieldForUsernameReg.text!.count < 8 || textFieldForPasswordReg.text!.count < 8 {
            let alert = UIAlertController(title: "Error", message: "Username and password cant have space and should be more than 7 symbols", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in }
            alert.addAction(alertAction)
            present(alert,animated: true,completion: nil)
        } else if checkForExist == true {
            let appDelegat = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegat.persistentContainer.viewContext
            let user = User(context: context)
            user.username = textFieldForUsernameReg.text
            user.password = textFieldForPasswordReg.text
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
                
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func forCheckExistUser() -> Bool {
        var boolean = true
        let name = textFieldForUsernameReg.text
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", name!)
        do {
            let results = try context.fetch(fetchRequest)
            if !(results.isEmpty) {
                boolean = false
                let alert = UIAlertController(title: "Error", message: "User exists", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in }
                alert.addAction(alertAction)
                present(alert,animated: true,completion: nil)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return boolean
    }
    private func stackForTextFieldsReg() {
        stackForTextFieldReg.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackForTextFieldReg)
        NSLayoutConstraint.activate([
            stackForTextFieldReg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackForTextFieldReg.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackForTextFieldReg.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackForTextFieldReg.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    private func constraintForCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
    }
    private func constraintForRegisterButton() {
        view.addSubview(buttonForRegister)
        buttonForRegister.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonForRegister.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttonForRegister.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            buttonForRegister.heightAnchor.constraint(equalToConstant: 60),
            buttonForRegister.topAnchor.constraint(equalTo: stackForTextFieldReg.bottomAnchor, constant: 30),
        ])
    }
}
