import Foundation
protocol NMMadeUpdate{
    func syncData(data:UserModel)
}

class NetworkModule {
    
    var username: String = ""
    var delegate: NMMadeUpdate?
    var GitHubEndpoint: String = "https://api.github.com/users/"

    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    func setUser(with username: String)->String{
        let newGitHubEndPoint = "\(GitHubEndpoint)\(username)"
        return newGitHubEndPoint
    }

    func getUser(with urlString: String) async throws {
        if let url = URL(string: urlString+"\(username)") {
            print("Network tried to request at, ", urlString)
            let task = NetworkModule.session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                }
                if let receivedObjects = data {
                    if let userData = self.decodeData(from: receivedObjects){
                        self.delegate?.syncData(data: userData)
                    }
                }
            }
            task.resume()
        }
//        return userModel
    }
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
