//
//  ViewController.swift
//  Clima
//
//  Created by João Victor Ipirajá de Alencar on 28/12/20.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var imgviewCondition: UIImageView!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var txtSearch: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self //txtSearch will notify the View controller
        
    }
    
    @IBAction func searchClicked(_ sender: Any) {
        txtSearch.endEditing(true) //dimiss the keyboard
        print(txtSearch.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text!)
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Try Something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //
        textField.text = ""
        textField.placeholder = "Search"
        
    }


}

