/* AddEditEmojiTableViewController.swift
   EmojiDictionary
   Creates a dictionary of emojis, allowing the user to add, remove, or edit items.
   Created by Nour Yehia on 8/16/18.
   Copyright © 2018 Nour Yehia. All rights reserved.*/

import UIKit

class AddEditEmojiTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Declare variables. These will hold a value if user is editing an emoji.
    var emoji: Emoji?
    var category: Int?
    
    // Define the categories.
    let categories = ["Smileys & People", "Animals", "Food", "Activities", "Objects", "Hearts", "Flags"]
    
    // To be used to show/hide the category picker when needed.
    let categoryPickerIndexPath = IndexPath(row: 1, section: 4)
    var showCategoryPicker = false {
        didSet {
            categoryPicker.isHidden = !showCategoryPicker
        }
    }
    
    // Declare outlets.
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Update whether user can save or not as the user types.
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Called once the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load data if editing emoji.
        updateView()
        // Set up category picker.
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        if let category = category {
            categoryPicker.selectRow(category, inComponent: 0, animated: false)
        }
        // Enable or disable save button.
        updateSaveButtonState()
        // Update category label.
        updateCategoryLabel()
    }
    
    // Defines the height of the rows.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
            case (categoryPickerIndexPath.section, categoryPickerIndexPath.row):
                if showCategoryPicker {
                    return 180.0
                }
                else {
                    return 0.0
                }
            default: return 44.0
        }
    }
    
    // Hides/Shows category picker when appropriate cell is tapped and updates label.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCategoryLabel()
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == [categoryPickerIndexPath.section, categoryPickerIndexPath.row-1]{
            if showCategoryPicker {
                showCategoryPicker = false
            }
            else {
                showCategoryPicker = true
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // Updates the category label based on picked category.
    func updateCategoryLabel(){
            categoryLabel.text = categories[categoryPicker.selectedRow(inComponent: 0)]
    }
    
    // Prepares for segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        // If all the information is valid, pass it on to the next view controller.
        let symbol = symbolTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let usage = usageTextField.text ?? ""
        emoji = Emoji(symbol: symbol, name: name, description: description, usage: usage)
        category = categoryPicker.selectedRow(inComponent: 0)
    }
    
    // Updates the cells with emoji information if user is editing.
    func updateView(){
        guard let emoji = emoji else {return}
        symbolTextField.text = emoji.symbol
        nameTextField.text = emoji.name
        descriptionTextField.text = emoji.description
        usageTextField.text = emoji.usage
        tableView.reloadData()
    }
    
    // Prevents user to save emoji if not enough info is given.
    func updateSaveButtonState() {
        let symbolText = symbolTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""
        let usageText = usageTextField.text ?? ""
        saveButton.isEnabled = !symbolText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty && !usageText.isEmpty
    }
    
    // Determines the number of components in picker view.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Determines the number of rows in picker view based on number of categories.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // Makes each row in picker view hold the title of a category.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
