//
//  LoadingController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 10/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import WatchConnectivity
import WatchKit

class LoadingController: WKInterfaceController {

    // MARK: - Properties -

    var posts: [PostData]? {
        didSet {
            DispatchQueue.main.async {
                let pages = Array(1...10).map {
                    "Page\($0)"
                }
                WKInterfaceController.reloadRootControllers(withNames: pages, contexts: self.posts)
            }
        }
    }

    // MARK: - App lifecycle -

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didAppear() {
        super.didAppear()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.getPosts()
        }
    }

    @IBAction private func load() {
        getPosts()
    }

    func getPosts() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["request": "posts"], replyHandler: { response in
                guard let jsonData = response["posts"] as? Data else {
                    return
                }
                do {
                    self.posts = try JSONDecoder().decode([PostData].self, from: jsonData)
                } catch {
                    print(error.localizedDescription)
                }

            }, errorHandler: { error in
                print("Error sending message: %@", error)
            })
        } else {
            print("not reachable")
        }
    }

}

extension LoadingController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
