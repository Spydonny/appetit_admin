import '../data/data.dart';

// MarketingService wrapping the repos
class MarketingService {
  final PromoRepo promoRepo;
  final PushRepo pushRepo;

  MarketingService({
    required this.promoRepo,
    required this.pushRepo,
  });

  // Promo-related methods
  Future<PromoGenerateResponse> generatePromos(PromoGenerateRequest request) async {
    return promoRepo.generatePromo(request);
  }

  Future<List<PromoOut>> listPromocodes({bool? active}) async {
    return promoRepo.listPromocodes(active: active);
  }

  Future<PromoOut> getPromocode(String code) async {
    return promoRepo.getPromocode(code);
  }

  Future<PromoOut> updatePromocode(String code, PromoUpdate payload) async {
    return promoRepo.updatePromocode(code, payload);
  }

  Future<void> deletePromocode(String code) async {
    return promoRepo.deletePromocode(code);
  }

  // Push-related methods
  Future<AdminPushResponse> sendPushNotification(AdminPushRequest request) async {
    return pushRepo.sendPush(request);
  }


  // Example combined method: Generate promos and send a push notification about them
  Future<Map<String, dynamic>> generateAndNotify({
    required PromoGenerateRequest promoRequest,
    required String pushTitle,
    required String pushBody,
    AdminPushTargeting? targeting,
  }) async {
    final promoResponse = await generatePromos(promoRequest);
    final pushRequest = AdminPushRequest(
      title: pushTitle,
      body: pushBody,
      targeting: targeting ?? const AdminPushTargeting(),
    );
    final pushResponse = await sendPushNotification(pushRequest);
    return {
      'promoResponse': promoResponse,
      'pushResponse': pushResponse,
    };
  }
}