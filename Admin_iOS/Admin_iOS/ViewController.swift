//
//  ViewController.swift
//  Admin_iOS
//
//  Created by LxT on 2017/11/20.
//  Copyright © 2017年 LxT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var _phoneNumber:String?
    var _password:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loading.stopAnimating()
        loading.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTouch(_ sender: UIButton) {
        
        _phoneNumber = phoneNumber.text
        _password = password.text
        
        if vertifyPhoneNumber(phoneNumber: _phoneNumber!) {
            print("phoneNumber is ok")
            setTextfiledSuccess(textfield: phoneNumber)
            phoneNumber.resignFirstResponder()
        } else {
            print("phoneNumber is invalide")
            setTextfieldAlert(textfield: phoneNumber)
            phoneNumber.becomeFirstResponder()
            showMessage(message: "请输入有效的手机号码")
            return
        }
        
        if vertifyPassword(password: _password!) {
            print("password is ok")
            setTextfiledSuccess(textfield: password)
            password.resignFirstResponder()
        } else {
            print("password is invalide")
            setTextfieldAlert(textfield: password)
            password.becomeFirstResponder()
            showMessage(message: "请输入您的密码")
            return
        }
        
        loading.startAnimating()
        
        let url = URL(string : "http://182.92.239.180/fangtian_ol_new/admin.php/Index/teacherLoginOk.html")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let login:String = "phone=\(String(describing: _phoneNumber!))&pwd=\(String(describing: _password!))"
        print(login)
        let data:Data = login.data(using: .utf8, allowLossyConversion: true)!
        request.httpBody = data
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data, reponse, error) -> Void in
            if error != nil{
                print(error.debugDescription)
            }else{
                //                let str = String(data: data!, encoding: String.Encoding.utf8) {
                //                    print(str)
                //                }
                // print("data: " + String(describing: data))
                do {
                    let dic:NSObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSObject
                    print(dic)
                    let status:Int = dic.value(forKey: "status") as! Int
                    DispatchQueue.main.async {
                        self.loading.stopAnimating()
                    }
                    
                    if status == 1 {
                        
                    } else {
                        print("账号或密码错误")
                        DispatchQueue.main.async {
                            self.showMessage(message: "账号或密码错误")
                            self.password.becomeFirstResponder()
                            self.setTextfieldAlert(textfield: self.password)
                        }
                    }
                } catch let error {
                    print("error: " + error.localizedDescription)
                    self.showMessage(message: "解析数据出错！")
                }
            }
        })
        
        dataTask.resume()
        
        
    }
    
    func vertifyPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber == "" {
            return false
        }
        if phoneNumber.count != 11  {
            return false
        }
        
        return true
    }
    
    func vertifyPassword(password:String) -> Bool {
        if password == "" {
            return false
        }
        if password.count < 6 {
            return false
        }
        
        return true
    }
    
    func setTextfieldAlert(textfield:UITextField) {
        textfield.layer.borderColor = UIColor.red.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.masksToBounds = true
        textfield.layer.cornerRadius = 5.0
    }
    
    func setTextfiledSuccess(textfield:UITextField) {
        textfield.layer.borderColor = UIColor.green.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.layer.masksToBounds = true
        textfield.layer.cornerRadius = 5.0
    }
    
    func showMessage(message:String) {
        messageLabel.alpha = 1.0
        messageLabel.text = message
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationDelay(2.0)
        messageLabel.alpha = 0.0
        
        UIView.commitAnimations()
        
    }
    
}

