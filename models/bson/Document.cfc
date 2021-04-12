/**
*
* @author pjacekm@gmail.com
* @description I represent org.bson.Document
*
*/

component output="false" accessors="true" {

	// Injected properties (DI)
	property name="JavaFactory" inject="JavaFactory@box-mongodb-sdk";
	property name="Util" inject="Util@box-mongodb-sdk";

	// Local properties
	property name="MongoDocument" type="any" default="";

	/**
	 * Constructor
	 */
	public function init(){
		return this;
	}




	/**
	 * Creates Document from struct
	 */
	public function initWithStruct(required struct map) {
		getMongoDocument().putAll(
			getUtil().toMongo(arguments.map)
		);

		return this;
	}




	/**
	 * Creates document with key-value data
	 */
	public function initWithKeyValue(required string key, required value) {
		return this.append(arguments.key, arguments.value);
	}




	/**
	 * Returns underlying java object. Used in util conversion methods.
	 */
	public any function getBaseJavaObject() {
		return getMongoDocument();
	}




	



	public function onDIComplete() {
		setMongoDocument(
			getJavaFactory().getJavaObject("org.bson.Document")
		);
		return this;
	}




	public Document function append(required string key, required any value) {
		getMongoDocument().append(
			javaCast("string", arguments.key), 
			getUtil().toMongo(arguments.value)
		);
		return this;
	}




	public Document function parse(required string json) {
		getMongoDocument().parse(arguments.json);
		return this;
	}




	/**
	 * Gets the value of the given key, or returning the default value if null. 
	 *
	 * @key The key
	 * @defaultValue What to return if the value is null
	 */
	public any function get(required string key, any defaultValue=javaCast("null", "")) {
		return isNull( getMongoDocument().get(javaCast("string", arguments.key)) ) ? (isNull(arguments.defaultValue) ? javaCast("null", "") : arguments.defaultValue) : getUtil().toCF( getMongoDocument().get(javaCast("string", arguments.key)) );
	}




	/**
	 * Gets the value in an embedded document, or returning the default value if null. The array of keys represents a path to the embedded value, drilling down into an embedded document for each key. So to get the embedded value, you would write: 
	 * 		`name = Document.getEmbedded(["employee", "manager", "name"], "John Smith")` 
	 * instead of: 
	 * 		`name = Document.get("employee").get("manager").get("name", "John Smith")`.
	 *
	 * @keys Array of keys
	 * @defaultValue What to return if the value is null
	 */
	public any function getEmbedded(required array keys, any defaultValue=""){
		if(!arguments.keys.len()){
			throw(type = "box-mongodb-sdk.invalidArgumentException", message = "Keys cannot be empty", detail="", errorCode = "error");
		}
		else{
			try {
				return getMongoDocument().getEmbedded(arguments.keys, arguments.defaultValue);
			}
			catch("java.lang.ClassCastException" e){
				return javacast("null", "");
			}
			catch (any e) {
				rethrow;
			}
			
		}
	}




	public function put(required string key, required any value) {
		return getMongoDocument().put(
			javaCast("string", arguments.key), 
			getUtil().toMongo(arguments.value)
		);
	}




	public void function clear() {
		getMongoDocument().clear();
	}




	public void function remove(required string key) {
		getMongoDocument().remove(arguments.key);
	}




	public numeric function size() {
		return getMongoDocument().size();
	}




	public boolean function isEmpty() {
		return getMongoDocument().isEmpty();
	}




	/**
	 * Render into a BsonDocument.
	 * NOTE: currently returns Java object, consider wrapping in CF object.
	 */
	public function toBsonDocument(){
		return getMongoDocument().toBsonDocument();
	}




	/**
	 * Gets a JSON representation of this document.
	 */
	public string function toJson(){
		return getMongoDocument().toBsonDocument().toJson();
	}




	/**
	 * Returns numeric representation of the object. Used for e.g. comparisons.
	 */
	public numeric function hashCode(){
		return getMongoDocument().hashCode();
	}
}
