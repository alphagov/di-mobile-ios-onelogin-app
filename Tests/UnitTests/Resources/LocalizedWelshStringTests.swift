// swiftlint:disable line_length

import XCTest

final class LocalizedWelshStringTests: XCTestCase {
    func test_generic_keys() throws {
        XCTAssertEqual("app_closeButton".getWelshString(),
                       "Cau")
        XCTAssertEqual("app_cancelButton".getWelshString(),
                       "Canslo")
        XCTAssertEqual("app_tryAgainButton".getWelshString(),
                       "Rhowch gynnig arall")
        XCTAssertEqual("app_continueButton".getWelshString(),
                       "Parhau")
        XCTAssertEqual("app_agreeButton".getWelshString(),
                       "Cytuno")
        XCTAssertEqual("app_disagreeButton".getWelshString(),
                       "Anghytuno")
        XCTAssertEqual("app_loadingBody".getWelshString(),
                       "Llwytho")
        XCTAssertEqual("app_skipButton".getWelshString(),
                       "Osgoi")
        XCTAssertEqual("app_enterPasscodeButton".getWelshString(),
                       "Rhowch god mynediad")
        XCTAssertEqual("app_exitButton".getWelshString(),
                       "Gadael")
    }
    
    func test_localAuthPrompt_keys() throws {
        XCTAssertEqual("app_faceId_subtitle".getWelshString(),
                       "Rhowch god mynediad iPhone")
        XCTAssertEqual("app_touchId_subtitle".getWelshString(),
                       "Datgloi i barhau")
    }
    
    func test_signInScreen_keys() throws {
        XCTAssertEqual("app_signInTitle".getWelshString(),
                       "GOV.UK One Login")
        XCTAssertEqual("app_signInBody".getWelshString(),
                       "Mewngofnodwch gyda'r cyfeiriad e-bost rydych yn ei ddefnyddio ar gyfer eich GOV.UK One Login.")
        XCTAssertEqual("app_signInButton".getWelshString(),
                       "Mewngofnodi")
        XCTAssertEqual("app_extendedSignInButton".getWelshString(),
                       "Mewngofnodi gyda GOV.UK One Login")
    }
    
    func test_analyticsScreen_keys() throws {
        XCTAssertEqual("app_acceptAnalyticsPreferences_title".getWelshString(),
                       "Helpu i wella'r ap drwy rannu dadansoddi")
        XCTAssertEqual("acceptAnalyticsPreferences_body".getWelshString(),
                       "Gallwch helpu'r tîm GOV.UK One Login i wneud gwelliannau drwy rannu dadansoddeg am sut rydych yn defnyddio'r ap.\n\nGallwch stopio rhannu'r dadansoddeg hyn ar unrhyw amser. Ewch i osodiadau eich ffôn a dewiswch yr ap GOV.UK One Login i weld neu newid eich gosodiadau ap.\n\nGallwch stopio rhannu'r dadansoddiadau hyn ar unrhyw bryd trwy newid gosodiadau eich ap.")
        XCTAssertEqual("app_privacyNoticeLink".getWelshString(), "Darllenwch fwy am hyn yn hysbysiad preifatrwydd GOV.UK One Login")
    }
    
    func test_unableToLoginErrorScreen_keys() throws {
        XCTAssertEqual("app_signInErrorTitle".getWelshString(),
                       "Roedd problem wrth eich mewngofnodi")
        XCTAssertEqual("app_signInErrorBody".getWelshString(),
                       "Gallwch geisio mewngofnodi eto.\n\nOs na fydd hyn yn gweithio, efallai y bydd angen i chi roi cynnig arall yn nes ymlaen.")
    }
    
    func test_networkConnectionErrorScreen_keys() throws {
        XCTAssertEqual("app_networkErrorTitle".getWelshString(),
                       "Mae'n ymddangos nad ydych ar-lein")
        XCTAssertEqual("app_networkErrorBody".getWelshString(),
                       "Nid yw GOV.UK One Login ar gael os nad ydych ar-lein. Ailgysylltwch â'r rhyngrwyd a rhoi cynnig arall.")
    }
    
    func test_genericErrorScreen_keys() throws {
        XCTAssertEqual("app_somethingWentWrongErrorTitle".getWelshString(),
                       "Aeth rhywbeth o'i le")
        XCTAssertEqual("app_somethingWentWrongErrorBody".getWelshString(),
                       "Rhowch gynnig arall yn nes ymlaen.")
    }
    
    func test_faceIDEnrolmentScreen_keys() throws {
        XCTAssertEqual("app_enableFaceIDTitle".getWelshString(),
                       "Datgloi'r ap gyda Face ID")
        XCTAssertEqual("app_enableFaceIDBody".getWelshString(),
                       "Gallwch ddefnyddio Face ID i ddatgloi'r ap o fewn 30 munud o fewngofnodi gyda GOV.UK One Login.\n\nOs ydych yn caniatáu Face ID, bydd unrhyw un sy'n gallu datgloi eich ffôn gyda'u gwyneb neu gyda chod eich ffôn yn gallu cael mynediad i'ch ap.")
        XCTAssertEqual("app_enableFaceIDButton".getWelshString(),
                       "Caniatáu Face ID")
    }
    
    func test_touchIDEnrolmentScreen_keys() throws {
        XCTAssertEqual("app_enableTouchIDTitle".getWelshString(),
                       "Datgloi'r ap gyda Touch ID")
        XCTAssertEqual("app_enableTouchIDBody".getWelshString(),
                       "Gallwch ddefnyddio eich olion bysedd i ddatgloi'r ap o fewn 30 munud o fewngofnodi gyda GOV.UK One Login.\n\nOs ydych yn caniatáu Touch ID, bydd unrhyw un sy'n gallu datgloi eich ffôn gyda'u olion bysedd neu gyda chod eich ffôn yn gallu cael mynediad i'ch ap.")
        XCTAssertEqual("app_enableTouchIDEnableButton".getWelshString(),
                       "Caniatáu Touch ID")
    }
    
    func test_unlockScreenKeys() {
        XCTAssertEqual("app_unlockButton".getWelshString(),
                       "Datgloi")
    }
    
    func test_homeScreenKeys() {
        XCTAssertEqual("app_homeTitle".getWelshString(),
                       "Hafan")
        XCTAssertEqual("app_displayEmail".getWelshString(),
                       "Rydych wedi mewngofnodi fel\n%@")
    }
    
    func test_walletScreenKeys() {
        XCTAssertEqual("app_walletTitle".getWelshString(),
                       "Waled")
    }
    
    func test_settingsScreenKeys() {
        XCTAssertEqual("app_settingsTitle".getWelshString(),
                       "Gosodiadau")
        XCTAssertEqual("app_settingsSignInDetailsTile".getWelshString(),
                       "Eich GOV.UK One Login")
        XCTAssertEqual("app_settingsSignInDetailsLink".getWelshString(),
                       "Rheoli eich manylion mewngofnodi")
        XCTAssertEqual("app_settingsSignInDetailsFootnote".getWelshString(),
                       "Efallai y bydd angen i chi fewngofnodi eto i reoli eich manylion GOV.UK One Login.")
        XCTAssertEqual("app_privacyNoticeLink2".getWelshString(),
                       "Rhybudd Preifatrwydd GOV.UK One Login")
        XCTAssertEqual("app_settingsSubtitle1".getWelshString(),
                       "Help ac adborth")
        XCTAssertEqual("app_contactLink".getWelshString(),
                       "Cysylltu GOV.UK One Login")
        XCTAssertEqual("app_appGuidanceLink".getWelshString(),
                       "Defnyddio'r ap GOV.UK One Login")
        XCTAssertEqual("app_signOutButton".getWelshString(),
                       "Allgofnodi")
        XCTAssertEqual("app_settingsSubtitle2".getWelshString(),
                       "Am yr ap")
        XCTAssertEqual("app_settingsAnalyticsToggle".getWelshString(),
                       "Rhannu dadansoddeg yr ap")
        XCTAssertEqual("app_settingsAnalyticsToggleFootnote".getWelshString(),
                       "Gallwch rannu dadansoddeg anhysbys am sut rydych yn defnyddio'r ap i helpu'r tîm GOV.UK One Login i wneud gwelliannau. Darllenwch fwy yn yr hysbysiad preifatrwydd")
        XCTAssertEqual("app_accessibilityStatement".getWelshString(),
                       "Datganiad hygyrchedd")
    }
    
    func test_signOutPageKeys() {
        XCTAssertEqual("app_signOutConfirmationTitle".getWelshString(),
                       "Ydych chi'n siwr eich bod chi eisiau allgofnodi?")
        XCTAssertEqual("app_signOutConfirmationBody1".getWelshString(),
                       "Os byddwch yn allgofnodi, bydd y wybodaeth a gedwir yn eich ap yn cael ei dileu. Mae hyn er mwyn lleihau'r risg y bydd rhywun arall yn gweld eich gwybodaeth.")
        XCTAssertEqual("app_signOutConfirmationBody2".getWelshString(),
                       "Mae hyn yn golygu:")
        XCTAssertEqual("app_signOutConfirmationBullet1".getWelshString(),
                       "bydd unrhyw ddogfennau a arbedir yn eich GOV.UK Wallet yn cael eu dileu")
        XCTAssertEqual("app_signOutConfirmationBullet2".getWelshString(),
                       "os ydych yn defnyddio Face ID neu Touch ID i ddatgloi'r ap, bydd hyn yn cael ei ddiffodd")
        XCTAssertEqual("app_signOutConfirmationBullet3".getWelshString(),
                       "byddwch yn stopio rhannu dadansoddeg am sut rydych yn defnyddio'r ap")
        XCTAssertEqual("app_signOutConfirmationBody3".getWelshString(),
                       "Y tro nesaf y byddwch yn mewngofnodi, gallwch ychwanegu eich dogfennau at eich GOV.UK Wallet a gosod eich dewisiadau eto.")
        XCTAssertEqual("app_signOutAndDeleteAppDataButton".getWelshString(),
                       "Mewngofnodi a dileu gwybodaeth")
    }
    
    func test_signOutErrorPageKeys() {
        XCTAssertEqual("app_signOutErrorTitle".getWelshString(),
                       "Roedd problem wrth eich allgofnodi")
        XCTAssertEqual("app_signOutErrorBody".getWelshString(),
                       "Gallwch orfodi allgofnodi trwy ddileu'r ap o'ch dyfais.")
    }
    
    func test_signOutWarningPageKeys() {
        XCTAssertEqual("app_signOutWarningTitle".getWelshString(),
                       "Mae angen i chi fewngofnodi eto")
        XCTAssertEqual("app_signOutWarningBody".getWelshString(),
                       "Mae mwy na 30 munud wedi mynd heibio ers i chi fewngofnodi ddiwethaf i ap GOV.UK  One Login.\n\nMewngofnodwch eto i barhau.")
    }
    
    func test_dataDeletedWarningPageKeys() {
        XCTAssertEqual("app_dataDeletionWarningTitle".getWelshString(),
                       "Mae rhywbeth wedi mynd o'i le")
        
        XCTAssertEqual("app_dataDeletionWarningBody".getWelshString(),
                       "Ni allem gadarnhau eich manylion mewngofnodi.\n\nEr mwyn cadw'ch gwybodaeth yn ddiogel, mae unrhyw ddogfennau yn eich GOV.UK Wallet wedi'u dileu ac mae eich dewisiadau ap wedi'u hailosod.\n\nMae angen i chi fewngofnodi eto a gosod eich dewisiadau eto i barhau i ddefnyddio'r ap. Yna byddwch yn gallu ychwanegu dogfennau at eich GOV.UK  Wallet.")
        
        XCTAssertEqual("app_dataDeletionWarningBodyNoWallet".getWelshString(),
                       "Nid oeddem yn gallu cadarnhau eich manylion mewngofnodi.\n\nEr mwyn cadw'ch gwybodaeth yn ddiogel, mae eich dewis o ddefnyddio Touch ID neu Face ID i ddatgloi'r ap wedi'i ailosod.\n\nMae angen i chi fewngofnodi a gosod eich dewisiadau eto i barhau i ddefnyddio'r ap.")
    }

    func test_updateAppPageKeys() {
        XCTAssertEqual("app_updateAppTitle".getWelshString(),
                       "Mae angen i chi ddiweddaru eich ap")
        XCTAssertEqual("app_updateAppBody".getWelshString(),
                       "Rydych yn defnyddio hen fersiwn o'r ap GOV.UK One Login.\n\nDiweddarwch eich ap i barhau.")
        XCTAssertEqual("app_updateAppButton".getWelshString(),
                       "Diweddaru Ap GOV.UK One Login")
    }
    
    func test_oneLoginTile() {
            XCTAssertEqual("app_oneLoginCardTitle".getWelshString(),
                           "Using your GOV.UK One Login")
            XCTAssertEqual("app_oneLoginCardBody".getWelshString(),
                           "Sign in to your GOV.UK One Login and read about the services you can use with it.")
            XCTAssertEqual("app_oneLoginCardLink".getWelshString(),
                           "Go to the GOV.UK website")
        }
    
    func test_appUnavailablePageKeys() {
        XCTAssertEqual("app_appUnavailableTitle".getWelshString(),
                       "Mae'n ddrwg gennym, nid yw'r ap ar gael")
        XCTAssertEqual("app_appUnavailableBody".getWelshString(),
                       "Ni allwch ddefnyddio'r ap GOV.UK One Login ar hyn o bryd.\n\nRhowch gynnig arall yn nes ymlaen.")
    }
}

// swiftlint:enable line_length
