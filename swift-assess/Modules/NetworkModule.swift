import Foundation
protocol NMMadeUpdate{
    func syncData(data:UserModel)
}

class NetworkModule {
    
    var username: String = "" //Username from SearchField will be stored here
    var delegate: NMMadeUpdate? //Delegate patterns
    var GitHubEndpoint: String = "https://api.github.com/users/" //API Endpoint URL

    // Single Session has been created to be used for everytime, rather than creating many sessions.
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    //Function to set username
    func setUser(with username: String)->String{
        let newGitHubEndPoint = "\(GitHubEndpoint)\(username)"
        return newGitHubEndPoint
    }

    // function to get data of user
    func getUser(with urlString: String) async throws {
        if let url = URL(string: urlString+"\(username)") {
            print("Network tried to request at, ", urlString)
            let task = NetworkModule.session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                }
                if let receivedObjects = data {
                    if let userData = self.decodeData(from: receivedObjects){
                        // the delegate helps here, as this module can be reused for another application, hence, source view controller will set it self as delegate and receive the data
                        self.delegate?.syncData(data: userData)
                    }
                }
            }
            task.resume()
        }
//        return userModel
    }
    //function to decode the JSON
    func decodeData(from receivedObjects:Data)->UserModel?{
        let decoder = JSONDecoder()
        do{
            let userData = try decoder.decode(UserModel.self, from: receivedObjects)
            print(userData)
            return UserModel(login: userData.login, avatar_url: userData.avatar_url, followers_url: userData.followers_url, following_url: userData.following_url, bio: userData.bio, updated_at: userData.updated_at)
        }catch{
        
           print(NMErrors.couldNotDecode)
            return nil
        }
    }
    
}
