protocol Product {
    func price() -> Int
    func name() -> String
}

class FullPriceProduct: Product {
    
    func price() -> Int {
        return 1000
    }
    
    func name() -> String {
        return "I'm a product"
    }
}

class DiscountedProductDecorator: Product {
    
    private let decoratedProduct: Product
    
    init(decoratedProduct: Product) {
        self.decoratedProduct = decoratedProduct
    }
    
    func price() -> Int {
        return Int(Float(decoratedProduct.price()) * 0.75)
    }
    
    func name() -> String {
        return decoratedProduct.name()
    }
}

class CheckoutManager {
    
    func checkout(product: Product) {
        let name = product.name()
        let price = Double(product.price() / 100)
        print("charging customer $\(price) for \(name)")
    }
}


let fullPriceProduct = FullPriceProduct()
let discountedProduct = DiscountedProductDecorator(decoratedProduct: fullPriceProduct)

let checkoutManager = CheckoutManager()

checkoutManager.checkout(product: fullPriceProduct)
checkoutManager.checkout(product: discountedProduct)
