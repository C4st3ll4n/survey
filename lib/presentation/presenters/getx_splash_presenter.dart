import 'package:get/get.dart';
import 'package:survey/presentation/mixins/mixins.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/pages/splash/splash.dart';

class GetXSplashPresenter  extends GetxController with NavigationManager implements SplashPresenter {
	final LoadCurrentAccount localLoadCurrentAccount;
	GetXSplashPresenter(this.localLoadCurrentAccount);
	
	@override
	Future<void> checkAccount({int durationInSeconds = 0}) async {
		await Future.delayed(Duration(seconds: durationInSeconds));
		try{
			final account = await localLoadCurrentAccount.load();
			if(account?.token ==null) {
			  goTo = '/login';
			} else {
				goTo = '/surveys';
			}
		}catch(e){
			goTo = '/login';
		}
		
	}
	
	@override
	Stream<String> get navigateToStream => navigationStream;
}
