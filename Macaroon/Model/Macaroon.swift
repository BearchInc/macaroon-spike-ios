import Foundation

class Macaroon {

	var serialized: String!
	var m: COpaquePointer?
	
//
	static func create() -> Macaroon {
//
		let location = "www.heck.com"
		let locationSize = location.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		
		let secretKey = "Hsenhra secreta"
		let secretKeySize = secretKey.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		
		let publicKey = "Ksenha loca publica"
		let publicKeySize = publicKey.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		
		let error = UnsafeMutablePointer<macaroon_returncode>()
		
		let macaroon = Macaroon()
		
		macaroon.m = macaroon_create(location, locationSize, secretKey, secretKeySize, publicKey, publicKeySize, error)
		
		print("Macarrao loco \(macaroon)")
		return macaroon
	}
	
	func identifier() -> String {
		let id = UnsafeMutablePointer<UnsafePointer<UInt8>>.alloc(10000)
		let idSize = UnsafeMutablePointer<Int>.alloc(100000)
		
		macaroon_identifier(m!, id, idSize)
		
		let b = UnsafePointer<CChar>(id.memory)
		let result = String.fromCString(b)
		print("->> \(result)")
		return result!
	}
	

//	>>> M.identifier
	
//	def identifier(self):
//	cdef const unsigned char* identifier = NULL
//	cdef size_t identifier_sz = 0
//	self.assert_not_null()
//	macaroon_identifier(self._M, &identifier, &identifier_sz)
//	return identifier[:identifier_sz]
	
	
}
