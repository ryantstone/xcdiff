//
// Copyright 2019 Bloomberg Finance L.P.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
@testable import XCDiffCore
import XCTest

final class MarkdownRendererTests: XCTestCase {
    private var subject: MarkdownRenderer!
    private var outputBuffer: StringOutputBuffer!

    override func setUp() {
        super.setUp()

        outputBuffer = StringOutputBuffer()
        subject = MarkdownRenderer(output: outputBuffer.any())
    }

    func testText() {
        // When
        subject.text("1")
        subject.text("2")
        subject.text("3")

        // Then
        XCTAssertEqual(content, "1\n2\n3\n")
    }

    func testList_whenEmpty() {
        // When
        subject.list {}

        // Then
        XCTAssertEqual(content, "\n")
    }

    func testList_whenItems() {
        // When
        subject.list {
            subject.item("b1.1")
            subject.item {
                subject.pre("b1.2")
                subject.list {
                    subject.item("b1.2.1")
                }
            }
            subject.item {
                subject.pre("b2.2")
                subject.list {
                    subject.item("b2.2.1")
                }
            }
        }

        // Then
        XCTAssertEqual(content, """
          - `b1.1`
          - `b1.2`
            - `b1.2.1`

          - `b2.2`
            - `b2.2.1`\n\n\n
        """)
    }

    func testLine() {
        // When
        subject.line(3)

        // Then
        XCTAssertEqual(content, "\n\n\n")
    }

    func testHeader_whenH1() {
        // When
        subject.header("H1", .h1)

        // Then
        XCTAssertEqual(content, """
        \n# H1\n\n
        """)
    }

    func testHeader_whenH2() {
        // When
        subject.header("H2", .h2)

        // Then
        XCTAssertEqual(content, """
        \n## H2\n\n
        """)
    }

    func testHeader_whenH3() {
        // When
        subject.header("H3", .h3)

        // Then
        XCTAssertEqual(content, """
        \n### H3\n\n
        """)
    }

    func testSample1() {
        // When
        subject.header("Header", .h3)
        subject.list {
            subject.item {
                subject.pre("Different Values 1")
                subject.list {
                    subject.item("Value1")
                    subject.item("Value2")
                }
            }
            subject.item {
                subject.pre("Different Values 2")
                subject.list {
                    subject.item("Value1")
                    subject.item("Value2")
                }
            }
        }
        subject.header("Header 2", .h3)
        subject.list {
            subject.item("Test")
        }

        // Then
        XCTAssertEqual(content, """

        ### Header

          - `Different Values 1`
            - `Value1`
            - `Value2`

          - `Different Values 2`
            - `Value1`
            - `Value2`



        ### Header 2

          - `Test`


        """)
    }

    // MARK: - Private

    private var content: String {
        return outputBuffer.flush()
    }
}
