import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Centralized icon definitions using Lucide Icons
/// Usage: AppIcons.store, AppIcons.search, etc.
class AppIcons {
  AppIcons._();

  // Navigation & Actions
  static const IconData menu = LucideIcons.menu;
  static const IconData close = LucideIcons.x;
  static const IconData back = LucideIcons.arrowLeft;
  static const IconData forward = LucideIcons.arrowRight;
  static const IconData search = LucideIcons.search;
  static const IconData filter = LucideIcons.listFilter;
  static const IconData settings = LucideIcons.settings;
  static const IconData more = LucideIcons.ellipsisVertical;
  static const IconData moreHorizontal = LucideIcons.ellipsis;
  static const IconData moreVertical = LucideIcons.ellipsisVertical;

  // CRUD Actions
  static const IconData add = LucideIcons.plus;
  static const IconData edit = LucideIcons.pencil;
  static const IconData delete = LucideIcons.trash2;
  static const IconData save = LucideIcons.save;
  static const IconData cancel = LucideIcons.x;
  static const IconData check = LucideIcons.check;
  static const IconData checkCircle = LucideIcons.circleCheck;

  // Business - Shop & Products
  static const IconData store = LucideIcons.store;
  static const IconData package = LucideIcons.package;
  static const IconData shoppingCart = LucideIcons.shoppingCart;
  static const IconData shoppingBag = LucideIcons.shoppingBag;
  static const IconData tag = LucideIcons.tag;
  static const IconData barcode = LucideIcons.barcode;
  static const IconData box = LucideIcons.box;

  // Financial
  static const IconData rupee = LucideIcons.indianRupee;
  static const IconData cash = LucideIcons.banknote;
  static const IconData credit = LucideIcons.creditCard;
  static const IconData creditCard = LucideIcons.creditCard;
  static const IconData wallet = LucideIcons.wallet;
  static const IconData trendingUp = LucideIcons.trendingUp;
  static const IconData trendingDown = LucideIcons.trendingDown;
  static const IconData pieChart = LucideIcons.chartPie;
  static const IconData barChart = LucideIcons.chartBarBig;
  static const IconData dollarSign = LucideIcons.dollarSign;

  // Customers & People
  static const IconData user = LucideIcons.user;
  static const IconData users = LucideIcons.users;
  static const IconData userPlus = LucideIcons.userPlus;
  static const IconData userCheck = LucideIcons.userCheck;

  // Inventory & Stock
  static const IconData packageCheck = LucideIcons.packageCheck;
  static const IconData packageX = LucideIcons.packageX;
  static const IconData packagePlus = LucideIcons.packagePlus;
  static const IconData packageMinus = LucideIcons.packageMinus;
  static const IconData warehouse = LucideIcons.warehouse;

  // Status & Alerts
  static const IconData alertCircle = LucideIcons.circleAlert;
  static const IconData alertTriangle = LucideIcons.triangleAlert;
  static const IconData info = LucideIcons.info;
  static const IconData help = LucideIcons.circleQuestionMark;
  static const IconData success = LucideIcons.circleCheck;
  static const IconData error = LucideIcons.circleX;
  static const IconData warning = LucideIcons.triangleAlert;

  // Date & Time
  static const IconData calendar = LucideIcons.calendar;
  static const IconData clock = LucideIcons.clock;
  static const IconData calendarDays = LucideIcons.calendarDays;

  // Documents & Reports
  static const IconData document = LucideIcons.file;
  static const IconData receipt = LucideIcons.receipt;
  static const IconData fileText = LucideIcons.fileText;
  static const IconData clipboard = LucideIcons.clipboard;
  static const IconData download = LucideIcons.download;
  static const IconData upload = LucideIcons.upload;
  static const IconData print = LucideIcons.printer;
  static const IconData inbox = LucideIcons.inbox;
  static const IconData history = LucideIcons.history;
  static const IconData image = LucideIcons.image;
  static const IconData folder = LucideIcons.folder;

  // Dashboard & Analytics
  static const IconData dashboard = LucideIcons.layoutDashboard;
  static const IconData analytics = LucideIcons.chartBarBig;
  static const IconData activity = LucideIcons.activity;
  static const IconData barChart3 = LucideIcons.chartBarBig;

  // Data Management
  static const IconData database = LucideIcons.database;
  static const IconData cloud = LucideIcons.cloud;
  static const IconData cloudUpload = LucideIcons.cloudUpload;
  static const IconData cloudDownload = LucideIcons.cloudDownload;
  static const IconData backup = LucideIcons.save;
  static const IconData restore = LucideIcons.rotateCcw;
  static const IconData sync = LucideIcons.refreshCw;

  // Visibility
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;
  static const IconData visible = LucideIcons.eye;
  static const IconData hidden = LucideIcons.eyeOff;

  // Communication
  static const IconData phone = LucideIcons.phone;
  static const IconData mail = LucideIcons.mail;
  static const IconData message = LucideIcons.messageSquare;
  static const IconData notification = LucideIcons.bell;
  static const IconData location = LucideIcons.mapPin;

  // Misc
  static const IconData home = LucideIcons.house;
  static const IconData rocket = LucideIcons.rocket;
  static const IconData star = LucideIcons.star;
  static const IconData starFilled = LucideIcons.star;
  static const IconData heart = LucideIcons.heart;
  static const IconData palette = LucideIcons.palette;
  static const IconData shield = LucideIcons.shield;
  static const IconData wrench = LucideIcons.wrench;
  static const IconData lock = LucideIcons.lock;
  static const IconData unlock = LucideIcons.lockOpen;
  static const IconData language = LucideIcons.globe;

  // Profit/Loss (custom color indicators)
  static const IconData profit = LucideIcons.trendingUp;
  static const IconData loss = LucideIcons.trendingDown;
  static const IconData balance = LucideIcons.scale;

  // Units (Carton/Pieces)
  static const IconData carton = LucideIcons.package2;
  static const IconData pieces = LucideIcons.grid3x3;

  // Customer Ledger (Khata)
  static const IconData ledger = LucideIcons.book;
  static const IconData khata = LucideIcons.bookOpen;
  static const IconData payment = LucideIcons.banknote;

  // Stock Levels
  static const IconData lowStock = LucideIcons.packageX;
  static const IconData inStock = LucideIcons.packageCheck;
  static const IconData outOfStock = LucideIcons.packageMinus;

  // Payment & Cheque Status
  static const IconData paid = LucideIcons.circleCheck;
  static const IconData pending = LucideIcons.clock;
  static const IconData failed = LucideIcons.circleX;
  static const IconData overdue = LucideIcons.triangleAlert;
}
