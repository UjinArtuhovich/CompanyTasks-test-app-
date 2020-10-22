import UIKit
import CoreData
class NameForDirectorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users:[User] = []
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constrainForTavleView()
        constraintForCancelButton()
    }
    @objc func actionForCancelButton(){
        let ExitToLoginVC = LoginViewController()
        navigationController?.pushViewController(ExitToLoginVC, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegat = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegat.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try context.fetch(fetchRequest)
            users.remove(at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "New Task", message: "Please add new task", preferredStyle: .alert)
        alert.addTextField { _ in }
        let saveaction = UIAlertAction(title: "Save", style: .default) { action in
            let tf = alert.textFields?.first
            if let newtask = tf?.text  {
                if newtask.isEmpty{
                    let ErrorAlert = UIAlertController(title: "Error", message: "add information", preferredStyle: .alert)
                    let Erroraction = UIAlertAction(title: "Ok", style: .default) { _ in }
                    ErrorAlert.addAction(Erroraction)
                    self.present(ErrorAlert, animated: true, completion: nil)
                }
                else{
                    let appDelegat = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegat.persistentContainer.viewContext
                    let task = Tasks(context: context)
                    let user = self.users[indexPath.row]
                    let tasks = user.tasks?.mutableCopy() as? NSMutableOrderedSet
                    task.task = newtask
                    tasks?.add(task)
                    user.tasks = tasks
                    do {
                        try context.save()
                        tableView.reloadData()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        let cancelaction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alert.addAction(saveaction)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Employees"
    }
    
    func constrainForTavleView(){
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
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
}
