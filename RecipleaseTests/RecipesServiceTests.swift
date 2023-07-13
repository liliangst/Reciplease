//
//  RecipesServiceTests.swift
//  RecipleaseTests
//
//  Created by Lilian Grasset on 05/07/2023.
//

import XCTest
@testable import Reciplease
import Alamofire

final class RecipleaseTests: XCTestCase {

    func testFetchRecipesWithErrorShouldFail() {
        let path = "/test/FetchRecipesWithErrorShouldFail"
        let service = RecipesService(session: URLFakeSessionBuilder.make(), url: path)
        
        MockURLProtocol.mockURLs[path] = (data: nil, response: nil, error: RecipesFakeResponseData.error)
        
        let expectation = XCTestExpectation()
        service.fetchRecipes(with: ["chicken"]) { result in
            switch result {
            case .success(_):
                XCTFail("Error this test should fail")
            case .failure(let error as AFError):
                XCTAssertTrue(error.isSessionTaskError)
            default:
                XCTFail("Error: This test should return a different error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchRecipesWithNoDataShouldFail() {
        let path = "/test/FetchRecipesWithNoDataShouldFail"
        let service = RecipesService(session: URLFakeSessionBuilder.make(), url: path)
        
        MockURLProtocol.mockURLs[path] = (data: nil, response: nil, error: nil)
        
        let expectation = XCTestExpectation()
        service.fetchRecipes(with: ["chicken"]) { result in
            switch result {
            case .success(_):
                XCTFail("Error this test should fail")
            case .failure(let error as AFError):
                XCTAssertTrue(error.isResponseSerializationError)
                if case .responseSerializationFailed(reason: .inputDataNilOrZeroLength) = error {} else {
                    XCTFail("Wrong AFError reason")
                }
            default:
                XCTFail("Error: This test should return a different error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchRecipesWithWrongResponseShouldFail() {
        let path = "/test/FetchRecipesWithWrongResponseShouldFail"
        let service = RecipesService(session: URLFakeSessionBuilder.make(), url: path)
        
        MockURLProtocol.mockURLs[path] = (data: RecipesFakeResponseData.recipesCorrectData, response: RecipesFakeResponseData.responseNotOk, error: nil)
        
        let expectation = XCTestExpectation()
        service.fetchRecipes(with: ["chicken"]) { result in
            switch result {
            case .success(_):
                XCTFail("Error this test should fail")
            case .failure(let error as AFError):
                XCTAssertTrue(error.isResponseValidationError)
            default:
                XCTFail("Error: This test should return a different error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }

    func testFetchRecipesWithIncorrectDataShouldFail() {
        let path = "/test/FetchRecipesWithIncorrectDataShouldFail"
        let service = RecipesService(session: URLFakeSessionBuilder.make(), url: path)
        
        MockURLProtocol.mockURLs[path] = (data: RecipesFakeResponseData.recipesIncorrectData, response: RecipesFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation()
        service.fetchRecipes(with: ["chicken"]) { result in
            switch result {
            case .success(_):
                XCTFail("Error this test should fail")
            case .failure(let error as AFError):
                XCTAssertTrue(error.isResponseSerializationError)
                if case .responseSerializationFailed(reason: .decodingFailed(_)) = error {} else {
                    XCTFail("Wrong AFError reason")
                }
            default:
                XCTFail("Error: This test should return a different error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
    
    func testFetchRecipesShouldSuccess() {
        let path = "/test/FetchRecipesShouldSuccess"
        let service = RecipesService(session: URLFakeSessionBuilder.make(), url: path)
        
        MockURLProtocol.mockURLs[path] = (data: RecipesFakeResponseData.recipesCorrectData, response: RecipesFakeResponseData.responseOk, error: nil)
        
        let expectation = XCTestExpectation()
        service.fetchRecipes(with: ["chicken"]) { result in
            switch result {
            case .success(let recipes):
                XCTAssertEqual(recipes[0].label, "Quince Cheese")
            case .failure(let error):
                XCTFail("Error this test should success: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation])
    }
}
