//
//  AddCategoryViewController.swift
//  MyWallet
//
//  Created by nang saw on 19/02/2021.
//

import UIKit
import FontAwesome_swift

class AddCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryNameInput: UITextField!
    @IBOutlet weak var categoryTypeInput: UISegmentedControl!
    @IBOutlet weak var iconView: UIImageView!
    var currentUid = ""
    var category: Categories!
    
    var currentIcon: FontAwesome? {
        didSet {
            guard let currentIcon = currentIcon else { return }
            self.iconView?.image = UIImage.SWFontIcon(name: currentIcon)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCategoryIcon()
        setupIconViewRecognizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if category.uid == "" {
            Facade.share.model.container.viewContext.delete(category)
            Facade.share.model.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let iconSelectorVC = segue.destination as? IconSelectorViewController else { return }
        iconSelectorVC.delegate = self
        iconSelectorVC.selectedFont = currentIcon
    }
    
    func setupIconViewRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            iconView.isUserInteractionEnabled = true
            iconView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.performSegue(withIdentifier: "iconSelectorBoard", sender: self)
    }
    
    func setupCategoryIcon() {
        iconView.layer.borderWidth = 1
        iconView.layer.borderColor = UIColor.lightGray.cgColor
        category = Facade.share.model.getOrCreateCategory(uid: currentUid)
        var defaultDirection = UserDefaults.standard.integer(forKey: "DirectionInAddCategories")
        if category.uid == "" {
            // default initialisation for new category
            self.currentIcon = FontAwesome.stream
        } else {
            // manipulate fields with current object data
            self.currentIcon = FontAwesome(rawValue: category.icon ?? "")
            categoryNameInput.text = category.name
            if category.direction == 1 {
                defaultDirection = 1
            } else {
                defaultDirection = 0
            }
        }
        categoryTypeInput.selectedSegmentIndex = defaultDirection
    }
    
    @IBAction func tappedSubmitButton(_ sender: Any) {
        guard categoryNameInput.text != "" else {
            let alert = UIAlertController(title: "Error", message: "You should enter the name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if category.uid == "" {
            category.uid = Facade.share.model.getNewUID()
        }
        
        if categoryTypeInput.selectedSegmentIndex == 0 {
            category.direction = -1
        } else {
            category.direction = 1
        }
        category.name = categoryNameInput.text!
        category.icon = currentIcon?.rawValue ?? ""
        
        Facade.share.model.saveContext()
        
        category.sortId = category.getAutoIncremenet()
        Facade.share.model.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddCategoryViewController: IconSelectorDelegate {
    func iconSelected(icon: FontAwesome?) {
        self.currentIcon = icon
    }
}

enum CategoryType {
    case categoryTypeCost
    case categoryTypeIncome
    case categoryTypeAll
}
