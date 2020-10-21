//
//  PencilViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/10/21.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit
import PencilKit

class PencilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let canvas = PKCanvasView(frame: view.frame)
        view.addSubview(canvas)
        canvas.tool = PKInkingTool(.pen, color: .black, width: 30)
        
        // PKToolPicker: ドラッグして移動できるツールパレット (ペンや色などを選択できるツール)
        if let window = UIApplication.shared.windows.first {
            if let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.addObserver(canvas)
                toolPicker.setVisible(true, forFirstResponder: canvas)
                canvas.becomeFirstResponder()
            }
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
