import UIKit
import CoreData
var user: User!

class  PageOfEmployeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let username = textFieldForUsername.text
    let tableView : UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    let cancelButton: UIButton = {
        let bttn = UIButton(type: .close)
        bttn.addTarget(self, action: #selector(actionForCancelButton), for: .touchUpInside)
        return bttn
    }()
    var ForImageProfile: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let imagePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change image", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Light", size: 10)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(ImagePickerButtonAction), for: .touchUpInside)
        return button
    }()
    let LabelForUserName: UILabel = {
        let label = UILabel()
        label.text = textFieldForUsername.text
        label.font = UIFont(name: "Helvetica-Light", size: 20)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constrainForTavleView()
        constraintForCancelButton()
        constraintForLabelProfile()
        constraintForUsernameLabel()
        constraintForChangeImageButton()
        ImageAppear()
        
    }
    @objc func ImagePickerButtonAction(){
        showImagePicker()
    }
    @objc func actionForCancelButton(){
        let ExitToLoginVC = LoginViewController()
        navigationController?.pushViewController(ExitToLoginVC, animated: false)
    }
    func ImageAppear() {
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username!)
        do {
            let results = try context.fetch(fetchRequest)
            user = results.first
            if user.image == nil  {
                ForImageProfile.image = UIImage(named: "forImage")
            } else {
                ForImageProfile.image = UIImage(data: user.image!)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func constrainForTavleView(){
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func constraintForCancelButton(){
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    func constraintForLabelProfile(){
        ForImageProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ForImageProfile)
        NSLayoutConstraint.activate([
            ForImageProfile.widthAnchor.constraint(equalToConstant: 150),
            ForImageProfile.heightAnchor.constraint(equalToConstant: 150),
            ForImageProfile.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -30),
            ForImageProfile.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        ForImageProfile.layer.masksToBounds = true
        ForImageProfile.layer.cornerRadius = 75
    }
    func constraintForUsernameLabel() {
        view.addSubview(LabelForUserName)
        LabelForUserName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            LabelForUserName.bottomAnchor.constraint(equalTo: ForImageProfile.topAnchor, constant: -10),
            LabelForUserName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    func constraintForChangeImageButton() {
        imagePickerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imagePickerButton)
        NSLayoutConstraint.activate([
            imagePickerButton.topAnchor.constraint(equalTo: ForImageProfile.bottomAnchor, constant: 5),
            imagePickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int!
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username!)
        do{
            let result = try context.fetch(fetchRequest)
            user = result.first
            count = user?.tasks?.count
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        guard  let task = user.tasks?[indexPath.row] as? Tasks,
               let tasksname = task.task as String? else { return cell }
        cell.textLabel!.text = tasksname
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Your tasks"
    }
}
extension PageOfEmployeeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let ip = UIImagePickerController()
        ip.delegate = self
        ip.allowsEditing = true
        ip.sourceType = .photoLibrary
        ip.modalPresentationStyle = .fullScreen
        present(ip, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            ForImageProfile.image = editedImage
            
        }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ForImageProfile.image = originalImage
        }
        saveImageCoreData()
    }
    func saveImageCoreData() {
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let image = ForImageProfile.image
        let imageData = image!.pngData()
        user.image = imageData
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
