/// Abstract base class for operation results.
///
/// This class represents the result of an operation that can either succeed
/// or fail. It follows the Result pattern to handle errors explicitly
/// without throwing exceptions.
///
/// Subclasses:
/// - [Success]: Represents a successful operation with optional data
/// - [Failure]: Represents a failed operation with error information
///
/// This pattern provides type-safe error handling and makes error states
/// explicit in the code, improving code readability and maintainability.
///
/// Example:
/// ```dart
/// Result result = await repository.getData();
/// if (result is Success) {
///   // Handle success
/// } else if (result is Failure) {
///   // Handle failure
/// }
/// ```
///
/// Type parameter:
/// - [T]: The type of data returned on success
abstract class Result<T> {

}