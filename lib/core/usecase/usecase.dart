/// A simple synchronous use case contract.
abstract class UseCase<Output, Params> {
  Future<Output> call(Params params);
}

/// Represents no parameters for a use case.
class NoParams {
  const NoParams();
}


