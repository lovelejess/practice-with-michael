//
//  StudentInformationViewController.swift
//  OnTheMap
//
//  Created by Jess Le on 3/15/20.
//  Copyright © 2020 lovelejess. All rights reserved.
//

import UIKit
import SafariServices

class StudentInformationViewController: UIViewController {
    let cellReuseIdentifier = "StudentInfoCell"

    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        coordinator?.navigate(to: .logout)
    }
    
    @IBAction func onAddPinButtonPressed(_ sender: Any) {
        coordinator?.navigate(to: .addPin)
    }
    
    @IBAction func onRefreshButtonPressed(_ sender: Any) {
        viewModel?.getStudentData()
    }
    
    @IBOutlet weak var tableView: UITableView!

    var viewModel: StudentInformationViewModel?
    var coordinator: StudentInformationCoordinator?
    weak var delegate: StudentInformationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.getStudentData()
    }
}

extension StudentInformationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let students = viewModel?.students else { return 0 }
        return students.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let students = viewModel?.students else { return UITableViewCell() }
        let cell =  tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)!

        let student = students[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL

        return cell
    }
}

extension StudentInformationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let students = viewModel?.students else { return }
        let student = students[(indexPath as NSIndexPath).row]
        guard let url = URL(string: student.mediaURL) else { return }

        if UIApplication.shared.canOpenURL(url) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        } else {
            let alert = UIAlertController(title: "Error!", message: "Invalid URL provided", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        }

        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension StudentInformationViewController: StudentInformationDelegate {
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func displayError() {
        let alert = UIAlertController(title: "Error!", message: "Unable to retrieve student information. Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
