import 'package:get/get.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/splash/splash.dart';

class GetXSplashPresenter implements SplashPresenter {
	final LoadCurrentAccount localLoadCurrentAccount;
	
	var _navigateTo = RxString();
	
	GetXSplashPresenter(this.localLoadCurrentAccount);
	
	@override
	Future<void> checkAccount({int durationInSeconds = 0}) async {
		await Future.delayed(Duration(seconds: durationInSeconds));
		try{
			final account = await localLoadCurrentAccount.load();
			if(account?.token ==null) {
			  _navigateTo.value = '/login';
			} else {
			  _navigateTo.value = '/surveys';
			}
		}catch(e){
			_navigateTo.value = '/login';
		}
		
	}
	
	@override
	Stream<String> get navigateToStream => _navigateTo.stream.distinct();
}
