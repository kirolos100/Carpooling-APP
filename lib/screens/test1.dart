abstract class SoicalRegisterStates {}

class SoicalRegisterInitialStates extends SoicalRegisterStates {}

class SoicalRegisterLoadingStates extends SoicalRegisterStates {}

class SoicalRegisterSuccessStates extends SoicalRegisterStates {}



class SoicalRegisterErrorStates extends SoicalRegisterStates {
  final String error;
  SoicalRegisterErrorStates(this.error);
}
class SoicalCreteUserSuccessStates extends SoicalRegisterStates {}



class SoicalCreteUserErrorStates extends SoicalRegisterStates {
  final String error;
  SoicalCreteUserErrorStates(this.error);
}

class SoicalChangePasswordVisbility extends SoicalRegisterStates {}
