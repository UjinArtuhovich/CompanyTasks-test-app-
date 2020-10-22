import UIKit
import CoreData
let textFieldForUsername: UITextField = {
    let tf = UITextField()
    tf.backgroundColor = .white
    tf.textColor = .black
    tf.borderStyle = .roundedRect
    tf.placeholder = " username"
    tf.font = UIFont(name: "Helvetica-Light", size: 20)
    tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return tf
}()
let textFieldForPassword: UITextField = {
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
let stackForTextField: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [textFieldForUsername, textFieldForPassword])
    stack.axis  = .vertical
    stack.distribution  = .fillEqually
    stack.spacing   = 30.0
    return stack
}()
let mainLabel: UILabel = {
    let label = UILabel()
    label.text = "CTasks"
    label.font = UIFont(name: "Helvetica-Light", size: 50)
    return label
}()
class LoginViewController: UIViewController{
    let buttonForLogin: UIButton = {
        let bttn = UIButton()
        bttn.backgroundColor =  UIColor.lightGray.withAlphaComponent(0.3)
        bttn.setTitle("Login", for: .normal)
        bttn.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 20)
        bttn.setTitleColor(.black, for: .normal)
        bttn.layer.cornerRadius = 10
        bttn.addTarget(self, action: #selector(actionForButtonForLogin), for: .touchUpInside)
        return bttn
    }()
    let buttonForRegister: UIButton = {
        let bttn = UIButton()
        bttn.setTitle("Registrstion", for: .normal)
        bttn.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 20)
        bttn.setTitleColor(.black, for: .normal)
        bttn.addTarget(self, action: #selector(actionForButtonForRegister), for: .touchUpInside)
        return bttn
    }()
    override func viewDidLoad() {

        //                let appDelegat = UIApplication.shared.delegate as! AppDelegate
        //                let context = appDelegat.persistentContainer.viewContext
        //                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        //                if let users = try? context.fetch(fetchRequest) {
        //                    for user in users {
        //                        context.delete(user)
        //                    }
        //                }
        
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        giveDataToDirector()
        stackForTextFields()
        constraintForLoginButton()
        constraintForRegisterButton()
        constraintForMainLabel()
    }
    
    @objc func actionForButtonForLogin() {
        checkTextField()
        textFieldForPassword.text?.removeAll()
        textFieldForUsername.text?.removeAll()
        
    }
    @objc func actionForButtonForRegister() {
        textFieldForPassword.text?.removeAll()
        textFieldForUsername.text?.removeAll()
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true, completion: nil)
    }
    private func checkTextField(){
        if textFieldForUsername.text!.isEmpty  || textFieldForPassword.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Fill in login and password", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in }
            alert.addAction(alertAction)
            present(alert,animated: true,completion: nil)
        } else {
            checkNameandPassword()
        }
    }
    private func checkNameandPassword() {
        let username = textFieldForUsername.text
        let password = textFieldForPassword.text
        let user: User!
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username!)
        do {
            let results = try context.fetch(fetchRequest)
            user = results.first
            if results.isEmpty || password != user.password  {
                let alert = UIAlertController(title: "Error", message: "Incorrect login or password", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in }
                alert.addAction(alertAction)
                present(alert,animated: true,completion: nil)
            } else if user.username == "Director" && user.password == "11111111"  {
                let NameForHeadVC = NameForDirectorViewController()
                navigationController?.pushViewController(NameForHeadVC, animated: false)
            } else {
                let TasksForEmplVC = PageOfEmployeeViewController()
                navigationController?.pushViewController(TasksForEmplVC, animated: false)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    private func giveDataToDirector() {
        let login = "Director"
        let password = "11111111"
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let fetchrequest: NSFetchRequest<User> = User.fetchRequest()
        fetchrequest.predicate = NSPredicate(format: "username == %@", login)
        let director: User!
        do {
            let results = try context.fetch(fetchrequest)
            if results.isEmpty {
                director = User(context:context)
                director.username = login
                director.password = password
                try context.save()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func stackForTextFields() {
        stackForTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackForTextField)
        NSLayoutConstraint.activate([
            stackForTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackForTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackForTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackForTextField.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    private func constraintForLoginButton() {
        view.addSubview(buttonForLogin)
        buttonForLogin.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonForLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            buttonForLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            buttonForLogin.heightAnchor.constraint(equalToConstant: 60),
            buttonForLogin.topAnchor.constraint(equalTo: stackForTextField.bottomAnchor, constant: 30),
        ])
    }
    private func constraintForRegisterButton() {
        view.addSubview(buttonForRegister)
        buttonForRegister.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonForRegister.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            buttonForRegister.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            buttonForRegister.topAnchor.constraint(equalTo: buttonForLogin.bottomAnchor, constant: 20),
        ])
    }
    private func constraintForMainLabel() {
        view.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.bottomAnchor.constraint(equalTo: stackForTextField.topAnchor, constant: -100),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
