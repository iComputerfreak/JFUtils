//
//  JFUtils.swift
//
//
//  Created by Jonas Frey on 10.12.21.
//

import Foundation

public struct JFUtils {
    
    /// Convenience function to execute a HTTP GET request.
    /// Ignores errors and just passes nil to the completion handler, if the request failed.
    /// - Parameters:
    ///   - urlString: The URL string of the request
    ///   - parameters: The parameters for the request
    ///   - completion: The closure to execute on completion of the request
    static func getRequest(_ urlString: String, parameters: [String: Any?], completion: @escaping (Data?) -> Void) {
        getRequest(urlString, parameters: parameters) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unknown error")
                completion(nil)
                return
            }
            
            // Check for http errors
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                print("headerFields = \(String(describing: response.allHeaderFields))")
                print("data = \(String(data: data, encoding: .utf8) ?? "nil")")
                completion(nil)
                return
            }
            
            completion(data)
        }
    }
    
    /// Executes a HTTP GET request
    /// - Parameters:
    ///   - urlString: The URL string of the request
    ///   - parameters: The parameters for the request
    ///   - completion: The closure to execute on completion of the request
    static func getRequest(_ urlString: String, parameters: [String: Any?], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var urlStringWithParameters = "\(urlString)"
        // We should only append the '?', if we really have parameters
        if !parameters.isEmpty {
            urlStringWithParameters += "?\(parameters.percentEscaped())"
        }
        var request = URLRequest(url: URL(string: urlStringWithParameters)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Making GET Request to \(urlStringWithParameters)")
        #if DEBUG
        // In Debug mode, always load the URL, never use the cache
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        #endif
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    /// The URL describing the documents directory of the app
    static var documentsPath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    /// Returns an URL describing the directory with the given name in the documents directory and creates it, if neccessary
    /// - Parameter directory: The name of the folder in the documents directory
    static func url(for directory: String) -> URL {
        let url = documentsPath.appendingPathComponent(directory)
        // Create the directory, if it not already exists
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print("Error creating folder in documents directory: \(error)")
        }
        return url
    }
    
    // TODO: Overhaul, maybe use the corresponding ISOFormatter()
    /// An ISO8601 time string representing the current date and time. Safe to use in filenames
    /// - Parameter withTime: Whether to include the time
    /// - Returns: The date (and possibly time) string
    @available(macOS 10.12, *)
    static func isoDateString(withTime: Bool = false) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withDashSeparatorInDate, .withFullDate]
        if withTime {
            formatter.formatOptions.formUnion([.withFullTime, .withTimeZone])
        }
        return formatter.string(from: Date())
    }
}

#if canImport(UIKit)

import UIKit

public extension JFUtils {
    /// Returns either black or white, depending on the color scheme
    /// - Parameter colorScheme: The current color scheme environment variable
    static func primaryUIColor(_ colorScheme: ColorScheme) -> UIColor {
        return colorScheme == .light ? .black : .white
    }
    
    static func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        DispatchQueue.main.async {
            guard let source = UIApplication.shared.windows.last?.rootViewController else {
                return
            }
            let vc = UIActivityViewController(
                activityItems: items,
                applicationActivities: nil
            )
            vc.excludedActivityTypes = excludedActivityTypes
            vc.popoverPresentationController?.sourceView = source.view
            source.present(vc, animated: true)
        }
    }
}

#endif
