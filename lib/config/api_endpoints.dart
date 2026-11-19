abstract final class ApiEndpoints {
  static const sendOtp = '/api/v1/users/otp/send/';
  static const register = '/api/v1/users/register/';
  static const login = '/api/v1/users/login/';
  static const logout = '/api/v1/users/logout/';
  static const profile = '/api/v1/users/profile/';
  static const password = '/api/v1/users/password/';
  static const paymentMethods = '/api/v1/users/payment-methods/';
  static const deleteAccount = '/api/v1/users/account/delete/';

  static String paymentMethod(int id) => '/api/v1/users/payment-methods/$id/';

  static const products = '/api/v1/products/';
  static const myProducts = '/api/v1/products/mine/';
  static const productVerification = '/api/v1/products/admin/verification/';
  static const ecoFeatures = '/api/v1/products/eco-features/';

  static String product(String id) => '/api/v1/products/$id/';
  static String myProduct(String id) => '/api/v1/products/mine/$id/';
  static String productVerificationDetail(String id) =>
      '/api/v1/products/admin/verification/$id/';

  static const myReviews = '/api/v1/reviews/saya/';
  static const reviewReports = '/api/v1/reviews/laporan/';

  static String storeReviews(int storeId) => '/api/v1/reviews/toko/$storeId/';
  static String review(int reviewId) => '/api/v1/reviews/$reviewId/';
  static String reviewReply(int reviewId) =>
      '/api/v1/reviews/$reviewId/balasan/';
  static String reportReview(int reviewId) =>
      '/api/v1/reviews/$reviewId/laporan/';
  static String reviewReport(int reportId) =>
      '/api/v1/reviews/laporan/$reportId/';

  static const cart = '/api/v1/checkout/cart/';
  static const cartItems = '/api/v1/checkout/cart/items/';
  static const cartSelection = '/api/v1/checkout/cart/selection/';
  static const checkoutSummary = '/api/v1/checkout/summary/';
  static const orders = '/api/v1/checkout/orders/';

  static String cartItem(int itemId) => '/api/v1/checkout/cart/items/$itemId/';
  static String order(int orderId) => '/api/v1/checkout/orders/$orderId/';

  static const sellerSummary = '/api/v1/dashboard/seller/summary/';
  static const salesReport = '/api/v1/dashboard/sales-report/';

  static const chatSellersSearch = '/api/v1/chat/sellers/search/';
  static const chatAiSessions = '/api/v1/chat/sessions/ai/';
  static const buyerChatSessions = '/api/v1/chat/buyer/sessions/';
  static const sellerChatSessions = '/api/v1/chat/seller/sessions/';
  static const sellerChatSettings = '/api/v1/chat/seller/settings/';
  static const sellerChatKnowledge = '/api/v1/chat/seller/knowledge/';
  static const chatReports = '/api/v1/chat/reports/';
  static const broadcastChannels = '/api/v1/chat/broadcast/channels/';
  static const broadcastChannelsExplore =
      '/api/v1/chat/broadcast/channels/explore/';

  static String chatSessionProducts(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/products/';
  static String chatSessionProductsDelete(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/products/delete/';
  static String chatSessionAiSend(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/send/';
  static String chatSessionEscalateToSeller(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/escalate-to-seller/';
  static String chatSessionSwitchToAi(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/switch-to-ai/';
  static String chatSessionMessages(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/messages/';
  static String chatSessionDirectSend(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/direct-send/';
  static String chatSessionArchive(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/archive/';
  static String chatSessionRating(String sessionId) =>
      '/api/v1/chat/sessions/$sessionId/rating/';

  static String sellerChatKnowledgeDetail(int knowledgeId) =>
      '/api/v1/chat/seller/knowledge/$knowledgeId/';
  static String sellerChatKnowledgeToggle(int knowledgeId) =>
      '/api/v1/chat/seller/knowledge/$knowledgeId/toggle/';

  static String broadcastChannelAdd(int channelId) =>
      '/api/v1/chat/broadcast/channels/$channelId/add/';
  static String broadcastChannelFollow(int channelId) =>
      '/api/v1/chat/broadcast/channels/$channelId/follow/';
  static String broadcastChannelArchive(int channelId) =>
      '/api/v1/chat/broadcast/channels/$channelId/archive/';
  static String broadcastChannelMessages(int channelId) =>
      '/api/v1/chat/broadcast/channels/$channelId/messages/';
  static String broadcastChannelSend(int channelId) =>
      '/api/v1/chat/broadcast/channels/$channelId/send/';
}
