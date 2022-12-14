import XCTest
@testable import HorizontalTileGrid
final class HorizontalTileGridTests: XCTestCase {
	func testStandardSquareShouldBeAbleToContainFourMinimumSquareSize() {
		let blocks: [HorizontalTileGrid.BlockType] = [.double, .double]
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		let cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)

		XCTAssertEqual(cache.standardSquare.width, cache.minimumSquare.width * 2)
		XCTAssertEqual(cache.standardSquare.height, cache.minimumSquare.height * 2)
	}

	// MARK: Double
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTheNumberOfTilesIsLessOrEqual4Double() {
		var blocks: [HorizontalTileGrid.BlockType] = [.double, .double, .double]
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let sizeToContain3DoubleColumn = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(sizeToContain3DoubleColumn, .init(width:  cache.standardSquare.width + cache.minimumSquare.width, height: cache.standardSquare.height))

		blocks = [.double, .double, .double, .double]
		let sizeToContain4DoubleColumn = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(sizeToContain4DoubleColumn, .init(width:  cache.standardSquare.width * 2, height: cache.standardSquare.height))

		blocks = [.double, .double]
		let sizeToContain2DoubleColumn = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(sizeToContain2DoubleColumn, cache.standardSquare)

		blocks = [.double]
		let sizeToContain1DoubleColumn = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(sizeToContain1DoubleColumn, .init(width: cache.minimumSquare.width, height: cache.standardSquare.height))
	}

	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTheNumberOfTilesIsOdd() {
		let blocks: [HorizontalTileGrid.BlockType] = [.double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double]
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(size, .init(width: cache.minimumSquare.width * CGFloat(blocks.count), height: cache.standardSquare.height))
	}

	func test_shouldCalculateSizeOfTheContainerCorrectly_whenTheNumberOfTilesIsEvenButNotDevidableBy4() {
		let blocks: [HorizontalTileGrid.BlockType] = [.double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double, .double]
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(size, .init(width: cache.minimumSquare.width * CGFloat(blocks.count), height: cache.standardSquare.height))
	}

	// MARK: StandardSize
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenblocksContainsOnlySingleStandard() {
		let blocks: [HorizontalTileGrid.BlockType] = [.block, .block, .block, .block, .block, .block, .block, .block, .block, .block, .block, .block]
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(size, .init(width: cache.standardSquare.width * CGFloat(blocks.count), height: cache.standardSquare.height))
	}

	// MARK: CustomWidth
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenblocksContainsOnlyFullWidth() {
		let tileWidth: [CGFloat] = [200,125,100,230,423,5343]
		let blocks: [HorizontalTileGrid.BlockType] = tileWidth.map({.blockCustom(width: $0)})
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(size, .init(width: tileWidth.reduce(0, +), height: cache.standardSquare.height))
	}

	// MARK: Mix of tiles
	func test_shouldCalculateSizeOfTheContainerCorrectly_whenblocksContainsMixOfTiles() {
		let blocks: [HorizontalTileGrid.BlockType] = [.blockCustom(width: 100), .block, .block, .double, .double, .double, .block, .blockCustom(width: 430),.blockCustom(width: 540), .double, .double, .block,.double, .block, .double, .double, .double, .double,]
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		XCTAssertEqual(size, .init(width: 3070.0, height: cache.standardSquare.height))
	}

	// MARK: Place items
	func test_shouldPlaceTheItemsCorrectly_whenOnlyCustomWithItemsInside() {
		let tileWidth: [CGFloat] = [200,125,100,230,423,5343]
		let blocks: [HorizontalTileGrid.BlockType] = tileWidth.map({.blockCustom(width: $0)})
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), blocks: blocks, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: tileWidth[0].half, y: containerPosition.midY), size: .init(width: tileWidth[0], height: size.height)))
		XCTAssertEqual(places[1], .init(origin: .init(x: tileWidth[0] + tileWidth[1].half, y: containerPosition.midY), size: .init(width: tileWidth[1], height: size.height)))
		XCTAssertEqual(places[2], .init(origin: .init(x: tileWidth[0] + tileWidth[1] + tileWidth[2].half, y: containerPosition.midY), size: .init(width: tileWidth[2], height: size.height)))
		XCTAssertEqual(places[3], .init(origin: .init(x: tileWidth[0] + tileWidth[1] + tileWidth[2] + tileWidth[3].half, y: containerPosition.midY), size: .init(width: tileWidth[3], height: size.height)))
	}

	func test_shouldPlaceTheItemsCorrectly_whenOnlySquareItemsInside() {
		let tileWidth: [CGFloat] = [200,200,200,200,200]
		let blocks: [HorizontalTileGrid.BlockType] = tileWidth.map({_ in .block})
		let sut = HorizontalTileGrid(blocks: blocks)
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), blocks: blocks, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[1], .init(origin: .init(x: cache.standardSquare.width + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[2], .init(origin: .init(x: (cache.standardSquare.width * 2) + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
		XCTAssertEqual(places[3], .init(origin: .init(x: (cache.standardSquare.width * 3) + cache.standardSquare.width.half, y: containerPosition.midY), size: cache.standardSquare))
	}

	func test_shouldPlaceTheItemsCorrectly_whenOnlyDoubleItemsInside() {
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		let tileWidth: [CGFloat] = [minimumSquare.width,minimumSquare.width, minimumSquare.width, minimumSquare.width, minimumSquare.width, minimumSquare.width, minimumSquare.width]
		let blocks: [HorizontalTileGrid.BlockType] = tileWidth.map({_ in .double})
		let sut = HorizontalTileGrid(blocks: blocks)

		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), blocks: blocks, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[1], .init(origin: .init(x: cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[2], .init(origin: .init(x: cache.minimumSquare.width + cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[3], .init(origin: .init(x: cache.minimumSquare.width + cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[4], .init(origin: .init(x: (cache.minimumSquare.width * 2) + cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[5], .init(origin: .init(x: (cache.minimumSquare.width * 2) + cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[6], .init(origin: .init(x: (cache.minimumSquare.width * 3) + cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
	}

	func test_shouldPlaceTheItemsCorrectly_whenAMixOfTileItemsInside() {
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		let tileWidth: [CGFloat] = [minimumSquare.width, minimumSquare.width]
		let blocks: [HorizontalTileGrid.BlockType] = tileWidth.map({_ in .double}) + [.block, .blockCustom(width: 200)]
		let sut = HorizontalTileGrid(blocks: blocks)

		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		let containerPosition = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: .init(origin: .zero, size: size), proposal: .init(width: size.width, height: size.height), blocks: blocks, cache: &cache)
		XCTAssertEqual(places[0], .init(origin: .init(x: cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[1], .init(origin: .init(x: cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[2], .init(origin: .init(x: cache.minimumSquare.width + cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[3], .init(origin: .init(x: cache.minimumSquare.width + cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[4], .init(origin: .init(x: cache.standardSquare.width + cache.standardSquare.width.half, y: containerPosition.midY), size: .init(width: 200, height: cache.standardSquare.height)))
		XCTAssertEqual(places[5], .init(origin: .init(x: (cache.standardSquare.width * 2) + 100 , y: containerPosition.midY), size: .init(width: 200, height: cache.standardSquare.height)))
	}

	func test_shouldPlaceTheItemsCorrectly_whenAMixOfTileItemsInsideAndContainerMinXIsNotZero() {
		let minimumSquare: CGSize = .init(width: 100, height: 100)
		let tileWidth: [CGFloat] = [minimumSquare.width, minimumSquare.width]
		let blocks: [HorizontalTileGrid.BlockType] = tileWidth.map({_ in .double}) + [.block, .blockCustom(width: 200), .double, .blockCustom(width: 242)]
		let sut = HorizontalTileGrid(blocks: blocks)

		var cache: HorizontalTileGrid.Cache = (standardSquare: sut.standardSquareSize(from: minimumSquare), minimumSquare: minimumSquare)
		let size = sut.sizeThatFitsBlocks(proposal: .init(width: 100, height: 100), blocks: blocks, cache: &cache)
		let containerPosition = CGRect(x: 100, y: 0, width: size.width, height: size.height)
		let places = sut.calculatePlaceSubviews(in: containerPosition, proposal: .init(width: size.width, height: size.height), blocks: blocks, cache: &cache)

		XCTAssertEqual(places[0], .init(origin: .init(x: containerPosition.minX + cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[1], .init(origin: .init(x: containerPosition.minX + cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[2], .init(origin: .init(x: containerPosition.minX + cache.minimumSquare.width + cache.minimumSquare.width.half, y: containerPosition.minY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[3], .init(origin: .init(x: containerPosition.minX + cache.minimumSquare.width + cache.minimumSquare.width.half, y: containerPosition.midY + cache.minimumSquare.height.half), size: cache.minimumSquare))
		XCTAssertEqual(places[4], .init(origin: .init(x: containerPosition.minX + cache.standardSquare.width + cache.standardSquare.width.half, y: containerPosition.midY), size: .init(width: 200, height: cache.standardSquare.height)))
		XCTAssertEqual(places[5], .init(origin: .init(x: containerPosition.minX + (cache.standardSquare.width * 2) + 100 , y: containerPosition.midY), size: .init(width: 200, height: cache.standardSquare.height)))
	}
}
