//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

// This test file has been translated from swift/test/Parse/multiline_errors.swift

import XCTest

import SwiftSyntax

final class MultilineErrorsTests: XCTestCase {
  func testMultilineErrors1() {
    AssertParse(
      """
      import Swift
      """
    )
  }

  func testMultilineErrors2() {
    AssertParse(
      """
      // ===---------- Multiline --------===
      """
    )
  }

  func testMultilineErrors3() {
    // expecting at least 4 columns of leading indentation
    AssertParse(
      #"""
      _ = """
          Eleven
        1️⃣Mu
          ℹ️"""
      """#,
      diagnostics: [
        DiagnosticSpec(
          message: "insufficient indentation of line in multi-line string literal",
          notes: [NoteSpec(message: "should match indentation here")],
          fixIts: ["change indentation of this line to match closing delimiter"]
        )
      ],
      fixedSource: #"""
        _ = """
            Eleven
            Mu
            """
        """#
    )
  }

  func testMultilineErrors4() {
    // expecting at least 4 columns of leading indentation
    AssertParse(
      #"""
      _ = """
          Eleven
         1️⃣Mu
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Eleven
            Mu
            """
        """#
    )
  }

  func testMultilineErrors5() {
    // \t is not the same as an actual tab for de-indentation
    AssertParse(
      #"""
      _ = """
      	Twelve
      1️⃣\tNu
      	"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
        	Twelve
        	\tNu
        	"""
        """#
    )
  }

  func testMultilineErrors6a() {
    AssertParse(
      #"""
      _ = """
          \(42
      1️⃣)
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            \(42
            )
            """
        """#
    )
  }

  func testMultilineErrors6b() {
    AssertParse(
      #"""
      _ = """
          \(42
       1️⃣)
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            \(42
            )
            """
        """#
    )
  }

  func testMultilineErrors7() {
    AssertParse(
      #"""
      _ = """
          Foo
      1️⃣\
          Bar 
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Foo
            \
            Bar
            """
        """#
    )
  }

  func testMultilineErrors8() {
    // a tab is not the same as multiple spaces for de-indentation
    AssertParse(
      #"""
      _ = """
        Thirteen
      1️⃣	Xi
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected tab in indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
          Thirteen
          Xi
          """
        """#
    )
  }

  func testMultilineErrors9() {
    // a tab is not the same as multiple spaces for de-indentation
    AssertParse(
      #"""
      _ = """
          Fourteen
        1️⃣	Pi
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected tab in indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Fourteen
            Pi
            """
        """#
    )
  }

  func testMultilineErrors10() {
    // multiple spaces are not the same as a tab for de-indentation
    AssertParse(
      #"""
      _ = """
      	Thirteen 2
      1️⃣  Xi 2
      	"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected space in indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
        	Thirteen 2
        	Xi 2
        	"""
        """#
    )
  }

  func testMultilineErrors11() {
    // multiple spaces are not the same as a tab for de-indentation
    AssertParse(
      #"""
      _ = """
      		Fourteen 2
      	1️⃣  Pi 2
      		"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected space in indentation of line in multi-line string literal")
      ]
    )
  }

  func testMultilineErrors12() {
    AssertParse(
      #"""
      _ = """1️⃣Fourteen
          Pi
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal content must begin on a new line", fixIts: ["insert newline"])
      ],
      fixedSource: #"""
        _ = """
            Fourteen
            Pi
            """
        """#
    )
  }

  func testMultilineErrors13() {
    AssertParse(
      #"""
      _ = """
          Fourteen
          Pi1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line")
      ],
      fixedSource: #"""
        _ = """
            Fourteen
            Pi
            """
        """#
    )
  }

  func testMultilineErrors14() {
    AssertParse(
      #"""
      _ = """1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line", fixIts: ["insert newline"])
      ],
      fixedSource: #"""
        _ = """
        """
        """#
    )
  }

  func testMultilineErrors15() {
    AssertParse(
      #"""
      _ = """ 1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line", fixIts: ["insert newline"])
      ],
      fixedSource: #"""
        _ = """
        """
        """#
    )
  }

  func testMultilineErrors16() {
    // two lines should get only one error
    AssertParse(
      #"""
      _ = """
      1️⃣    Hello,
              World!
      	"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "unexpected space in indentation of next 2 lines in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
        	Hello,
        	World!
        	"""
        """#
    )
  }

  func testMultilineErrors17a() {
    AssertParse(
      #"""
      _ = """
      1️⃣Zero A
      Zero B
      	One A
      	One B
      2️⃣  Two A
        Two B
      3️⃣Three A
      Three B
      		Four A
      		Four B
      			Five A
      			Five B
      		"""
      """#,
      diagnostics: [
        // TODO: Old parser expected error on line 2: insufficient indentation of next 2 lines in multi-line string literal
        DiagnosticSpec(locationMarker: "1️⃣", message: "insufficient indentation of next 4 lines in multi-line string literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "unexpected space in indentation of next 2 lines in multi-line string literal"),
        DiagnosticSpec(locationMarker: "3️⃣", message: "insufficient indentation of next 2 lines in multi-line string literal"),
      ],
      fixedSource: #"""
        _ = """
        		Zero A
        		Zero B
        		One A
        		One B
        		Two A
        		Two B
        		Three A
        		Three B
        		Four A
        		Four B
        			Five A
        			Five B
        		"""
        """#
    )
  }

  func testMultilineErrors17b() {
    AssertParse(
      #"""
      _ = """
      1️⃣Zero A\(1)B
      Zero B
            X
          """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of next 2 lines in multi-line string literal")
      ],
      fixedSource: #"""
        _ = """
            Zero A\(1)B
            Zero B
              X
            """
        """#
    )
  }

  func testMultilineErrors17c() {
    AssertParse(
      #"""
      _ = """
      1️⃣Incorrect 1
          Correct
      2️⃣Incorrect 2
          """
      """#,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "insufficient indentation of line in multi-line string literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "insufficient indentation of line in multi-line string literal"),
      ],
      fixedSource: #"""
        _ = """
            Incorrect 1
            Correct
            Incorrect 2
            """
        """#
    )
  }

  func testMultilineErrors18() {
    AssertParse(
      ##"""
      _ = "hello\("""
                  world
                  """1️⃣
                  2️⃣)!"
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "expected ')' in string literal"),
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"extraneous code ')!"' at top level"#),
      ]
    )
  }

  func testMultilineErrors19() {
    AssertParse(
      ##"""
      _ = "h\(1️⃣
                  """
                  world
                  """2️⃣)!"
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "expected value and ')' in string literal"),
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"extraneous code ')!"' at top level"#),
      ]
    )
  }

  func testMultilineErrors20() {
    AssertParse(
      ##"""
      _ = 1️⃣"""
        line one \ non-whitespace
        line two
        """
      """##,
      diagnostics: [
        // TODO: Old parser expected error on line 2: invalid escape sequence in literal
      ]
    )
  }

  func testMultilineErrors21() {
    AssertParse(
      #"""
      _ = """
        line one
        line two\
        """
      """#,
      diagnostics: [
        // TODO: Old parser expected error on line 3: escaped newline at the last line is not allowed, Fix-It replacements: 11 - 12 = ''
      ]
    )
  }

  func testMultilineErrors22() {
    AssertParse(
      #"""
      _ = """
        \\\	   
        """
      """#,
      diagnostics: [
        // TODO: Old parser expected error on line 2: escaped newline at the last line is not allowed, Fix-It replacements: 5 - 10 = ''
      ]
    )
  }

  func testMultilineErrors23() {
    AssertParse(
      #"""
      _ = """
        \(42)\		
        """
      """#,
      diagnostics: [
        // TODO: Old parser expected error on line 2: escaped newline at the last line is not allowed, Fix-It replacements: 8 - 11 = ''
      ]
    )
  }

  func testMultilineErrors24() {
    AssertParse(
      #"""
      _ = """
        foo\
        """
      """#,
      diagnostics: [
        // TODO: Old parser expected error on line 2: escaped newline at the last line is not allowed, Fix-It replacements: 6 - 7 = ''
      ]
    )
  }

  func testMultilineErrors25() {
    AssertParse(
      #"""
      _ = """
        foo\
        """
      """#,
      diagnostics: [
        // TODO: Old parser expected error on line 3: escaped newline at the last line is not allowed, Fix-It replacements: 6 - 7 = ''
      ]
    )
  }

  func testMultilineErrors26() {
    AssertParse(
      ##"""
      _ = """
        foo\1️⃣
      """##,
      diagnostics: [
        DiagnosticSpec(message: #"expected '"""' to end string literal"#)
      ]
    )
  }

  func testMultilineErrors28() {
    AssertParse(
      #"""
      _ = """
      1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
        // TODO: Old parser expected error on line 2: escaped newline at the last line is not allowed, Fix-It replacements: 1 - 2 = ''
      ],
      fixedSource: #"""
        _ = """
          \
          """
        """#
    )
  }

  func testMultilineErrors29() {
    AssertParse(
      #"""
      _ = """1️⃣\
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal content must begin on a new line")
      ],
      fixedSource: #"""
        _ = """
          \
          """
        """#
    )
  }

  func testMultilineErrors30() {
    AssertParse(
      ##"""
      let _ = """
        foo
        \ℹ️("bar1️⃣
        2️⃣baz3️⃣
        """
      """##,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"unexpected code 'baz' in string literal"#),
        DiagnosticSpec(locationMarker: "3️⃣", message: #"expected ')' in string literal"#, notes: [NoteSpec(message: "to match this opening '('")]),
      ],
      fixedSource: ##"""
        let _ = """
          foo
          \("bar"
          baz)
          """
        """##
    )
  }

  func testMultilineErrors31() {
    AssertParse(
      ##"""
      let _ = """
        foo
        \ℹ️("bar1️⃣
        2️⃣baz3️⃣
        """
        abc
      """##,
      substructure: Syntax(IdentifierExprSyntax(identifier: .identifier("abc"))),
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: #"expected '"' to end string literal"#),
        DiagnosticSpec(locationMarker: "2️⃣", message: #"unexpected code 'baz' in string literal"#),
        DiagnosticSpec(locationMarker: "3️⃣", message: #"expected ')' in string literal"#, notes: [NoteSpec(message: "to match this opening '('")]),
      ]
    )
  }

  func testMultilineEndsWithStringInterpolation() {
    AssertParse(
      #"""
      _ = """
      \(1)1️⃣"""
      """#,
      diagnostics: [
        DiagnosticSpec(message: "multi-line string literal closing delimiter must begin on a new line")
      ],
      fixedSource: #"""
        _ = """
        \(1)
        """
        """#
    )
  }

  func testInsufficientIndentationInInterpolation() {
    AssertParse(
      #"""
        """
        \(
      1️⃣1
        )
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of line in multi-line string literal")
      ],
      fixedSource: #"""
          """
          \(
          1
          )
          """
        """#
    )

    AssertParse(
      #"""
        """
        \(
      1️⃣1
        +
      2️⃣2
        )
        """
      """#,
      diagnostics: [
        DiagnosticSpec(locationMarker: "1️⃣", message: "insufficient indentation of line in multi-line string literal"),
        DiagnosticSpec(locationMarker: "2️⃣", message: "insufficient indentation of line in multi-line string literal"),
      ],
      fixedSource: #"""
          """
          \(
          1
          +
          2
          )
          """
        """#
    )

    AssertParse(
      #"""
        """
        \(
      1️⃣1
      +
      2
        )
        """
      """#,
      diagnostics: [
        DiagnosticSpec(message: "insufficient indentation of next 3 lines in multi-line string literal")
      ],
      fixedSource: #"""
          """
          \(
          1
          +
          2
          )
          """
        """#
    )
  }
}
