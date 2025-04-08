//
//  LanguageSelectionViewController.swift
//  Color Wheel
//
//  Created by A-Avramenko on 12.08.2024.
//

import UIKit

class LanguageSelectionViewController: UITableViewController {

    let languages = ["Українська", "Polski", "English", "Français"]
    var selectedLanguage: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Language"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LanguageCell")
        
        // Завантаження обраної мови
        selectedLanguage = UserDefaults.standard.string(forKey: "SelectedLanguage") ?? "English"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language

        // Встановлення галочки для обраної мови
        if language == selectedLanguage {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = languages[indexPath.row]

        // Збереження вибору в UserDefaults
        UserDefaults.standard.setValue(selectedLanguage, forKey: "SelectedLanguage")

        // Оновлення таблиці
        tableView.reloadData()

        // Можна додати логіку для зміни мови в додатку
    }
}
