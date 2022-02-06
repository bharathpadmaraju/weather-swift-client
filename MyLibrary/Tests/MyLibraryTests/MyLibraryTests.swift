import XCTest
import MyLibrary

final class MyLibraryTests: XCTestCase {
    
    func testHello() throws {
        // Given

        let myLibrary = MyLibrary()
        let expectation = XCTestExpectation(description: "We asked about the hello and heard back 🎄")
        var isHello: Bool?

        // When
        myLibrary.isHello(completion: { lucky in
            isHello = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isHello)
        XCTAssert(isHello == true)
    }
    
    
    
    
    func testIsLuckyBecauseWeAlreadyHaveLuckyNumber() throws {
        // Given

        let myLibrary = MyLibrary()
        let number = 2
        let expectation = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsLuckyBecauseWeatherHasAnEight() throws {
        // Given

        let myLibrary = MyLibrary()
        let number = 0
        let expectation = XCTestExpectation(description: "We asked about the number 8 and heard back 🎄")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == true)
    }

    func testIsNotLucky() throws {
        // Given

        let myLibrary = MyLibrary()
        let number = 7
        let expectation = XCTestExpectation(description: "We asked about the number 7 and heard back 🌲")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNotNil(isLuckyNumber)
        XCTAssert(isLuckyNumber == false)
    }

    func testIsNotLuckyBecauseServiceCallFails() throws {
        // Given

        let myLibrary = MyLibrary()
        let number = 7
        let expectation = XCTestExpectation(description: "We asked about the number 7 but the service call failed 🤖💩")
        var isLuckyNumber: Bool?

        // When
        myLibrary.isLucky(number, completion: { lucky in
            isLuckyNumber = lucky
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertNil(isLuckyNumber)
    }

}
