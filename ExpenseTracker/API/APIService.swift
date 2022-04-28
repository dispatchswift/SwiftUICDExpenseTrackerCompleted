//
//  APIService.swift
//  ExpenseTracker
//
//  Copyright © 2022. Amari Duran. All rights reserved.
//

import Foundation

enum APIError: Error {
	case badData
	case badResponse
	case error(String?)
}

protocol APIServiceProtocol {
	func updateCurrency(amount: Double,
											toCurrency: String,
											fromCurrency: String,
											completionHandler: @escaping (Result<UpdateCurrencyResponseModel, APIError>) -> Void)
	
	func updateCurrency(amount: Double,
											toCurrency: String,
											fromCurrency: String) async throws -> UpdateCurrencyResponseModel
}

final class APIService: APIServiceProtocol {
	static let url = URL(string: "https://elementsofdesign.api.stdlib.com/aavia-currency-converter@dev/")!
	
	@available(*, deprecated, message: "Prefer async alternative instead.")
	func updateCurrency(amount: Double,
											toCurrency: String,
											fromCurrency: String,
											completionHandler: @escaping (Result<UpdateCurrencyResponseModel, APIError>) -> Void) {
		var urlRequest = URLRequest(url: APIService.url)
		urlRequest.httpMethod = "POST"
		urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		do {
			let postModel = UpdateCurrencyPostModel(amount: amount, toCurrency: toCurrency, fromCurrency: fromCurrency)
			
			let encoder = JSONEncoder()
			encoder.keyEncodingStrategy = .convertToSnakeCase
			
			urlRequest.httpBody = try encoder.encode(postModel)
		} catch {
			completionHandler(.failure(.error(error.localizedDescription)))
		}

		URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			if let error = error {
				completionHandler(.failure(.error(error.localizedDescription)))
				return
			}
			
			guard let httpResponse = (response as? HTTPURLResponse),
						(200...299).contains(httpResponse.statusCode) else {
				completionHandler(.failure(.badResponse))
				return
			}
			
			guard let data = data else {
				completionHandler(.failure(.badData))
				return
			}
	
			do {
				let responseModel = try JSONDecoder().decode(UpdateCurrencyResponseModel.self, from: data)
				
				DispatchQueue.main.async {
					completionHandler(.success(responseModel))
				}
			} catch {
				completionHandler(.failure(.error(error.localizedDescription)))
			}
		}
		.resume()
	}
	
	func updateCurrency(amount: Double,
											toCurrency: String,
											fromCurrency: String) async throws -> UpdateCurrencyResponseModel {
		return try await withCheckedThrowingContinuation { continuation in
			updateCurrency(
				amount: amount,
				toCurrency: toCurrency,
				fromCurrency: fromCurrency
			) { result in
				continuation.resume(with: result)
			}
		}
	}
}
