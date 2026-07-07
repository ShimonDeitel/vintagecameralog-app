import XCTest
@testable import VintageCameraLog

@MainActor
final class VintageCameraLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(CameraItem(name: "Test", model: "A", condition: "B"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let item = CameraItem(name: "ToDelete", model: "A", condition: "B")
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testIsAtFreeLimitTrueAfterFilling() {
        while store.items.count < Store.freeTierLimit {
            store.add(CameraItem(name: "Filler \(store.items.count)", model: "A", condition: "B"))
        }
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testUpdateChangesFields() {
        var item = CameraItem(name: "Orig", model: "A", condition: "B")
        store.add(item)
        item.name = "Changed"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.name, "Changed")
    }

    func testDeleteAtOffsets() {
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testPersistenceRoundTrip() {
        store.add(CameraItem(name: "Persisted", model: "A", condition: "B"))
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.name == "Persisted" }))
    }
}
