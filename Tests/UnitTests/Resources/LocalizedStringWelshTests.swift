// swiftlint:disable line_length

@testable import OneLogin
import XCTest

final class LocalizedStringWelshTests: XCTestCase {
    func test_genericKeys() {
        XCTAssertEqual("app_closeButton".getWelshString(),
                  "Cau")
        XCTAssertEqual("app_tryAgainButton".getWelshString(),
                  "Rhowch gynnig arall")
        XCTAssertEqual("app_continueButton".getWelshString(),
                  "Parhau")
        XCTAssertEqual("app_enablePasscodeButton".getWelshString(),
                  "Defnyddio god mynediad")
    }
    
    func test_signInScreenKeys() {
        XCTAssertEqual("app_signInTitle".getWelshString(),
                       "GOV.UK One Login")
        XCTAssertEqual("app_signInBody".getWelshString(),
                       "Mewngofnodwch gyda'r cyfeiriad e-bost rydych yn ei ddefnyddio ar gyfer eich GOV.UK One Login.")
        XCTAssertEqual("app_signInButton".getWelshString(),
                       "Mewngofnodi")
    }
    
    func test_unableToLoginErrorScreenKeys() {
        XCTAssertEqual("app_signInErrorTitle".getWelshString(),
                       "Roedd problem wrth eich mewngofnodi")
        XCTAssertEqual("app_signInErrorBody".getWelshString(),
                       "Gallwch geisio mewngofnodi eto.\n\nOs na fydd hyn yn gweithio, efallai y bydd angen i chi roi cynnig arall yn nes ymlaen.")
    }
    
    func test_networkConnectionErrorScreenKeys() {
        XCTAssertEqual("app_networkErrorTitle".getWelshString(),
                       "Mae'n ymddangos nad ydych ar-lein")
        XCTAssertEqual("app_networkErrorBody".getWelshString(),
                       "Nid yw GOV.UK One Login ar gael os nad ydych ar-lein. Ailgysylltwch â'r rhyngrwyd a rhoi cynnig arall.")
    }
    
    func test_genericErrorScreenKeys() {
        XCTAssertEqual("app_somethingWentWrongErrorTitle".getWelshString(),
                       "Aeth rhywbeth o'i le")
        XCTAssertEqual("app_somethingWentWrongErrorBody".getWelshString(),
                       "Rhowch gynnig arall yn nes ymlaen.")
    }
    
    func test_passcodeInformationScreenKeys() {
        XCTAssertEqual("app_noPasscodeSetupTitle".getWelshString(),
                       "Mae'n edrych fel nad oes gan y ffôn hwn god mynediad")
        XCTAssertEqual("app_noPasscodeSetupBody".getWelshString(),
                       "Mae gosod cod mynediad ar eich ffôn yn ychwanegu mwy o ddiogelwch. Yna gallwch fewngofnodi i'r ap y ffordd hyn yn hytrach na gyda'ch cyfeiriad e-bost a'ch cyfrinair.\n\nGallwch osod cod mynediad yn nes ymlaen trwy fynd i'ch gosodiadau ffôn.")
    }
    
    func test_faceIDEnrollmentScreenKeys() {
        XCTAssertEqual("app_enableFaceIDTitle".getWelshString(),
                       "Defnyddiwch ID Wyneb i fewngofnodi")
        XCTAssertEqual("app_enableFaceIDBody".getWelshString(),
                       "Ychwanegwch haen o ddiogelwch a mewngofnodi gyda'ch wyneb neu olion bysedd yn hytrach na'ch cyfeiriad e-bost a chyfrinair. Nid yw eich biometreg yn cael ei rannu â GOV.UK One Login.\n\nOs nad ydych am ddefnyddio biometreg, gallwch fewngofnodi gyda'ch cod mynediad neu batrwm ffôn yn lle hynny.")
        XCTAssertEqual("app_enableFaceIDFootnote".getWelshString(),
                       "Os ydych yn defnyddio ID Wyneb, bydd unrhyw un sydd â ID Wyneb wedi'i arbed ar eich ffôn yn gallu mewngofnodi i'r ap hwn.")
        XCTAssertEqual("app_enableFaceIDButton".getWelshString(),
                       "Defnyddip ID Wyneb")
    }
    
    func test_touchIDEnrollmentScreenKeys() {
        XCTAssertEqual("app_enableTouchIDTitle".getWelshString(),
                       "Defnyddiwch ID Cyffwrdd i fewngofnodi")
        XCTAssertEqual("app_enableTouchIDBody".getWelshString(),
                       "Ychwanegwch haen o ddiogelwch a mewngofnodi gyda'ch wyneb yn hytrach na'ch cyfeiriad e-bost a cyfrinair. Nid yw eich ID Cyffwrdd yn cael ei rannu â GOV.UK One Login.\n\nOs nad ydych am ddefnyddio ID Cyffwrdd, gallwch fewngofnodi gyda'ch cod mynediad eich ffôn yn lle hynny.")
        XCTAssertEqual("app_enableTouchIDFootnote".getWelshString(),
                       "Os ydych yn defnyddio ID Cyffwrdd, bydd unrhyw un sydd â ID Cyffwrdd wedi'i arbed ar eich ffôn yn gallu mewngofnodi i'r ap hwn.")
        XCTAssertEqual("app_enableTouchIDEnableButton".getWelshString(),
                       "Defnyddio ID Cyffwrdd")
    }
}

// swiftlint:enable line_length
