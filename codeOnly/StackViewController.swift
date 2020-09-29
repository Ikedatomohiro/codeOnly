//
//  StackViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/09/26.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {

    let stackView = UIStackView()
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()
    let testSwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown

        setLabels()
        
        view.addSubview(testSwitch)
        testSwitch.frame.origin = CGPoint(x: 100, y:100)
                
        // The second UISwitch is turned on by default.
        testSwitch.setOn(true, animated: true)
        
        // Register a function to process second UISwitch's value changed event.
        testSwitch.addTarget(self, action: #selector(turnSecondSwitch), for: UIControl.Event.valueChanged)
        
        // Add the second UISwitch to the screen root view.
        self.view.addSubview(testSwitch)
    }
    
    func setLabels() {
        view.addSubview(stackView)
//        stackView.distribution = .fillEqually
//        stackView.alignment = .fill
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil
                         , bottom: nil, trailing: nil, padding: .init(top: 80, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 150))
        
        view.addSubview(label1)
        label1.textColor = UIColor.lightGray
        label1.text = "スタックビュー"
        label1.frame.size.width = 100
        label1.frame.size.height = 30
        stackView.addArrangedSubview(label1)

        view.addSubview(label2)
        label2.textColor = UIColor.lightGray
        label2.text = "スタックビュー2"
        label2.frame.size.width = 100
        label2.frame.size.height = 30
        stackView.addArrangedSubview(label2)

        view.addSubview(label3)
        label3.textColor = UIColor.lightGray
        label3.text = "スタックビュー3"
        label3.frame.size.width = 100
        label3.frame.size.height = 30
        stackView.addArrangedSubview(label3)
        
    }
    
    @objc func turnSecondSwitch(srcObj: UISwitch){
        
        // Get second UISwitch current status.
        let switchStatus:Bool = srcObj.isOn
        
        // Change the label text and first UISwitch status accordingly.
        if(switchStatus){
            label1.text = "Second switch is turned on"
            
            testSwitch.setOn(false, animated: true)
        }else{
            label1.text = "Second switch is turned off"
            
            testSwitch.setOn(true, animated: true)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
