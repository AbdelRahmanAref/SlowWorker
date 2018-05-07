//
//  ViewController.swift
//  SlowWorker
//
//  Created by AbdelRahman Aref on 5/7/18.
//  Copyright © 2018 AbdelRahman Aref. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resutltsTextView: UITextView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    func fetchSomethingFromServer() -> String {
        Thread.sleep(forTimeInterval: 1)
        return "Hi There"
    }
    func processData(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 2)
        return data.uppercased()
    }
    func calculateFirstResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 3)
        return "Number of chars: \(data.count)"
    }
    func calculateSecondResult(_ data: String) -> String {
        Thread.sleep(forTimeInterval: 4)
        return data.replacingOccurrences(of: "E", with: "e")
    }
    
    @IBAction func doWork(_ sender: Any) {
        let startTime = Date()
        self.resutltsTextView.text = ""
        startButton.isEnabled = false
        spinner.startAnimating()
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchedData)
            var firstResult : String!
            var secondResult : String!
            let group = DispatchGroup()
            let group2 = DispatchGroup()
            queue.async(group : group) {
                secondResult = self.calculateSecondResult(processedData)
            }
            queue.async(group: group2){
                firstResult = self.calculateFirstResult(processedData)

            }
            group.notify(queue: queue){
              let resultsSummary = "First: [\(firstResult!)]\nSecond: [\(secondResult!)]"
            DispatchQueue.main.async {
                self.resutltsTextView.text = resultsSummary
                self.startButton.isEnabled = true
                self.spinner.stopAnimating()
            }
            let endTime = NSDate()
            print("completed in \(endTime.timeIntervalSince(startTime as Date)) seconds")
        }
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }



}

