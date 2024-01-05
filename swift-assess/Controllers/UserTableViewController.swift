//User Table View Controller
import UIKit

class UserTableViewController: UITableViewController, NMMadeUpdate {
    var username: String = ""
    let networkPoint = NetworkModule()
    var userDetails: [String: String] = [
        "login": "",
        "imageURL": "",
        "followersCount": "",
        "followingCount": "",
        "bio": "",
        "updatedAt": ""
    ]
    
    let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkPoint.delegate = self
        navigationItem.hidesBackButton = true; //comment this to use navigation, as it has single screen to show result, it has been hidden.
        // NetworkModule Class networkpoint sets user
        let url = networkPoint.setUser(with: username)
        
        // NetworkModule Class networkpoint gets user using "Task" as our function is asyn and viewDidLoad is not async function, hence require explicit implementation.
        Task {
            do {
                let user = try await networkPoint.getUser(with: url)
            } catch NMErrors.noInternet {
                print("No Internet")
            } catch {
                print("Unexpected Errors")
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDetail", for: indexPath)

        let keys = Array(userDetails.keys)
        let key = keys[indexPath.row]
        let value = userDetails[key]

        // For other details, set text labels
        cell.textLabel?.text = "\(value ?? "")"

        // Making follower and following counts clickable
        if key == "followersCount" || key == "followingCount" {
            cell.textLabel?.textColor = .blue
            cell.textLabel?.underline()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }

        return cell
    }

    func syncData(data: UserModel) {
        userDetails["login"] = data.login
        userDetails["imageURL"] = data.avatar_url
        userDetails["followersCount"] = data.followers_url
        userDetails["followingCount"] = data.following_url
        userDetails["updatedAt"] = data.updated_at
        userDetails["bio"] = data.bio
        
        // Set the image view in the table header
        if let imageURLString = userDetails["imageURL"], let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.headerImageView.image = image
                        self.tableView.tableHeaderView = self.headerImageView
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }
}

// Extension to underline the text in a label
extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
}
