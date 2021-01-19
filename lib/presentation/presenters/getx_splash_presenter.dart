
import 'package:get/get.dart';
import 'package:survey/domain/usecases/usecases.dart';
import 'package:survey/ui/pages/splash/splash.dart';

class GetXSplashPresenter implements SplashPresenter {
	final LoadCurrentAccount localLoadCurrentAccount;
	
	var _navigateTo = RxString();
	
	GetXSplashPresenter(this.localLoadCurrentAccount);
	
	@override
	Future<void> checkAccount() async {
		try{
			final account = await localLoadCurrentAccount.load();
			if(account == null) _navigateTo.value = '/login';
			else _navigateTo.value = '/surveys';
		}catch(e){
			_navigateTo.value = '/login';
		}
		
	}
	
	@override
	Stream<String> get navigateToStream => _navigateTo.stream.distinct();
}
