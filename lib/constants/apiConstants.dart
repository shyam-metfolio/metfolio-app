bool testEnvironment = false;
String apiBaseUrl = testEnvironment
    ? 'https://test.metfolio.com/api/'
    : 'https://app.metfolio.com/api/';
const String SEND_OTP = 'user/send-otp';
const String VERIFY_OTP = 'user/verify-otp';
const String CHECK_API = 'user/check?auth_code=';
const String SIGNUP = 'user/update-profile?auth_code=';
const String LOGOUT = 'user/logout?auth_code=';
const String VERIFF = 'user/verify-session-url?auth_code=';
const String VERIFFCALLBACK = 'user/check-veriff-call-back?auth_code=';
const String CHECKUSER = 'user/check-user-registered-or-not';
const String ADDTOCART = 'user/add-to-cart?auth_code=';
const String MYORDERS = 'order/my-orders?auth_code=';
const String DELETECART = 'user/delete-cart?auth_code=';
const String CASHMODE = 'order/cash-mode?auth_code=';
const String TOTALGOLD =
    'user/total-physical-or-goal-gold-available?auth_code=';
const String ADDOREDITGOAL = 'user/add-or-edit-goal?auth_code=';
const String MYGOALS = 'user/my-goals?auth_code=';
const String GOLDSETTING = 'user/gold-setting';
const String GOLDWEIGHTRANGE = 'user/gold-weight-range';
const String MOVEGOLD = 'user/move-gold?auth_code=';
const String ADDADDRESS = 'user/add-or-update-delivery-address?auth_code=';
const String MYADDRESS = 'user/my-address?auth_code=';
const String BUYGOLD = 'user/buy-gold?auth_code=';
const String CREATEGOALPAYMENT = 'user/create-payment-method?auth_code=';
const String COMFIRMGOALPAYMENT = 'user/conform-subscription?auth_code=';
const String GOLDPRICE = 'user/gold-prices?auth_code=';
const String PAYMENTMETHODATTCH = 'user/attach-card-to-customer?auth_code=';
const String ADDBANKACCOUNT = 'user/create-bank-details?auth_code=';
const String BANKDETAILS = 'user/bank-account-list?auth_code=';
const String CREATECUSTOMER = "user/create-customer?auth_code=";
const String VERIFYEMAIL = 'user/verify-email-otp?auth_code=';
const String SENDEMAILOTP = 'user/send-email-otp?auth_code=';
const String GOLDDELIVERY = 'user/delivery-gold?auth_code=';
const String CREATEPAYMENTINTENT = 'payment/create-payment-intents?auth_code=';
const String CREATECVCTOKEN = 'user/cvc-token?auth_code=';
const String CONFIRMPAYMENTINTENT =
    'payment/conform-payment-intents?auth_code=';
const String CHECKMPAYMENTSTATUS =
    'payment/check-payment-intant-status?auth_code=';
const String PASSCODEOTPVERIFY = 'user/verify-pass-code-otp?auth_code=';
const String SELLGOLD = 'user/sell-gold?auth_code=';
const String ENABLEORDISABLE = 'user/enable-or-disable-notification?auth_code=';

const String DELETEACCOUNT = 'user/delete-account?auth_code=';
