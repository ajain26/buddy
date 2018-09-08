#if os(Linux)

import XCTest
@testable import AppTests

// sourcery:inline:auto:LinuxMain

extension BuddyConnectTests {
    static var allTests = [
        ("testDummy", testDummy),
    ]
}

XCTMain([
    testCase(BuddyConnectTests.allTests),
])
  
// sourcery:end

#endif
