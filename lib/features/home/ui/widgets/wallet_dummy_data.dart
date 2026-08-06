import '../../data/models/subscriptions_model.dart';
import '../../data/models/wallet_transactions_model.dart';

final List<WalletTransactionsModel> dummyTransactions = [

  WalletTransactionsModel(

    id: 1,

    user: 3,

    userDetail: null,


    transactionType: "fund_approved",


    amount: 500.0,

    balanceAfter: 2500.0,


    playlist: null,

    playlistDetail: null,


    subscription: null,


    relatedUser: null,

    relatedUserDetail: null,


    note: "تمت إضافة رصيد للمحفظة",


    createdAt: "2026-08-06T15:30:14.094Z",

  ),




  WalletTransactionsModel(

    id: 2,

    user: 3,

    userDetail: null,


    transactionType: "subscription_purchase",


    amount: -300.0,


    balanceAfter: 2200.0,


    playlist: 1,


    playlistDetail: PlaylistDetailModel(

      id: 1,

      name: "Flutter for Beginners",

      description: "Learn Flutter from scratch",

      owner: null,

      category: "cs",

      subject: 3,

      subjectDetail: null,

      thumbnail: null,

      price: 300,

      totalVideoCount: 20,

      totalDuration: 600,

      studentsCount: 50,

      completionRate: 0,

      rating: 4.5,

      hasSubscription: true,

      hasActiveSubscription: true,

      canAccessContent: true,

      createdAt: "2026-08-01",

      updatedAt: "2026-08-01",

    ),


    subscription: 5,


    relatedUser: null,

    relatedUserDetail: null,


    note: "شراء اشتراك دورة Flutter",


    createdAt: "2026-08-05T12:20:00.000Z",

  ),





  WalletTransactionsModel(

    id: 3,

    user: 3,

    userDetail: null,


    transactionType: "refund",


    amount: 150.0,


    balanceAfter: 2350.0,


    playlist: 1,


    playlistDetail: PlaylistDetailModel(

      id: 2,

      name: "Python Advanced",

      description: "Advanced Python course",

      owner: null,

      category: "it",

      subject: 1,

      subjectDetail: null,

      thumbnail: null,

      price: 150,

      totalVideoCount: 15,

      totalDuration: 400,

      studentsCount: 20,

      completionRate: 0,

      rating: 5,

      hasSubscription: true,

      hasActiveSubscription: false,

      canAccessContent: false,

      createdAt: "2026-08-01",

      updatedAt: "2026-08-01",

    ),


    subscription: 8,


    relatedUser: null,

    relatedUserDetail: null,


    note: "إلغاء الاشتراك واسترجاع المبلغ",


    createdAt: "2026-08-04T09:10:00.000Z",

  ),

];