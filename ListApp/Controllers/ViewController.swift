//
//  ViewController.swift
//  ListApp
//
//  Created by Muhammed Ali SOYLU on 2.05.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    // MARK: - UI Elements

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    @IBOutlet var cancelButtonItem: UIBarButtonItem!

    // MARK: - Properties

    var data = [Any]()
    var artist = [ArtistResults]()
    var count: Int = 0
    var alertController = UIAlertController()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadJsonData()
    }

    // MARK: - Functions
    func loadJsonData() {
        

        AF.request("https://itunes.apple.com/search?media=music&term=bollywood").response { response in

            let json = try? JSONDecoder().decode(Artist.self, from: response.data!)
            self.artist = json!.results!
            print(self.artist.count)
            print(self.artist)
        }
    }
    // MARK: - Actions

    @IBAction func addBarButtonItem(_ sender: Any) {
        // butona kaç kez basıldığını tutuyor
        
        print("Mellon")
        
        DispatchQueue.main.async {
            print("Banana")
            
            DispatchQueue.main.async {
                print("Apple")
            }
        }
        
        print("Avakodo")
        
        
        // Add bar butonuna tıkladığımızda data ekliyor ve yeniliyor
        presentAlert(title: "ADD ITEM", message: nil, defaultButtonTitle: "Yes", cancelButtonTitle: "No", isTextFieldAvailable: true) { [self] _ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                data.append(text!)
                tableView.reloadData()

            } else {
                count = self.count + 1
                data.append(String(self.count))
                presentWarning()
                tableView.reloadData()

            }
        }
        

    }

    @IBAction func cancelButtonItem(_ cancel: Any) {
        presentAlert(title: "SİL", message: "Tüm öğeler silenecek", defaultButtonTitle: "Evet", cancelButtonTitle: "Hayır") { _ in
            self.data.removeAll(keepingCapacity: true)
            self.tableView.reloadData()
        }
    }
}

//MARK: - TABLEVIEW EXTENSION
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let artistData = artist[indexPath.row]
        cell.textLabel?.text = artistData.artistName
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, _ in
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        //deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { _, _, _ in
            self.presentAlert(title: "Elemanı Düzenle", message: self.data[indexPath.row] as? String ,defaultButtonTitle: "OK" ,cancelButtonTitle: "Vazgeç", isTextFieldAvailable: true) { _ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                    self.data[indexPath.row] = text!
                    self.tableView.reloadData()
                }
            }
        }
        
        let config = UISwipeActionsConfiguration(actions: [editAction,deleteAction])
        
        return config
        
    }
    
}

// MARK: PRESENT ALERT
extension ViewController {
    func presentAlert(title: String?,
                      message: String?,
                      preferredStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }

        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel)

        if isTextFieldAvailable {
            alertController.addTextField()
        }

        alertController.addAction(cancelButton)

        present(alertController, animated: true)
    }

    func presentWarning() {
        presentAlert(title: "UYARI", message: "Bir hatayla karşılaştınız", cancelButtonTitle: "Tamam")
    }
}

