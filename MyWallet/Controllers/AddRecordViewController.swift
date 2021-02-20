//
//  AddRecordViewController.swift
//  MyWallet
//
//  Created by nang saw on 18/02/2021.
//

import UIKit
import CoreData

class AddRecordViewController: UIViewController {
    
    @IBOutlet weak var directionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    
    var container: NSPersistentContainer!
    var categoryPicker: UIPickerView!
    var accountPicker: UIPickerView!
    var expenseCategoriesList: [Categories] = []
    var incomeCategoriesList: [Categories] = []
    var currentUid = ""
    var model: AddRecordModel = Facade.share.model.addRecordModel
    var record: Records!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.amount = 0
        model.datetime = Date()
        model.uid = nil
        
        setupCategoriesList()
        
        guard expenseCategoriesList.count > 0 else {
            self.errorAlertView(title: "Error", message: "You should have at least one expense category. Go to Settings > Categories and add an 'Expense' category.")
            return
        }
        
        guard incomeCategoriesList.count > 0 else {
            self.errorAlertView(title: "Error", message: "You should have at least one income category. Go to Settings > Categories and add an 'Income' category.")
            return
        }
        
        if model.incomeIndex >= incomeCategoriesList.count {
            model.incomeIndex = 0
        }
        
        if model.expenseIndex >= expenseCategoriesList.count {
            model.expenseIndex = 0
        }
        
        if let record = Facade.share.model.getRecord(uid: currentUid) {
            self.record = record
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            
            amountTextField.text = String("\(formatter.string(from: NSNumber(value: record.amount))!)")
            if record.direction == 1 {
                model.direction = 1
                
                for (index, cat) in incomeCategoriesList.enumerated()
                where cat.uid == record.relatedCategory?.uid {
                    model.incomeIndex = index
                    break
                }
            } else {
                model.direction = 0
                
                for (index, cat) in expenseCategoriesList.enumerated()
                where cat.uid == record.relatedCategory?.uid {
                    model.expenseIndex = index
                    break
                }
            }
            model.datetime = record.datetime ?? Date()
            model.uid = record.uid
        } else {
            
        }
        
        // datePicker
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateTextField.text = formatter.string(from: model.datetime)
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = model.datetime
        datePicker.backgroundColor = UIColor.white
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        dateTextField.delegate = self
        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = UIColor.black
        toolBar2.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done",
                                          style: UIBarButtonItem.Style.plain,
                                          target: self,
                                          action: #selector(AddRecordViewController.donePicker))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                           target: nil,
                                           action: nil)
        toolBar2.setItems([spaceButton2, spaceButton2, doneButton2], animated: false)
        toolBar2.isUserInteractionEnabled = true
        dateTextField.inputAccessoryView = toolBar2
        
        let frame = self.view.frame
        
        // categoryPicker config
        let catFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 216)
        categoryPicker = UIPickerView(frame: catFrame)
        categoryPicker.backgroundColor = UIColor.white
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryTextField.inputView = categoryPicker
        categoryTextField.delegate = self
        
        // directionField config
        directionSegmentedControl.addTarget(self, action: #selector(directionChanged(_:)), for: .valueChanged)
        directionSegmentedControl.selectedSegmentIndex = model.direction
        
        if directionSegmentedControl.selectedSegmentIndex == 0 {
            categoryTextField.text = (expenseCategoriesList.count > 0) ? expenseCategoriesList[model.expenseIndex].name : ""
            categoryPicker.selectRow(model.expenseIndex, inComponent: 0, animated: false)
            //            }
            prefixLabel.text = "-" + NSLocale.defaultCurrency
            prefixLabel.textColor = UIColor.myAppBlack
        } else {
            categoryTextField.text = (incomeCategoriesList.count > 0) ? incomeCategoriesList[model.incomeIndex].name : ""
            categoryPicker.selectRow(model.incomeIndex, inComponent: 0, animated: false)
            //            }
            prefixLabel.text = "+" + NSLocale.defaultCurrency
            prefixLabel.textColor = UIColor.myAppGreen
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(AddRecordViewController.donePicker))
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolBar
        
        // accountPicker config
        let accFrame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 216)
        accountPicker = UIPickerView(frame: accFrame)
        accountPicker.dataSource = self
        accountPicker.delegate = self
        
        amountTextField.becomeFirstResponder()
    }
    
    public func setupCategoriesList() {
        do {
            let fetchRequest: NSFetchRequest<Categories> = Categories.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "direction == %d", 1)
            let sort = NSSortDescriptor(key: "sortId", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            incomeCategoriesList = try Facade.share.model.container.viewContext.fetch(fetchRequest)

            fetchRequest.predicate = NSPredicate(format: "direction == %d", -1)
            fetchRequest.sortDescriptors = [sort]
            expenseCategoriesList = try Facade.share.model.container.viewContext.fetch(fetchRequest)
        } catch {
            print ("fetch task failed", error)
        }
    }
    
    @IBAction func tappedSubmirButton(_ sender: Any) {
        // validation
        guard amountTextField.text != "" && amountTextField.text != "0" else {
            errorAlertView(title: "Error", message: "You should enter the amount")
            return
        }
        model.amount = amountTextField.text!.getDoubleFromLocal()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let date = formatter.date(from: dateTextField.text!) {
            model.datetime = date
        }

        if model.uid == "" || model.uid == nil {
            // new record
            record = Records(context: Facade.share.model.container.viewContext)
            record.uid = Facade.share.model.getNewUID()
        }

        if model.direction == 0 {
            record.relatedCategory = expenseCategoriesList[model.expenseIndex]
            record.direction = -1
        } else {
            record.relatedCategory = incomeCategoriesList[model.incomeIndex]
            record.direction = 1
        }

        record.amount = amountTextField.text!.getDoubleFromLocal()

        record.datetime = model.datetime

        Facade.share.model.saveContext()

        navigationController?.popViewController(animated: true)
    }
    
    @objc func donePicker() {
        amountTextField.becomeFirstResponder()
    }

    @objc func directionChanged(_ sender: UISegmentedControl) {
        model.direction = directionSegmentedControl.selectedSegmentIndex
        categoryPicker.reloadAllComponents()

        if directionSegmentedControl.selectedSegmentIndex == 0 {
            categoryTextField.text = expenseCategoriesList[model.expenseIndex].name
            prefixLabel.text = "-" + NSLocale.defaultCurrency
            prefixLabel.textColor = UIColor.myAppBlack

            categoryPicker.selectRow(model.expenseIndex, inComponent: 0, animated: false)
        } else {
            categoryTextField.text = incomeCategoriesList[model.incomeIndex].name
            prefixLabel.text = "+" + NSLocale.defaultCurrency
            prefixLabel.textColor = UIColor.myAppGreen

            categoryPicker.selectRow(model.incomeIndex, inComponent: 0, animated: false)
        }
    }
}

extension AddRecordViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker {
            if directionSegmentedControl.selectedSegmentIndex == 0 {
                return expenseCategoriesList.count
            } else {
                return incomeCategoriesList.count
            }
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker {
            if directionSegmentedControl.selectedSegmentIndex == 0 {
                return expenseCategoriesList[row].name
            } else {
                return incomeCategoriesList[row].name
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker {
            model.direction = directionSegmentedControl.selectedSegmentIndex
            if model.direction == 0 {
                model.expenseIndex = row
                categoryTextField.text = expenseCategoriesList[row].name
            } else {
                model.incomeIndex = row
                categoryTextField.text = incomeCategoriesList[row].name
            }
        }
    }

    @objc public func datePickerValueChanged(sender: UIDatePicker) {

        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        model.datetime = sender.date.dateOnly()

        dateTextField.text = dateFormatter.string(from: model.datetime)
    }
}

extension AddRecordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField is PickerBasedTextField {
            let textField2 = textField as! PickerBasedTextField
            textField2.border.borderColor = UIColor.myAppBlue.cgColor
            textField2.textColor = UIColor.myAppBlue
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField is PickerBasedTextField {
            let textField2 = textField as! PickerBasedTextField
            textField2.border.borderColor = UIColor.black.cgColor
            textField2.textColor = UIColor.black
        }
    }
}
